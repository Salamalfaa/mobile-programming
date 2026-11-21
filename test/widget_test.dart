import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugasmobileprogramingjamil/core/network/api_exception.dart';
import 'package:tugasmobileprogramingjamil/main.dart';
import 'package:tugasmobileprogramingjamil/models/book_model.dart';
import 'package:tugasmobileprogramingjamil/repositories/book_repository.dart';
import 'package:tugasmobileprogramingjamil/services/api_service.dart';
import 'package:tugasmobileprogramingjamil/viewmodels/book_vm.dart';
import 'package:tugasmobileprogramingjamil/viewmodels/providers.dart';
import 'package:tugasmobileprogramingjamil/views/books/book_form_dialog.dart';

Map<String, dynamic> bookJson(int id, {String title = 'Buku'}) => {
  'id': id,
  'title': '$title $id',
  'author': 'Penulis',
  'publisher': null,
  'isbn': 'ISBN$id',
  'published_year': 2005,
  'stock': 3,
  'description': null,
  'created_at': '2026-11-09T14:20:25.000000Z',
  'updated_at': '2026-11-09T14:20:25.000000Z',
};

class FakeBookRepository extends BookRepository {
  FakeBookRepository() : super(ApiService(Dio()));

  bool failCreate = false;

  @override
  Future<BookPage> getBooks({String? search, int page = 1}) async => BookPage(
    books: [
      for (var index = 1; index <= 2; index++)
        BookModel.fromJson(bookJson((page - 1) * 2 + index)),
    ],
    currentPage: page,
    lastPage: 2,
    total: 4,
  );

  @override
  Future<BookModel> createBook(Map<String, dynamic> payload) async {
    if (failCreate) {
      throw const ApiException(
        'The isbn has already been taken.',
        statusCode: 422,
        fieldErrors: {'isbn': 'The isbn has already been taken.'},
      );
    }
    return BookModel.fromJson({...bookJson(99), ...payload});
  }

  @override
  Future<void> deleteBook(int id) async {}
}

void main() {
  group('Model dan respons API', () {
    test('BookPage membaca data dan metadata paginasi Laravel', () {
      final page = BookPage.fromJson({
        'data': [bookJson(1), bookJson(2)],
        'links': {},
        'meta': {'current_page': 1, 'last_page': 3, 'per_page': 2, 'total': 6},
      });

      expect(page.books, hasLength(2));
      expect(page.books.first.publishedYear, 2005);
      expect(page.hasMore, isTrue);
      expect(page.total, 6);
    });

    test('ApiException membaca error validasi 422', () {
      final request = RequestOptions(path: '/books');
      final error = ApiException.fromDio(
        DioException(
          requestOptions: request,
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: request,
            statusCode: 422,
            data: {
              'message': 'The isbn has already been taken.',
              'errors': {
                'isbn': ['The isbn has already been taken.'],
              },
            },
          ),
        ),
      );

      expect(error.statusCode, 422);
      expect(error.fieldErrors['isbn'], 'The isbn has already been taken.');
    });

    test('ApiException memberi pesan jelas saat server tidak terjangkau', () {
      final error = ApiException.fromDio(
        DioException(
          requestOptions: RequestOptions(path: '/login'),
          type: DioExceptionType.connectionError,
        ),
      );

      expect(error.message, contains('Tidak dapat terhubung'));
    });
  });

  group('BookNotifier', () {
    late ProviderContainer container;
    late FakeBookRepository repository;

    setUp(() {
      repository = FakeBookRepository();
      container = ProviderContainer(
        overrides: [bookRepositoryProvider.overrideWithValue(repository)],
      );
    });
    tearDown(() => container.dispose());

    test('loadMore menambahkan hasil halaman selanjutnya', () async {
      final notifier = container.read(bookProvider.notifier);
      await notifier.load();
      expect(container.read(bookProvider).books, hasLength(2));
      expect(container.read(bookProvider).hasMore, isTrue);

      await notifier.loadMore();
      final state = container.read(bookProvider);
      expect(state.books.map((book) => book.id), [1, 2, 3, 4]);
      expect(state.hasMore, isFalse);
    });

    test(
      'create gagal mempertahankan daftar dan mengembalikan error field',
      () async {
        final notifier = container.read(bookProvider.notifier);
        await notifier.load();
        repository.failCreate = true;

        final error = await notifier.create({'isbn': 'ISBN1'});
        final state = container.read(bookProvider);

        expect(error?.fieldErrors['isbn'], isNotNull);
        expect(state.books, hasLength(2));
        expect(state.error, isNull);
      },
    );

    test('delete menghapus buku dari daftar', () async {
      final notifier = container.read(bookProvider.notifier);
      await notifier.load();

      expect(await notifier.delete(1), isNull);
      expect(container.read(bookProvider).books.map((book) => book.id), [2]);
    });
  });

  testWidgets('aplikasi baru mengarahkan ke halaman login', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const ProviderScope(child: PerpusApp()));
    await tester.pumpAndSettle();

    expect(find.text('Selamat datang'), findsOneWidget);
    expect(find.text('Masuk'), findsOneWidget);
  });

  testWidgets('form buku menampilkan error ISBN dari backend', (tester) async {
    Map<String, dynamic>? sent;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BookFormDialog(
            onSubmit: (payload) async {
              sent = payload;
              return const ApiException(
                'ISBN duplikat',
                statusCode: 422,
                fieldErrors: {'isbn': 'ISBN sudah digunakan.'},
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Tambah'));
    await tester.pump();
    expect(find.text('Judul wajib diisi'), findsOneWidget);
    expect(sent, isNull);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Laskar Pelangi');
    await tester.enterText(fields.at(1), 'Andrea Hirata');
    await tester.enterText(fields.at(3), '9789793062792');
    await tester.enterText(fields.at(4), '2005');
    await tester.tap(find.text('Tambah'));
    await tester.pumpAndSettle();

    expect(sent?['published_year'], 2005);
    expect(sent?['publisher'], isNull);
    expect(find.text('ISBN sudah digunakan.'), findsOneWidget);
    expect(find.byType(BookFormDialog), findsOneWidget);
  });
}

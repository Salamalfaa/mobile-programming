import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/network/api_exception.dart';
import '../models/book_model.dart';
import '../repositories/book_repository.dart';
import 'providers.dart';

class BookState {
  final List<BookModel> books;
  final bool loading;
  final bool loadingMore;
  final String? error;
  final String search;
  final int page;
  final int lastPage;
  final int total;

  const BookState({
    this.books = const [],
    this.loading = false,
    this.loadingMore = false,
    this.error,
    this.search = '',
    this.page = 0,
    this.lastPage = 1,
    this.total = 0,
  });

  bool get hasMore => page < lastPage;

  BookState copyWith({
    List<BookModel>? books,
    bool? loading,
    bool? loadingMore,
    String? error,
    bool clearError = false,
    String? search,
    int? page,
    int? lastPage,
    int? total,
  }) => BookState(
    books: books ?? this.books,
    loading: loading ?? this.loading,
    loadingMore: loadingMore ?? this.loadingMore,
    error: clearError ? null : (error ?? this.error),
    search: search ?? this.search,
    page: page ?? this.page,
    lastPage: lastPage ?? this.lastPage,
    total: total ?? this.total,
  );
}

class BookNotifier extends Notifier<BookState> {
  int _requestId = 0;

  @override
  BookState build() => const BookState();

  BookRepository get _repo => ref.read(bookRepositoryProvider);

  Future<void> load({String? search}) async {
    final query = (search ?? state.search).trim();
    final requestId = ++_requestId;
    state = state.copyWith(
      loading: true,
      loadingMore: false,
      clearError: true,
      search: query,
    );
    try {
      final result = await _repo.getBooks(search: query, page: 1);
      if (requestId != _requestId) return;
      state = BookState(
        books: result.books,
        search: query,
        page: result.currentPage,
        lastPage: result.lastPage,
        total: result.total,
      );
    } on ApiException catch (error) {
      if (requestId != _requestId) return;
      state = state.copyWith(loading: false, error: error.message);
    }
  }

  Future<String?> loadMore() async {
    if (state.loading || state.loadingMore || !state.hasMore) return null;
    final requestId = _requestId;
    state = state.copyWith(loadingMore: true);
    try {
      final result = await _repo.getBooks(
        search: state.search,
        page: state.page + 1,
      );
      if (requestId != _requestId) return null;
      final knownIds = state.books.map((book) => book.id).toSet();
      state = state.copyWith(
        books: [
          ...state.books,
          ...result.books.where((book) => !knownIds.contains(book.id)),
        ],
        loadingMore: false,
        page: result.currentPage,
        lastPage: result.lastPage,
        total: result.total,
      );
      return null;
    } on ApiException catch (error) {
      if (requestId == _requestId) {
        state = state.copyWith(loadingMore: false);
      }
      return error.message;
    }
  }

  Future<ApiException?> create(Map<String, dynamic> payload) async {
    try {
      final book = await _repo.createBook(payload);
      state = state.copyWith(
        books: [book, ...state.books],
        total: state.total + 1,
      );
      return null;
    } on ApiException catch (error) {
      return error;
    }
  }

  Future<ApiException?> update(int id, Map<String, dynamic> payload) async {
    try {
      final updated = await _repo.updateBook(id, payload);
      state = state.copyWith(
        books: state.books
            .map((book) => book.id == id ? updated : book)
            .toList(),
      );
      return null;
    } on ApiException catch (error) {
      return error;
    }
  }

  Future<String?> delete(int id) async {
    try {
      await _repo.deleteBook(id);
    } on ApiException catch (error) {
      if (error.statusCode != 404) return error.message;
    }
    state = state.copyWith(
      books: state.books.where((book) => book.id != id).toList(),
      total: state.total > 0 ? state.total - 1 : 0,
    );
    return null;
  }

  void reset() {
    _requestId++;
    state = const BookState();
  }
}

final bookProvider = NotifierProvider<BookNotifier, BookState>(
  BookNotifier.new,
);

int _toInt(Object? value) =>
    value is num ? value.toInt() : int.parse(value.toString());

class BookModel {
  final int id;
  final String title;
  final String author;
  final String? publisher;
  final String isbn;
  final int publishedYear;
  final int stock;
  final String? description;

  const BookModel({
    required this.id,
    required this.title,
    required this.author,
    this.publisher,
    required this.isbn,
    required this.publishedYear,
    required this.stock,
    this.description,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) => BookModel(
    id: _toInt(json['id']),
    title: json['title'] as String,
    author: json['author'] as String,
    publisher: json['publisher'] as String?,
    isbn: json['isbn'] as String,
    publishedYear: _toInt(json['published_year']),
    stock: _toInt(json['stock']),
    description: json['description'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'author': author,
    'publisher': publisher,
    'isbn': isbn,
    'published_year': publishedYear,
    'stock': stock,
    'description': description,
  };
}

class BookPage {
  final List<BookModel> books;
  final int currentPage;
  final int lastPage;
  final int total;

  const BookPage({
    required this.books,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  bool get hasMore => currentPage < lastPage;

  factory BookPage.fromJson(Map<String, dynamic> json) {
    final books = (json['data'] as List)
        .map((item) => BookModel.fromJson(item as Map<String, dynamic>))
        .toList();
    final meta = json['meta'] as Map<String, dynamic>?;
    return BookPage(
      books: books,
      currentPage: meta == null ? 1 : _toInt(meta['current_page']),
      lastPage: meta == null ? 1 : _toInt(meta['last_page']),
      total: meta == null ? books.length : _toInt(meta['total']),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/network/api_exception.dart';
import '../../models/book_model.dart';

typedef BookSubmit = Future<ApiException?> Function(
  Map<String, dynamic> payload,
);

class BookFormDialog extends StatefulWidget {
  final BookModel? book;
  final BookSubmit onSubmit;

  const BookFormDialog({super.key, this.book, required this.onSubmit});

  @override
  State<BookFormDialog> createState() => _BookFormDialogState();
}

class _BookFormDialogState extends State<BookFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _authorCtrl;
  late final TextEditingController _publisherCtrl;
  late final TextEditingController _isbnCtrl;
  late final TextEditingController _yearCtrl;
  late final TextEditingController _stockCtrl;
  late final TextEditingController _descriptionCtrl;

  bool _saving = false;
  String? _error;
  Map<String, String> _fieldErrors = const {};

  @override
  void initState() {
    super.initState();
    final book = widget.book;
    _titleCtrl = TextEditingController(text: book?.title ?? '');
    _authorCtrl = TextEditingController(text: book?.author ?? '');
    _publisherCtrl = TextEditingController(text: book?.publisher ?? '');
    _isbnCtrl = TextEditingController(text: book?.isbn ?? '');
    _yearCtrl = TextEditingController(
      text: book?.publishedYear.toString() ?? '',
    );
    _stockCtrl = TextEditingController(text: book?.stock.toString() ?? '0');
    _descriptionCtrl = TextEditingController(text: book?.description ?? '');
  }

  @override
  void dispose() {
    for (final controller in [
      _titleCtrl,
      _authorCtrl,
      _publisherCtrl,
      _isbnCtrl,
      _yearCtrl,
      _stockCtrl,
      _descriptionCtrl,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  String? _nullIfEmpty(String value) =>
      value.trim().isEmpty ? null : value.trim();

  Future<void> _submit() async {
    if (_saving || !_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
      _fieldErrors = const {};
    });

    final error = await widget.onSubmit({
      'title': _titleCtrl.text.trim(),
      'author': _authorCtrl.text.trim(),
      'publisher': _nullIfEmpty(_publisherCtrl.text),
      'isbn': _isbnCtrl.text.trim(),
      'published_year': int.parse(_yearCtrl.text.trim()),
      'stock': int.parse(_stockCtrl.text.trim()),
      'description': _nullIfEmpty(_descriptionCtrl.text),
    });

    if (!mounted) return;
    if (error == null) {
      Navigator.pop(context, true);
    } else {
      setState(() {
        _saving = false;
        _fieldErrors = error.fieldErrors;
        _error = error.fieldErrors.isEmpty ? error.message : null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.book != null;
    final maxYear = DateTime.now().year;
    return AlertDialog(
      title: Text(isEdit ? 'Edit Buku' : 'Tambah Buku'),
      content: SizedBox(
        width: 440,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      _error!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                _field(
                  _titleCtrl,
                  'Judul',
                  'title',
                  required: true,
                  maxLength: 255,
                ),
                _field(
                  _authorCtrl,
                  'Penulis',
                  'author',
                  required: true,
                  maxLength: 255,
                ),
                _field(_publisherCtrl, 'Penerbit', 'publisher', maxLength: 255),
                _field(
                  _isbnCtrl,
                  'ISBN',
                  'isbn',
                  required: true,
                  maxLength: 20,
                ),
                _field(
                  _yearCtrl,
                  'Tahun terbit',
                  'published_year',
                  required: true,
                  digitsOnly: true,
                  validator: (value) {
                    final year = int.tryParse(value);
                    if (year == null || year < 1000 || year > maxYear) {
                      return 'Tahun harus antara 1000 dan $maxYear';
                    }
                    return null;
                  },
                ),
                _field(
                  _stockCtrl,
                  'Stok',
                  'stock',
                  required: true,
                  digitsOnly: true,
                  validator: (value) => int.tryParse(value) == null
                      ? 'Stok harus angka ≥ 0'
                      : null,
                ),
                _field(
                  _descriptionCtrl,
                  'Deskripsi',
                  'description',
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context, false),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: _saving ? null : _submit,
          child: _saving
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(isEdit ? 'Simpan' : 'Tambah'),
        ),
      ],
    );
  }

  Widget _field(
    TextEditingController controller,
    String label,
    String apiField, {
    bool required = false,
    bool digitsOnly = false,
    int maxLines = 1,
    int? maxLength,
    String? Function(String value)? validator,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: TextFormField(
      controller: controller,
      enabled: !_saving,
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
        errorText: _fieldErrors[apiField],
        counterText: '',
      ),
      keyboardType: digitsOnly ? TextInputType.number : TextInputType.text,
      inputFormatters: digitsOnly
          ? [FilteringTextInputFormatter.digitsOnly]
          : null,
      maxLines: maxLines,
      maxLength: maxLength,
      validator: (value) {
        final text = value?.trim() ?? '';
        if (required && text.isEmpty) return '$label wajib diisi';
        if (text.isNotEmpty && validator != null) return validator(text);
        return null;
      },
    ),
  );
}

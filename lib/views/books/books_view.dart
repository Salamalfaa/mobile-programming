import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/routes/app_router.dart';
import '../../core/theme/app_theme.dart';
import '../../models/book_model.dart';
import '../../viewmodels/auth_vm.dart';
import '../../viewmodels/book_vm.dart';
import '../../widgets/book_card.dart';
import '../../widgets/responsive_layout.dart';
import 'book_form_dialog.dart';

class BooksView extends ConsumerStatefulWidget {
  const BooksView({super.key});

  @override
  ConsumerState<BooksView> createState() => _BooksViewState();
}

class _BooksViewState extends ConsumerState<BooksView> {
  final _searchCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  BookNotifier get _vm => ref.read(bookProvider.notifier);

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_onScroll);
    Future.microtask(() => _vm.load(search: ''));
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _scrollCtrl
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollCtrl.hasClients && _scrollCtrl.position.extentAfter < 300) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    final error = await _vm.loadMore();
    if (error != null) _toast(error, isError: true);
  }

  void _toast(String message, {bool isError = false}) {
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Theme.of(context).colorScheme.error : null,
        ),
      );
  }

  Future<void> _openForm([BookModel? book]) async {
    final saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      animationStyle: AppTheme.dialogAnimation,
      builder: (_) => BookFormDialog(
        book: book,
        onSubmit: (payload) =>
            book == null ? _vm.create(payload) : _vm.update(book.id, payload),
      ),
    );
    if (saved == true) {
      _toast(book == null ? 'Buku berhasil ditambahkan' : 'Perubahan disimpan');
    }
  }

  Future<void> _confirmDelete(BookModel book) async {
    final confirmed = await showDialog<bool>(
      context: context,
      animationStyle: AppTheme.dialogAnimation,
      builder: (dialogContext) => AlertDialog(
        icon: Center(
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(17),
            ),
            child: Icon(
              Icons.delete_outline_rounded,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ),
        title: const Text('Hapus buku?', textAlign: TextAlign.center),
        content: Text(
          '“${book.title}” akan dihapus dari koleksi perpustakaan.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Ya, hapus'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final error = await _vm.delete(book.id);
    _toast(error ?? 'Buku dihapus', isError: error != null);
  }

  Future<void> _logout() async {
    await ref.read(authProvider.notifier).logout();
    _vm.reset();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (_) => false);
  }

  Widget _body(BookState state) {
    if (state.loading && state.books.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.error != null && state.books.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.cloud_off_rounded,
                size: 48,
                color: Theme.of(context).colorScheme.outline,
              ),
              const SizedBox(height: 12),
              Text(state.error!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => _vm.load(),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Coba lagi'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _vm.load(),
      child: state.books.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 72),
                Center(
                  child: Container(
                    width: 78,
                    height: 78,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: Icon(
                      Icons.auto_stories_rounded,
                      size: 36,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Center(
                  child: Text(
                    state.search.isEmpty
                        ? 'Koleksi masih kosong'
                        : 'Buku tidak ditemukan',
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 6),
                Center(
                  child: Text(
                    state.search.isEmpty
                        ? 'Tambahkan buku pertama untuk mulai mengelola koleksi.'
                        : 'Coba kata kunci lain untuk menemukan buku.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                if (state.search.isEmpty) ...[
                  const SizedBox(height: 18),
                  Center(
                    child: FilledButton.icon(
                      onPressed: () => _openForm(),
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Tambah buku'),
                    ),
                  ),
                ],
              ],
            )
          : ListView.separated(
              controller: _scrollCtrl,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              itemCount: state.books.length + 1,
              separatorBuilder: (_, _) => const SizedBox(height: 6),
              itemBuilder: (context, index) {
                if (index == state.books.length) return _footer(state);
                final book = state.books[index];
                return BookCard(
                  key: ValueKey(book.id),
                  book: book,
                  onEdit: () => _openForm(book),
                  onDelete: () => _confirmDelete(book),
                );
              },
            ),
    );
  }

  Widget _footer(BookState state) {
    if (state.loadingMore) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (state.hasMore) {
      return Center(
        child: TextButton(
          onPressed: _loadMore,
          child: const Text('Muat lebih banyak'),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Center(
        child: Text(
          '${state.books.length} dari ${state.total} buku',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookProvider);
    ref.listen(bookProvider.select((value) => value.error), (_, error) {
      if (error != null && ref.read(bookProvider).books.isNotEmpty) {
        _toast(error, isError: true);
      }
    });
    final userName =
        ref.watch(authProvider.select((value) => value.user?.name)) ?? '';

    final appBar = AppBar(
      title: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              Icons.auto_stories_rounded,
              size: 21,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 11),
          const Expanded(
            child: Text(
              'Perpustakaan',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      bottom: state.loading && state.books.isNotEmpty
          ? const PreferredSize(
              preferredSize: Size.fromHeight(2),
              child: LinearProgressIndicator(minHeight: 2),
            )
          : null,
      actions: [
        IconButton(
          tooltip: 'Muat ulang',
          onPressed: state.loading ? null : () => _vm.load(),
          icon: const Icon(Icons.refresh_rounded),
        ),
        IconButton(
          tooltip: 'Logout',
          onPressed: _logout,
          icon: const Icon(Icons.logout_rounded),
        ),
      ],
    );
    final search = Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
      child: TextField(
        controller: _searchCtrl,
        textInputAction: TextInputAction.search,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          hintText: 'Cari judul atau penulis',
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: _searchCtrl.text.isEmpty
              ? null
              : IconButton(
                  tooltip: 'Hapus pencarian',
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () {
                    _searchCtrl.clear();
                    _vm.load(search: '');
                    setState(() {});
                  },
                ),
        ),
        onSubmitted: (value) => _vm.load(search: value),
      ),
    );
    final header = Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Koleksi buku',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.65,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Temukan dan kelola koleksi perpustakaan.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(99),
            ),
            child: Text(
              '${state.total} buku',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
    final fab = FloatingActionButton.extended(
      onPressed: () => _openForm(),
      icon: const Icon(Icons.add_rounded),
      label: const Text('Tambah buku'),
    );
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        header,
        search,
        Expanded(child: _body(state)),
      ],
    );

    return ResponsiveLayout(
      mobile: Scaffold(
        appBar: appBar,
        body: content,
        floatingActionButton: fab,
      ),
      desktop: Scaffold(
        appBar: appBar,
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: 0,
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.library_books_outlined),
                  selectedIcon: Icon(Icons.library_books_rounded),
                  label: Text('Buku'),
                ),
              ],
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    CircleAvatar(
                      child: Text(
                        userName.isEmpty ? '?' : userName[0].toUpperCase(),
                      ),
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: 72,
                      child: Text(
                        userName,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const VerticalDivider(width: 1),
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 980),
                  child: content,
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: fab,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/routes/app_router.dart';
import '../../viewmodels/auth_vm.dart';
import '../../widgets/auth_scaffold.dart';

class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({super.key});

  @override
  ConsumerState<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends ConsumerState<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await ref
        .read(authProvider.notifier)
        .register(
          _nameCtrl.text.trim(),
          _emailCtrl.text.trim(),
          _passwordCtrl.text,
          _confirmCtrl.text,
        );
    if (success && mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.books);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final fields = auth.fieldErrors;
    return AuthScaffold(
      title: 'Buat akun baru',
      error: fields.isEmpty ? auth.error : null,
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: InputDecoration(
                  labelText: 'Nama',
                  prefixIcon: const Icon(Icons.person_outline_rounded),
                  errorText: fields['name'],
                ),
                textInputAction: TextInputAction.next,
                maxLength: 100,
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Nama wajib diisi'
                    : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailCtrl,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.alternate_email_rounded),
                  errorText: fields['email'],
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  final email = value?.trim() ?? '';
                  if (email.isEmpty) return 'Email wajib diisi';
                  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
                    return 'Email tidak valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _passwordCtrl,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  errorText: fields['password'],
                  suffixIcon: IconButton(
                    tooltip: _obscure
                        ? 'Tampilkan password'
                        : 'Sembunyikan password',
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
                obscureText: _obscure,
                textInputAction: TextInputAction.next,
                validator: (value) => value == null || value.length < 8
                    ? 'Password minimal 8 karakter'
                    : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _confirmCtrl,
                decoration: const InputDecoration(
                  labelText: 'Konfirmasi password',
                  prefixIcon: Icon(Icons.lock_reset_rounded),
                ),
                obscureText: _obscure,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
                validator: (value) =>
                    value != _passwordCtrl.text ? 'Password tidak cocok' : null,
              ),
              const SizedBox(height: 24),
              LoadingButton(
                loading: auth.loading,
                label: 'Daftar',
                onPressed: _submit,
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  ref.read(authProvider.notifier).clearError();
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                },
                child: const Text('Sudah punya akun? Masuk'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ============================================================
//  widgetlayout.dart
//  Seluruh project UI: design tokens, komponen, layout, halaman.
//  Terinspirasi Tailwind (token warna/spasi/radius) dan
//  Bootstrap 5.3 (breakpoint, form-label, btn, alert, badge).
// ============================================================
import 'dart:ui';

import 'package:flutter/material.dart';

// ------------------------------------------------------------
// 1. DESIGN TOKENS
// ------------------------------------------------------------

/// Token ala Tailwind: palet warna, skala spasi 4px, radius.
class TW {
  // slate
  static const slate950 = Color(0xFF020617);
  static const slate900 = Color(0xFF0F172A);
  static const slate800 = Color(0xFF1E293B);
  static const slate700 = Color(0xFF334155);
  static const slate500 = Color(0xFF64748B);
  static const slate400 = Color(0xFF94A3B8);
  static const slate300 = Color(0xFFCBD5E1);
  static const slate50 = Color(0xFFF8FAFC);
  // brand & status
  static const indigo500 = Color(0xFF6366F1);
  static const indigo400 = Color(0xFF818CF8);
  static const violet500 = Color(0xFF8B5CF6);
  static const sky400 = Color(0xFF38BDF8);
  static const emerald500 = Color(0xFF10B981);
  static const amber400 = Color(0xFFFBBF24);
  static const rose500 = Color(0xFFF43F5E);
  static const rose400 = Color(0xFFFB7185);

  // spacing (p-1 = 4px, p-2 = 8px, ...)
  static const double s1 = 4, s2 = 8, s3 = 12, s4 = 16, s5 = 20;
  static const double s6 = 24, s8 = 32, s10 = 40, s12 = 48;

  // radius (rounded-lg, rounded-xl, rounded-2xl)
  static const double rLg = 12, rXl = 16, r2xl = 24;
}

/// Breakpoint Bootstrap 5.3.
class BS {
  static const double sm = 576, md = 768, lg = 992, xl = 1200;
}

/// Helper opacity: `TW.indigo500.o(.3)`.
extension TwColor on Color {
  Color o(double opacity) => withAlpha((opacity * 255).round());
}

/// Gaya teks ala utility class Tailwind.
class TwText {
  static const display = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w800,
    color: TW.slate50,
    height: 1.15,
    letterSpacing: -1,
  );
  static const h2 = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: TW.slate50,
    letterSpacing: -0.5,
  );
  static const lead = TextStyle(fontSize: 16, color: TW.slate400, height: 1.6);
  static const body = TextStyle(fontSize: 14, color: TW.slate400, height: 1.5);
  static const label = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: TW.slate300,
  );
  static const xs = TextStyle(fontSize: 12, color: TW.slate500);
}

// ------------------------------------------------------------
// 2. APP & ROUTING
// ------------------------------------------------------------
class AuthApp extends StatelessWidget {
  const AuthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pinjam FTI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: TW.slate950,
        colorScheme: const ColorScheme.dark(primary: TW.indigo500),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: TW.indigo400,
        ),
      ),
      initialRoute: '/login',
      onGenerateRoute: _route,
    );
  }

  static Route<dynamic> _route(RouteSettings s) {
    final Widget page = switch (s.name) {
      '/register' => const RegisterPage(),
      '/forgot' => const ForgotPasswordPage(),
      _ => const LoginPage(),
    };
    return PageRouteBuilder(
      settings: s,
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, anim, secondaryAnim, child) {
        final curved = CurvedAnimation(parent: anim, curve: Curves.easeOut);
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.03),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );
  }
}

// ------------------------------------------------------------
// 3. LAYOUT (responsif: 1 kolom di HP, 2 kolom >= md)
// ------------------------------------------------------------

/// Latar gelap dengan cahaya gradasi (aurora).
class AuroraBackground extends StatelessWidget {
  final Widget child;
  const AuroraBackground({super.key, required this.child});

  Widget _glow(Color c, double size) => IgnorePointer(
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [c.o(.30), c.o(0)]),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TW.slate950,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(top: -140, left: -100, child: _glow(TW.indigo500, 460)),
          Positioned(
            bottom: -180,
            right: -120,
            child: _glow(TW.violet500, 500),
          ),
          Positioned.fill(child: child),
        ],
      ),
    );
  }
}

/// Kartu kaca (glassmorphism).
class GlassCard extends StatelessWidget {
  final Widget child;
  const GlassCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(TW.r2xl),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(TW.s8),
          decoration: BoxDecoration(
            color: TW.slate900.o(.65),
            borderRadius: BorderRadius.circular(TW.r2xl),
            border: Border.all(color: Colors.white.o(.08)),
          ),
          child: child,
        ),
      ),
    );
  }
}

class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(TW.rLg),
            gradient: const LinearGradient(
              colors: [TW.indigo500, TW.violet500],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: TW.indigo500.o(.4),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(Icons.bolt_rounded, color: Colors.white),
        ),
        const SizedBox(width: TW.s3),
        const Text(
          'Pinjam FTI',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: TW.slate50,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }
}

/// Panel kiri (hanya tampil di layar lebar).
class BrandPanel extends StatelessWidget {
  const BrandPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(TW.s12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BrandLogo(),
            const SizedBox(height: TW.s12),
            BsBadge(text: 'VERSI 1.0', color: TW.indigo400),
            const SizedBox(height: TW.s4),
            Text.rich(
              TextSpan(
                style: TwText.display,
                children: [
                  const TextSpan(text: 'Pinjam barang, '),
                  TextSpan(
                    text: 'kuliah lebih lancar.',
                    style: const TextStyle(color: TW.indigo400),
                  ),
                ],
              ),
            ),
            const SizedBox(height: TW.s4),
            const Text(
              'Peminjaman barang Fakultas Teknologi Informasi, praktis dan tercatat.',
              style: TwText.lead,
            ),
            const SizedBox(height: TW.s8),
            const _Feature(
              Icons.qr_code_scanner_rounded,
              'Validasi KTM mahasiswa FTI',
            ),
            const _Feature(
              Icons.inventory_2_outlined,
              'Cek ketersediaan barang',
            ),
            const _Feature(
              Icons.notifications_active_outlined,
              'Pengingat pengembalian',
            ),
          ],
        ),
      ),
    );
  }
}

class _Feature extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Feature(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TW.s3),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(TW.s2),
            decoration: BoxDecoration(
              color: TW.indigo500.o(.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: TW.indigo400),
          ),
          const SizedBox(width: TW.s3),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: TW.slate300,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Kerangka semua halaman auth.
class AuthScaffold extends StatelessWidget {
  final Widget child;
  const AuthScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuroraBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, c) {
              final wide = c.maxWidth >= BS.md;
              final form = Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(wide ? TW.s10 : TW.s5),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!wide) ...[
                          const BrandLogo(),
                          const SizedBox(height: TW.s6),
                        ],
                        GlassCard(child: child),
                        const SizedBox(height: TW.s6),
                        const Text(
                          'Peminjaman Barang TU Fakultas Teknologi Informasi',
                          style: TwText.xs,
                        ),
                      ],
                    ),
                  ),
                ),
              );
              if (!wide) return form;
              return Row(
                children: [
                  Expanded(
                    flex: c.maxWidth >= BS.lg ? 6 : 5,
                    child: const BrandPanel(),
                  ),
                  Expanded(flex: 5, child: form),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// 4. KOMPONEN (gaya Bootstrap)
// ------------------------------------------------------------

/// .badge .rounded-pill
class BsBadge extends StatelessWidget {
  final String text;
  final Color color;
  const BsBadge({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.o(.15),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.o(.30)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
          color: color,
        ),
      ),
    );
  }
}

/// .alert .alert-success / .alert-danger / .alert-info
enum BsAlertType { success, danger, info }

class BsAlert extends StatelessWidget {
  final BsAlertType type;
  final String message;
  const BsAlert({super.key, required this.type, required this.message});

  @override
  Widget build(BuildContext context) {
    final (Color c, IconData i) = switch (type) {
      BsAlertType.success => (
        TW.emerald500,
        Icons.check_circle_outline_rounded,
      ),
      BsAlertType.danger => (TW.rose500, Icons.error_outline_rounded),
      BsAlertType.info => (TW.sky400, Icons.info_outline_rounded),
    };
    return Container(
      padding: const EdgeInsets.all(TW.s3),
      decoration: BoxDecoration(
        color: c.o(.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: c.o(.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(i, color: c, size: 20),
          const SizedBox(width: TW.s2),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: TW.slate300,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// .form-label + .form-control + .input-group
class BsInput extends StatefulWidget {
  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final bool password;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;

  const BsInput({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    this.password = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
  });

  @override
  State<BsInput> createState() => _BsInputState();
}

class _BsInputState extends State<BsInput> {
  bool _hide = true;

  OutlineInputBorder _b(Color c, [double w = 1]) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(TW.rLg),
    borderSide: BorderSide(color: c, width: w),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: TwText.label),
        const SizedBox(height: TW.s2),
        TextFormField(
          controller: widget.controller,
          obscureText: widget.password && _hide,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          onChanged: widget.onChanged,
          style: const TextStyle(color: TW.slate50, fontSize: 15),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: const TextStyle(color: TW.slate500),
            prefixIcon: Icon(widget.icon, size: 18, color: TW.slate400),
            suffixIcon: widget.password
                ? IconButton(
                    icon: Icon(
                      _hide
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 18,
                      color: TW.slate400,
                    ),
                    onPressed: () => setState(() => _hide = !_hide),
                  )
                : null,
            filled: true,
            fillColor: TW.slate950.o(.6),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 12,
            ),
            enabledBorder: _b(TW.slate700),
            focusedBorder: _b(TW.indigo400, 1.6),
            errorBorder: _b(TW.rose500),
            focusedErrorBorder: _b(TW.rose500, 1.6),
            errorStyle: const TextStyle(color: TW.rose400, fontSize: 12),
          ),
        ),
      ],
    );
  }
}

/// .btn .btn-primary / .btn-outline / .btn-link
enum BsVariant { primary, outline }

class BsButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final BsVariant variant;
  final bool loading;
  final IconData? icon;

  const BsButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = BsVariant.primary,
    this.loading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final primary = variant == BsVariant.primary;
    final enabled = onPressed != null && !loading;
    final fg = primary ? Colors.white : TW.slate300;

    return Opacity(
      opacity: (enabled || loading) ? 1 : 0.5,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            gradient: primary
                ? const LinearGradient(colors: [TW.indigo500, TW.violet500])
                : null,
            color: primary ? null : TW.slate900.o(.4),
            borderRadius: BorderRadius.circular(TW.rLg),
            border: primary ? null : Border.all(color: TW.slate700),
            boxShadow: primary
                ? [
                    BoxShadow(
                      color: TW.indigo500.o(.35),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(TW.rLg),
            onTap: enabled ? onPressed : null,
            child: SizedBox(
              height: 48,
              width: double.infinity,
              child: Center(
                child: loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (icon != null) ...[
                            Icon(icon, size: 20, color: fg),
                            const SizedBox(width: TW.s2),
                          ],
                          Text(
                            label,
                            style: TextStyle(
                              color: fg,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Teks tautan: "Belum punya akun? Daftar"
class LinkText extends StatelessWidget {
  final String prefix;
  final String action;
  final VoidCallback onTap;
  const LinkText({
    super.key,
    required this.prefix,
    required this.action,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 6,
      children: [
        Text(prefix, style: TwText.body),
        GestureDetector(
          onTap: onTap,
          child: Text(
            action,
            style: const TextStyle(
              color: TW.indigo400,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: TW.slate700.o(.7), height: 1)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: TW.s3),
          child: Text('atau lanjutkan dengan', style: TwText.xs),
        ),
        Expanded(child: Divider(color: TW.slate700.o(.7), height: 1)),
      ],
    );
  }
}

class SocialRow extends StatelessWidget {
  const SocialRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: BsButton(
            label: 'Google',
            icon: Icons.g_mobiledata_rounded,
            variant: BsVariant.outline,
            onPressed: () {},
          ),
        ),
        const SizedBox(width: TW.s3),
        Expanded(
          child: BsButton(
            label: 'GitHub',
            icon: Icons.code_rounded,
            variant: BsVariant.outline,
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}

class AuthHeader extends StatelessWidget {
  final String badge;
  final String title;
  final String subtitle;
  const AuthHeader({
    super.key,
    required this.badge,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BsBadge(text: badge, color: TW.indigo400),
        const SizedBox(height: TW.s3),
        Text(title, style: TwText.h2),
        const SizedBox(height: TW.s2),
        Text(subtitle, style: TwText.body),
      ],
    );
  }
}

/// Indikator kekuatan kata sandi (4 segmen).
class PasswordStrength extends StatelessWidget {
  final String password;
  const PasswordStrength({super.key, required this.password});

  int get _score {
    var s = 0;
    if (password.length >= 8) {
      s++;
    }
    if (RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[a-z]').hasMatch(password)) {
      s++;
    }
    if (RegExp(r'\d').hasMatch(password)) {
      s++;
    }
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(password)) {
      s++;
    }
    return s;
  }

  @override
  Widget build(BuildContext context) {
    final score = _score;
    const colors = [
      TW.slate700,
      TW.rose500,
      TW.amber400,
      TW.sky400,
      TW.emerald500,
    ];
    const labels = ['Belum diisi', 'Lemah', 'Cukup', 'Kuat', 'Sangat kuat'];
    final c = password.isEmpty ? TW.slate700 : colors[score.clamp(1, 4)];
    final text = password.isEmpty ? labels[0] : labels[score.clamp(1, 4)];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(4, (i) {
            final on = password.isNotEmpty && i < score.clamp(1, 4);
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 4,
                margin: EdgeInsets.only(right: i == 3 ? 0 : 6),
                decoration: BoxDecoration(
                  color: on ? c : TW.slate700,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: TW.s2),
        Text('Kekuatan: $text', style: TwText.xs),
      ],
    );
  }
}

class Validators {
  static String? required(String? v, String name) =>
      (v == null || v.trim().isEmpty) ? '$name wajib diisi' : null;

  static String? email(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email wajib diisi';
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim());
    return ok ? null : 'Format email tidak valid';
  }

  static String? password(String? v) {
    if (v == null || v.isEmpty) return 'Kata sandi wajib diisi';
    if (v.length < 6) return 'Minimal 6 karakter';
    return null;
  }
}

class _UploadDemoButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onPressed;

  const _UploadDemoButton({
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        selected ? Icons.check_circle_outline : Icons.upload_file_outlined,
        size: 18,
      ),
      label: Text(selected ? '$label siap (demo)' : 'Pilih $label (demo)'),
      style: OutlinedButton.styleFrom(
        foregroundColor: selected ? TW.emerald500 : TW.slate300,
        minimumSize: const Size(double.infinity, 44),
        side: BorderSide(color: selected ? TW.emerald500 : TW.slate700),
        alignment: Alignment.centerLeft,
      ),
    );
  }
}

Widget _checkbox(bool value, ValueChanged<bool?> onChanged) => SizedBox(
  width: 24,
  height: 24,
  child: Checkbox(
    value: value,
    onChanged: onChanged,
    activeColor: TW.indigo500,
    side: const BorderSide(color: TW.slate500, width: 1.4),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
  ),
);

// ------------------------------------------------------------
// 5. HALAMAN
// ------------------------------------------------------------

// ---------- LOGIN ----------
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _loading = false;
  bool _remember = true;
  String? _msg;

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _msg = null);
    if (!_form.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() => _loading = false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            LoanDashboardPage(name: _email.text.trim().split('@').first),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Form(
        key: _form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AuthHeader(
              badge: 'SELAMAT DATANG',
              title: 'Masuk ke akun Anda',
              subtitle: 'Masuk untuk melihat ketersediaan barang dan status pinjaman.',
            ),
            const SizedBox(height: TW.s6),
            if (_msg != null) ...[
              BsAlert(type: BsAlertType.success, message: _msg!),
              const SizedBox(height: TW.s4),
            ],
            BsInput(
              label: 'Email',
              hint: 'nama@email.com',
              icon: Icons.mail_outline_rounded,
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              validator: Validators.email,
            ),
            const SizedBox(height: TW.s4),
            BsInput(
              label: 'Kata sandi',
              hint: '••••••••',
              icon: Icons.lock_outline_rounded,
              controller: _pass,
              password: true,
              validator: Validators.password,
            ),
            const SizedBox(height: TW.s3),
            Row(
              children: [
                _checkbox(
                  _remember,
                  (v) => setState(() => _remember = v ?? false),
                ),
                const SizedBox(width: TW.s2),
                const Expanded(child: Text('Ingat saya', style: TwText.body)),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/forgot'),
                  child: const Text(
                    'Lupa kata sandi?',
                    style: TextStyle(
                      color: TW.indigo400,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: TW.s4),
            BsButton(
              label: 'Masuk',
              icon: Icons.login_rounded,
              loading: _loading,
              onPressed: _submit,
            ),
            const SizedBox(height: TW.s5),
            Center(
              child: LinkText(
                prefix: 'Belum punya akun?',
                action: 'Daftar sekarang',
                onTap: () =>
                    Navigator.pushReplacementNamed(context, '/register'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- REGISTER ----------
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _confirm = TextEditingController();
  final _nim = TextEditingController();
  final _prodi = TextEditingController();
  final _angkatan = TextEditingController();
  final _alamat = TextEditingController();
  bool _agree = false;
  bool _loading = false;
  bool _profilePhotoReady = false;
  bool _ktmReady = false;
  String? _msg;
  BsAlertType _msgType = BsAlertType.success;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _pass.dispose();
    _confirm.dispose();
    _nim.dispose();
    _prodi.dispose();
    _angkatan.dispose();
    _alamat.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _msg = null);
    if (!_form.currentState!.validate()) return;
    if (!_agree) {
      setState(() {
        _msgType = BsAlertType.danger;
        _msg = 'Setujui Syarat & Ketentuan terlebih dahulu.';
      });
      return;
    }
    if (!_profilePhotoReady || !_ktmReady) {
      setState(() {
        _msgType = BsAlertType.danger;
        _msg = 'Unggah foto profil dan foto KTM untuk melanjutkan.';
      });
      return;
    }
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => LoanDashboardPage(
          name: _name.text.trim(),
          nim: _nim.text.trim(),
          prodi: _prodi.text.trim(),
          angkatan: _angkatan.text.trim(),
          alamat: _alamat.text.trim(),
          profileComplete: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Form(
        key: _form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AuthHeader(
              badge: 'AKUN BARU',
              title: 'Buat akun Anda',
              subtitle: 'Lengkapi data mahasiswa FTI untuk mulai meminjam.',
            ),
            const SizedBox(height: TW.s6),
            if (_msg != null) ...[
              BsAlert(type: _msgType, message: _msg!),
              const SizedBox(height: TW.s4),
            ],
            BsInput(
              label: 'Nama lengkap',
              hint: 'Nama Anda',
              icon: Icons.person_outline_rounded,
              controller: _name,
              validator: (v) => Validators.required(v, 'Nama'),
            ),
            const SizedBox(height: TW.s4),
            BsInput(
              label: 'Email',
              hint: 'nama@email.com',
              icon: Icons.mail_outline_rounded,
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              validator: Validators.email,
            ),
            const SizedBox(height: TW.s4),
            BsInput(
              label: 'NIM',
              hint: 'Contoh: 20241124',
              icon: Icons.badge_outlined,
              controller: _nim,
              keyboardType: TextInputType.number,
              validator: (v) => Validators.required(v, 'NIM'),
            ),
            const SizedBox(height: TW.s4),
            BsInput(
              label: 'Program studi',
              hint: 'Contoh: Teknik Informatika',
              icon: Icons.school_outlined,
              controller: _prodi,
              validator: (v) => Validators.required(v, 'Program studi'),
            ),
            const SizedBox(height: TW.s4),
            BsInput(
              label: 'Angkatan',
              hint: 'Contoh: 2024',
              icon: Icons.calendar_month_outlined,
              controller: _angkatan,
              keyboardType: TextInputType.number,
              validator: (v) => Validators.required(v, 'Angkatan'),
            ),
            const SizedBox(height: TW.s4),
            BsInput(
              label: 'Alamat',
              hint: 'Alamat domisili',
              icon: Icons.location_on_outlined,
              controller: _alamat,
              validator: (v) => Validators.required(v, 'Alamat'),
            ),
            const SizedBox(height: TW.s4),
            Text('Dokumen verifikasi', style: TwText.label),
            const SizedBox(height: TW.s2),
            _UploadDemoButton(
              label: 'Foto profil',
              selected: _profilePhotoReady,
              onPressed: () =>
                  setState(() => _profilePhotoReady = !_profilePhotoReady),
            ),
            const SizedBox(height: TW.s2),
            _UploadDemoButton(
              label: 'Foto KTM',
              selected: _ktmReady,
              onPressed: () => setState(() => _ktmReady = !_ktmReady),
            ),
            const SizedBox(height: TW.s4),
            BsInput(
              label: 'Kata sandi',
              hint: 'Minimal 6 karakter',
              icon: Icons.lock_outline_rounded,
              controller: _pass,
              password: true,
              validator: Validators.password,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: TW.s3),
            PasswordStrength(password: _pass.text),
            const SizedBox(height: TW.s4),
            BsInput(
              label: 'Konfirmasi kata sandi',
              hint: 'Ulangi kata sandi',
              icon: Icons.lock_reset_rounded,
              controller: _confirm,
              password: true,
              validator: (v) =>
                  v != _pass.text ? 'Kata sandi tidak cocok' : null,
            ),
            const SizedBox(height: TW.s4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _checkbox(_agree, (v) => setState(() => _agree = v ?? false)),
                const SizedBox(width: TW.s2),
                const Expanded(
                  child: Text(
                    'Saya menyetujui Syarat & Ketentuan serta Kebijakan Privasi.',
                    style: TwText.body,
                  ),
                ),
              ],
            ),
            const SizedBox(height: TW.s5),
            BsButton(
              label: 'Daftar',
              icon: Icons.person_add_alt_1_rounded,
              loading: _loading,
              onPressed: _submit,
            ),
            const SizedBox(height: TW.s5),
            Center(
              child: LinkText(
                prefix: 'Sudah punya akun?',
                action: 'Masuk',
                onTap: () => Navigator.pushReplacementNamed(context, '/login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- LUPA PASSWORD ----------
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  bool _loading = false;
  bool _sent = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() {
      _loading = false;
      _sent = true;
    });
  }

  void _toLogin() => Navigator.pushReplacementNamed(context, '/login');

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Form(
        key: _form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: _toLogin,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 32),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  size: 16,
                  color: TW.slate400,
                ),
                label: const Text(
                  'Kembali ke login',
                  style: TextStyle(color: TW.slate400, fontSize: 13),
                ),
              ),
            ),
            const SizedBox(height: TW.s3),
            const AuthHeader(
              badge: 'PEMULIHAN AKUN',
              title: 'Lupa kata sandi?',
              subtitle: 'Masukkan email Anda dan kami akan mengirim tautan untuk mengatur ulang kata sandi.',
            ),
            const SizedBox(height: TW.s6),
            if (_sent) ...[
              BsAlert(
                type: BsAlertType.success,
                message:
                    'Permintaan reset demo untuk ${_email.text.trim()} sudah dicatat. Pengiriman tautan memerlukan layanan backend.',
              ),
              const SizedBox(height: TW.s5),
              BsButton(
                label: 'Kembali ke login',
                variant: BsVariant.outline,
                onPressed: _toLogin,
              ),
            ] else ...[
              BsInput(
                label: 'Email',
                hint: 'nama@email.com',
                icon: Icons.mail_outline_rounded,
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.email,
              ),
              const SizedBox(height: TW.s3),
              const BsAlert(
                type: BsAlertType.info,
                message: 'Pengiriman email reset belum terhubung. Halaman ini menampilkan simulasi alur pemulihan akun.',
              ),
              const SizedBox(height: TW.s5),
              BsButton(
                label: 'Kirim tautan reset',
                icon: Icons.send_rounded,
                loading: _loading,
                onPressed: _submit,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class LoanItem {
  final String name;
  final String category;
  final IconData icon;
  final int total;
  int available;

  LoanItem({
    required this.name,
    required this.category,
    required this.icon,
    required this.total,
    required this.available,
  });
}

class LoanRecord {
  final String itemName;
  final String classCode;
  final DateTime borrowedAt;
  final DateTime dueAt;
  bool returned;

  LoanRecord({
    required this.itemName,
    required this.classCode,
    required this.borrowedAt,
    required this.dueAt,
    this.returned = false,
  });
}

class LoanDashboardPage extends StatefulWidget {
  final String name;
  final String nim;
  final String prodi;
  final String angkatan;
  final String alamat;
  final bool profileComplete;

  const LoanDashboardPage({
    super.key,
    required this.name,
    this.nim = '',
    this.prodi = '',
    this.angkatan = '',
    this.alamat = '',
    this.profileComplete = false,
  });

  @override
  State<LoanDashboardPage> createState() => _LoanDashboardPageState();
}

class _LoanDashboardPageState extends State<LoanDashboardPage> {
  static const _green = Color(0xFF087F5B);
  static const _greenDark = Color(0xFF075E45);
  static const _ink = Color(0xFF172B25);
  static const _muted = Color(0xFF71817B);
  static const _canvas = Color(0xFFF4F8F6);

  late final TextEditingController _name;
  late final TextEditingController _nim;
  late final TextEditingController _prodi;
  late final TextEditingController _angkatan;
  late final TextEditingController _alamat;

  late bool _profileComplete;
  late bool _profilePhotoReady;
  late bool _ktmReady;
  int _selectedTab = 0;

  final List<LoanItem> _items = [
    LoanItem(
      name: 'LCD Proyektor',
      category: 'Perangkat presentasi',
      icon: Icons.videocam_rounded,
      total: 5,
      available: 3,
    ),
    LoanItem(
      name: 'Remote Proyektor',
      category: 'Aksesori presentasi',
      icon: Icons.settings_remote_rounded,
      total: 12,
      available: 8,
    ),
    LoanItem(
      name: 'Kabel HDMI',
      category: 'Kabel & konektor',
      icon: Icons.cable_rounded,
      total: 10,
      available: 6,
    ),
    LoanItem(
      name: 'Pointer Presentasi',
      category: 'Perangkat presentasi',
      icon: Icons.present_to_all_rounded,
      total: 6,
      available: 4,
    ),
  ];
  final List<LoanRecord> _loans = [];

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.name);
    _nim = TextEditingController(text: widget.nim);
    _prodi = TextEditingController(text: widget.prodi);
    _angkatan = TextEditingController(text: widget.angkatan);
    _alamat = TextEditingController(text: widget.alamat);
    _profileComplete = widget.profileComplete;
    _profilePhotoReady = widget.profileComplete;
    _ktmReady = widget.profileComplete;
  }

  @override
  void dispose() {
    _name.dispose();
    _nim.dispose();
    _prodi.dispose();
    _angkatan.dispose();
    _alamat.dispose();
    super.dispose();
  }

  String _time(DateTime value) =>
      '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _borrow(LoanItem item) async {
    if (item.available == 0) {
      _showMessage('Maaf, ${item.name} sedang tidak tersedia.');
      return;
    }
    if (!_profileComplete) {
      _showMessage('Lengkapi profil dan verifikasi KTM sebelum meminjam.');
      setState(() => _selectedTab = 3);
      return;
    }

    final barcode = TextEditingController(
      text:
          'FTI-${_angkatan.text.trim().isEmpty ? '2024' : _angkatan.text.trim()}-1124B',
    );
    var barcodeError = '';
    final validKtm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Verifikasi KTM'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.qr_code_scanner_rounded,
                size: 56,
                color: _green,
              ),
              const SizedBox(height: 12),
              const Text(
                'Masukkan kode barcode KTM untuk memastikan Anda mahasiswa FTI.',
              ),
              const SizedBox(height: 16),
              TextField(
                controller: barcode,
                decoration: InputDecoration(
                  labelText: 'Kode barcode KTM',
                  hintText: 'FTI-2024-1124B',
                  errorText: barcodeError.isEmpty ? null : barcodeError,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Simulasi prototipe: kamera scanner belum dihubungkan.',
                style: TextStyle(fontSize: 12, color: _muted),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () {
                final code = barcode.text.trim().toUpperCase();
                final match = RegExp(r'^FTI-(\d{4})-([A-Z0-9]+)$')
                    .firstMatch(code);
                final expectedYear = _angkatan.text.trim().isEmpty
                    ? '2024'
                    : _angkatan.text.trim();
                if (match == null || match.group(1) != expectedYear) {
                  setDialogState(
                    () => barcodeError =
                        'Kode harus berformat FTI-$expectedYear-1124B sesuai angkatan Anda.',
                  );
                  return;
                }
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Validasi KTM'),
            ),
          ],
        ),
      ),
    );
    final validatedCode = barcode.text.trim().toUpperCase();
    barcode.dispose();
    if (validKtm != true || !mounted) return;

    final borrowedAt = DateTime.now();
    final dueAt = borrowedAt.add(const Duration(hours: 2));
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Konfirmasi peminjaman'),
        content: Text(
          '${item.name} tersedia (${item.available} dari ${item.total}). '
          'Batas pengembalian pukul ${_time(dueAt)}. Pastikan dikembalikan '
          'sebelum jam tersebut atau sesuai arahan TU.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Kembali'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Pinjam barang'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() {
      item.available--;
      _loans.insert(
        0,
        LoanRecord(
          itemName: item.name,
          classCode: validatedCode.split('-').last,
          borrowedAt: borrowedAt,
          dueAt: dueAt,
        ),
      );
      _selectedTab = 2;
    });
    _showMessage('Peminjaman ${item.name} berhasil dicatat.');
  }

  void _returnLoan(LoanRecord loan) {
    final item = _items.firstWhere((item) => item.name == loan.itemName);
    setState(() {
      loan.returned = true;
      item.available++;
    });
    _showMessage('${loan.itemName} berhasil ditandai sudah dikembalikan.');
  }

  void _saveProfile() {
    if (_name.text.trim().isEmpty ||
        _nim.text.trim().isEmpty ||
        _prodi.text.trim().isEmpty ||
        _angkatan.text.trim().isEmpty ||
        _alamat.text.trim().isEmpty) {
      _showMessage('Lengkapi nama, NIM, prodi, angkatan, dan alamat.');
      return;
    }
    if (!_profilePhotoReady || !_ktmReady) {
      _showMessage('Tandai foto profil dan foto KTM sudah tersedia.');
      return;
    }
    setState(() => _profileComplete = true);
    _showMessage('Profil mahasiswa berhasil dilengkapi.');
  }

  Future<void> _changePassword() async {
    final formKey = GlobalKey<FormState>();
    final currentPassword = TextEditingController();
    final newPassword = TextEditingController();
    final confirmPassword = TextEditingController();
    final changed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Ubah kata sandi'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Gunakan minimal 8 karakter dan jangan gunakan kata sandi yang sama dengan akun lain.',
                  style: TextStyle(color: _muted, height: 1.4),
                ),
                const SizedBox(height: 16),
                _securityPasswordField(
                  'Kata sandi saat ini',
                  currentPassword,
                  validator: (value) =>
                      Validators.required(value, 'Kata sandi saat ini'),
                ),
                const SizedBox(height: 12),
                _securityPasswordField(
                  'Kata sandi baru',
                  newPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kata sandi baru wajib diisi';
                    }
                    if (value.length < 8) return 'Minimal 8 karakter';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                _securityPasswordField(
                  'Konfirmasi kata sandi baru',
                  confirmPassword,
                  validator: (value) => value != newPassword.text
                      ? 'Konfirmasi kata sandi tidak cocok'
                      : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(dialogContext, true);
              }
            },
            child: const Text('Simpan sandi'),
          ),
        ],
      ),
    );
    currentPassword.dispose();
    newPassword.dispose();
    confirmPassword.dispose();
    if (changed == true && mounted) {
      _showMessage(
        'Perubahan tersimpan pada sesi demo. Hubungkan autentikasi backend untuk mengubah sandi akun.',
      );
    }
  }

  Widget _securityPasswordField(
    String label,
    TextEditingController controller, {
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outline_rounded),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  Future<void> _sendPasswordReset() async {
    final email = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final sent = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reset lewat email'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Masukkan email akun. Tautan reset akan dikirim ke alamat tersebut.',
                style: TextStyle(color: _muted, height: 1.4),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.email,
                decoration: InputDecoration(
                  labelText: 'Email akun',
                  prefixIcon: const Icon(Icons.alternate_email_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(dialogContext, true);
              }
            },
            child: const Text('Kirim tautan'),
          ),
        ],
      ),
    );
    final destination = email.text.trim();
    email.dispose();
    if (sent == true && mounted) {
      _showMessage(
        'Simulasi: tautan reset akan dikirim ke $destination setelah backend dihubungkan.',
      );
    }
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
        title: const Text('Keluar dari akun?'),
        content: const Text(
          'Anda akan kembali ke halaman masuk. Pastikan tidak ada perubahan profil yang belum disimpan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Ya, keluar'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  Future<void> _showNotifications() async {
    final activeLoans = _loans.where((loan) => !loan.returned).toList();
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pengingat pengembalian'),
        content: activeLoans.isEmpty
            ? const Text('Belum ada barang yang perlu dikembalikan.')
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: activeLoans
                    .map(
                      (loan) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          '${loan.itemName} · batas pukul ${_time(loan.dueAt)}',
                        ),
                      ),
                    )
                    .toList(),
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const titles = ['Beranda', 'Daftar Barang', 'Peminjaman', 'Profil'];
    return Theme(
      data: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: _green),
        scaffoldBackgroundColor: _canvas,
        navigationBarTheme: NavigationBarThemeData(
          height: 68,
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFFDDF5EB),
          labelTextStyle: WidgetStateProperty.resolveWith(
            (states) => TextStyle(
              color: states.contains(WidgetState.selected) ? _green : _muted,
              fontSize: 11,
              fontWeight: states.contains(WidgetState.selected)
                  ? FontWeight.w700
                  : FontWeight.w500,
            ),
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: _canvas,
          surfaceTintColor: Colors.transparent,
          title: Text(
            titles[_selectedTab],
            style: const TextStyle(color: _ink, fontWeight: FontWeight.w800),
          ),
          actions: [
            IconButton(
              tooltip: 'Pengingat',
              onPressed: _showNotifications,
              icon: const Icon(Icons.notifications_none_rounded, color: _ink),
            ),
            IconButton(
              tooltip: 'Keluar',
              onPressed: _logout,
              icon: const Icon(Icons.logout_rounded, color: _ink),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: IndexedStack(
          index: _selectedTab,
          children: [
            _homePage(),
            _inventoryPage(),
            _loansPage(),
            _profilePage(),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          elevation: 8,
          surfaceTintColor: Colors.white,
          selectedIndex: _selectedTab,
          onDestinationSelected: (index) =>
              setState(() => _selectedTab = index),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Beranda',
            ),
            NavigationDestination(
              icon: Icon(Icons.inventory_2_outlined),
              selectedIcon: Icon(Icons.inventory_2_rounded),
              label: 'Barang',
            ),
            NavigationDestination(
              icon: Icon(Icons.assignment_outlined),
              selectedIcon: Icon(Icons.assignment_rounded),
              label: 'Pinjaman',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }

  Widget _homePage() {
    final activeCount = _loans.where((loan) => !loan.returned).length;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Halo,', style: TextStyle(color: _muted)),
                  const SizedBox(height: 3),
                  Text(
                    _name.text.trim().isEmpty
                        ? 'Mahasiswa FTI'
                        : _name.text.trim(),
                    style: const TextStyle(
                      color: _ink,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            CircleAvatar(
              radius: 24,
              backgroundColor: const Color(0xFFD9F1E7),
              child: Text(
                _name.text.trim().isEmpty
                    ? 'M'
                    : _name.text.trim()[0].toUpperCase(),
                style: const TextStyle(
                  color: _greenDark,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [_green, _greenDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white.withAlpha(35)),
            boxShadow: [
              BoxShadow(
                color: _greenDark.withAlpha(28),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'PEMINJAMAN BARANG TU FTI',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Butuh barang untuk kuliah?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Cek kuota, verifikasi KTM, lalu ajukan peminjaman.',
                style: TextStyle(color: Colors.white70, height: 1.4),
              ),
              const SizedBox(height: 16),
              FilledButton.tonalIcon(
                onPressed: () => setState(() => _selectedTab = 1),
                icon: const Icon(Icons.arrow_forward_rounded),
                label: const Text('Lihat barang'),
                style: FilledButton.styleFrom(
                  foregroundColor: _greenDark,
                  backgroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: _summaryCard(
                icon: Icons.inventory_2_outlined,
                label: 'Jenis barang',
                value: '${_items.length}',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _summaryCard(
                icon: Icons.assignment_outlined,
                label: 'Sedang dipinjam',
                value: '$activeCount',
              ),
            ),
          ],
        ),
        if (!_profileComplete) ...[
          const SizedBox(height: 16),
          Material(
            color: const Color(0xFFFFF5DE),
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => setState(() => _selectedTab = 3),
              child: const Padding(
                padding: EdgeInsets.all(14),
                child: Row(
                  children: [
                    Icon(Icons.info_outline_rounded, color: Color(0xFFB7791F)),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Lengkapi profil dan dokumen KTM sebelum mengajukan pinjaman.',
                        style: TextStyle(color: Color(0xFF73531B)),
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, color: Color(0xFFB7791F)),
                  ],
                ),
              ),
            ),
          ),
        ],
        const SizedBox(height: 24),
        _sectionHeading('Barang populer', 'Lihat semua', () {
          setState(() => _selectedTab = 1);
        }),
        const SizedBox(height: 10),
        ..._items.take(3).map(_itemCard),
        if (_loans.any((loan) => !loan.returned)) ...[
          const SizedBox(height: 14),
          _reminderBanner(),
        ],
      ],
    );
  }

  Widget _summaryCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6EEEA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: _green),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: _ink,
              fontSize: 23,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(label, style: const TextStyle(color: _muted, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _sectionHeading(String title, String action, VoidCallback onTap) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: _ink,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        TextButton(onPressed: onTap, child: Text(action)),
      ],
    );
  }

  Widget _itemCard(LoanItem item) {
    final available = item.available > 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6EEEA)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFE6F5EF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(item.icon, color: _green),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    color: _ink,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.category,
                  style: const TextStyle(color: _muted, fontSize: 12),
                ),
                const SizedBox(height: 5),
                Text(
                  '${item.available} dari ${item.total} tersedia',
                  style: TextStyle(
                    color: available ? _green : Colors.redAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: available ? () => _borrow(item) : null,
            child: const Text('Pinjam'),
          ),
        ],
      ),
    );
  }

  Widget _inventoryPage() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      children: [
        const Text(
          'Barang tersedia di kantor TU Fakultas Teknologi Informasi.',
          style: TextStyle(color: _muted, height: 1.5),
        ),
        const SizedBox(height: 16),
        ..._items.map(_itemCard),
      ],
    );
  }

  Widget _loansPage() {
    final activeLoans = _loans.where((loan) => !loan.returned).toList();
    final history = _loans.where((loan) => loan.returned).toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      children: [
        const Text(
          'Pantau batas waktu dan status pengembalian barang.',
          style: TextStyle(color: _muted, height: 1.5),
        ),
        const SizedBox(height: 18),
        if (activeLoans.isEmpty && history.isEmpty)
          _emptyState(
            Icons.assignment_outlined,
            'Belum ada peminjaman',
            'Barang yang berhasil dipinjam akan muncul di halaman ini.',
          ),
        if (activeLoans.isNotEmpty) ...[
          _sectionHeading('Sedang dipinjam', '', () {}),
          ...activeLoans.map((loan) => _loanCard(loan)),
        ],
        if (history.isNotEmpty) ...[
          const SizedBox(height: 14),
          _sectionHeading('Riwayat pengembalian', '', () {}),
          ...history.map((loan) => _loanCard(loan)),
        ],
      ],
    );
  }

  Widget _loanCard(LoanRecord loan) {
    final overdue = !loan.returned && loan.dueAt.isBefore(DateTime.now());
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6EEEA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.inventory_2_outlined, color: _green),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  loan.itemName,
                  style: const TextStyle(
                    color: _ink,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              _statusBadge(
                loan.returned
                    ? 'Dikembalikan'
                    : overdue
                    ? 'Terlambat'
                    : 'Dipinjam',
                loan.returned
                    ? _green
                    : overdue
                    ? Colors.redAccent
                    : const Color(0xFFB7791F),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Kode kelas: ${loan.classCode}',
            style: const TextStyle(color: _muted, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            'Batas pengembalian: ${_time(loan.dueAt)}',
            style: TextStyle(
              color: overdue ? Colors.redAccent : _muted,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (!loan.returned) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _returnLoan(loan),
                icon: const Icon(Icons.assignment_turned_in_outlined),
                label: const Text('Tandai sudah dikembalikan'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _statusBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _reminderBanner() {
    final loan = _loans.firstWhere((loan) => !loan.returned);
    final overdue = loan.dueAt.isBefore(DateTime.now());
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: overdue ? const Color(0xFFFFE8E8) : const Color(0xFFFFF5DE),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            Icons.alarm_rounded,
            color: overdue ? Colors.redAccent : const Color(0xFFB7791F),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              overdue
                  ? '${loan.itemName} melewati batas pengembalian.'
                  : 'Ingat kembalikan ${loan.itemName} sebelum pukul ${_time(loan.dueAt)}.',
              style: TextStyle(
                color: overdue ? Colors.redAccent : const Color(0xFF73531B),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _profilePage() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [_green, _greenDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: _greenDark.withAlpha(25),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withAlpha(140)),
                ),
                child: CircleAvatar(
                  radius: 31,
                  backgroundColor: Colors.white,
                  child: Text(
                    _name.text.trim().isEmpty
                        ? 'M'
                        : _name.text.trim()[0].toUpperCase(),
                    style: const TextStyle(
                      color: _greenDark,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _name.text.trim().isEmpty
                          ? 'Lengkapi profil'
                          : _name.text.trim(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _nim.text.trim().isEmpty
                          ? 'Mahasiswa Fakultas Teknologi Informasi'
                          : 'NIM ${_nim.text.trim()}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 8),
                    _statusBadge(
                      _profileComplete
                          ? 'Profil terverifikasi'
                          : 'Profil belum lengkap',
                      _profileComplete
                          ? const Color(0xFF80F0BD)
                          : const Color(0xFFFFD166),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _profileSectionHeader('Informasi mahasiswa'),
        _profileInput('Nama lengkap', _name, Icons.person_outline_rounded),
        _profileInput('NIM', _nim, Icons.badge_outlined),
        _profileInput('Program studi', _prodi, Icons.school_outlined),
        _profileInput('Angkatan', _angkatan, Icons.calendar_month_outlined),
        _profileInput('Alamat', _alamat, Icons.location_on_outlined),
        _profileSectionHeader('Verifikasi dokumen'),
        const SizedBox(height: 8),
        _UploadDemoButton(
          label: 'Foto profil',
          selected: _profilePhotoReady,
          onPressed: () =>
              setState(() => _profilePhotoReady = !_profilePhotoReady),
        ),
        const SizedBox(height: 8),
        _UploadDemoButton(
          label: 'Foto KTM',
          selected: _ktmReady,
          onPressed: () => setState(() => _ktmReady = !_ktmReady),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 48,
          child: FilledButton.icon(
            onPressed: _saveProfile,
            icon: const Icon(Icons.save_outlined),
            label: const Text('Simpan profil'),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Pengunggahan foto masih berupa simulasi prototipe.',
          textAlign: TextAlign.center,
          style: TextStyle(color: _muted, fontSize: 12),
        ),
        const SizedBox(height: 24),
        _profileSectionHeader('Keamanan & akun'),
        _accountAction(
          icon: Icons.password_rounded,
          title: 'Ubah kata sandi',
          subtitle: 'Perbarui sandi akun Anda',
          onTap: _changePassword,
        ),
        const SizedBox(height: 9),
        _accountAction(
          icon: Icons.mark_email_read_outlined,
          title: 'Reset kata sandi',
          subtitle: 'Kirim instruksi reset ke email',
          onTap: _sendPasswordReset,
        ),
        const SizedBox(height: 9),
        _accountAction(
          icon: Icons.logout_rounded,
          title: 'Keluar dari akun',
          subtitle: 'Akhiri sesi pada perangkat ini',
          color: Colors.redAccent,
          onTap: _logout,
        ),
        const SizedBox(height: 16),
        const Text(
          'Pengaturan keamanan demo belum terhubung ke layanan akun.',
          textAlign: TextAlign.center,
          style: TextStyle(color: _muted, fontSize: 12),
        ),
      ],
    );
  }

  Widget _profileSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Text(
        title,
        style: const TextStyle(
          color: _ink,
          fontSize: 15,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _accountAction({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color color = _green,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE6EEEA)),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withAlpha(20),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: _ink,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(color: _muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: color),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileInput(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: _ink),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  Widget _emptyState(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 56),
      child: Column(
        children: [
          Icon(icon, size: 48, color: const Color(0xFF9AA9A2)),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(
              color: _ink,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: _muted, height: 1.4),
          ),
        ],
      ),
    );
  }
}

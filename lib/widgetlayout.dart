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
      letterSpacing: -1);
  static const h2 = TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.w800,
      color: TW.slate50,
      letterSpacing: -0.5);
  static const lead =
  TextStyle(fontSize: 16, color: TW.slate400, height: 1.6);
  static const body =
  TextStyle(fontSize: 14, color: TW.slate400, height: 1.5);
  static const label = TextStyle(
      fontSize: 13, fontWeight: FontWeight.w600, color: TW.slate300);
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
      title: 'Lumina Auth',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: TW.slate950,
        colorScheme: const ColorScheme.dark(primary: TW.indigo500),
        textSelectionTheme: const TextSelectionThemeData(
            cursorColor: TW.indigo400),
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
                begin: const Offset(0, 0.03), end: Offset.zero)
                .animate(curved),
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
              bottom: -180, right: -120, child: _glow(TW.violet500, 500)),
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
                end: Alignment.bottomRight),
            boxShadow: [
              BoxShadow(
                  color: TW.indigo500.o(.4),
                  blurRadius: 16,
                  offset: const Offset(0, 6)),
            ],
          ),
          child: const Icon(Icons.bolt_rounded, color: Colors.white),
        ),
        const SizedBox(width: TW.s3),
        const Text('Lumina',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: TW.slate50,
                letterSpacing: -0.3)),
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
            Text.rich(TextSpan(style: TwText.display, children: [
              const TextSpan(text: 'Masuk lebih cepat, '),
              TextSpan(
                  text: 'bangun lebih jauh.',
                  style: const TextStyle(color: TW.indigo400)),
            ])),
            const SizedBox(height: TW.s4),
            const Text(
                'Satu akun untuk semua kebutuhan Anda. Aman, ringan, dan siap dipakai di semua perangkat.',
                style: TwText.lead),
            const SizedBox(height: TW.s8),
            const _Feature(Icons.shield_outlined, 'Keamanan berlapis'),
            const _Feature(Icons.devices_rounded, 'Sinkron di semua perangkat'),
            const _Feature(Icons.bolt_outlined, 'Login hanya dalam hitungan detik'),
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
              child: Text(text,
                  style: const TextStyle(
                      color: TW.slate300, fontWeight: FontWeight.w500))),
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
          child: LayoutBuilder(builder: (context, c) {
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
                      const Text('© 2026 Lumina. Semua hak dilindungi.',
                          style: TwText.xs),
                    ],
                  ),
                ),
              ),
            );
            if (!wide) return form;
            return Row(
              children: [
                Expanded(flex: c.maxWidth >= BS.lg ? 6 : 5, child: const BrandPanel()),
                Expanded(flex: 5, child: form),
              ],
            );
          }),
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
      child: Text(text,
          style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: color)),
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
      BsAlertType.success => (TW.emerald500, Icons.check_circle_outline_rounded),
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
              child: Text(message,
                  style: const TextStyle(
                      color: TW.slate300, fontSize: 13, height: 1.4))),
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
            contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
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
                  offset: const Offset(0, 8)),
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
                        strokeWidth: 2, color: Colors.white))
                    : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 20, color: fg),
                      const SizedBox(width: TW.s2),
                    ],
                    Text(label,
                        style: TextStyle(
                            color: fg,
                            fontWeight: FontWeight.w600,
                            fontSize: 15)),
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
  const LinkText(
      {super.key,
        required this.prefix,
        required this.action,
        required this.onTap});

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
          child: Text(action,
              style: const TextStyle(
                  color: TW.indigo400,
                  fontWeight: FontWeight.w700,
                  fontSize: 14)),
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
              onPressed: () {}),
        ),
        const SizedBox(width: TW.s3),
        Expanded(
          child: BsButton(
              label: 'GitHub',
              icon: Icons.code_rounded,
              variant: BsVariant.outline,
              onPressed: () {}),
        ),
      ],
    );
  }
}

class AuthHeader extends StatelessWidget {
  final String badge;
  final String title;
  final String subtitle;
  const AuthHeader(
      {super.key,
        required this.badge,
        required this.title,
        required this.subtitle});

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
    const colors = [TW.slate700, TW.rose500, TW.amber400, TW.sky400, TW.emerald500];
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
    // TODO: ganti dengan API / Firebase Auth
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() {
      _loading = false;
      _msg = 'Login berhasil (demo). Hubungkan ke API Anda di fungsi _submit.';
    });
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
              subtitle: 'Gunakan email dan kata sandi untuk melanjutkan.',
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
                _checkbox(_remember, (v) => setState(() => _remember = v ?? false)),
                const SizedBox(width: TW.s2),
                const Expanded(child: Text('Ingat saya', style: TwText.body)),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/forgot'),
                  child: const Text('Lupa kata sandi?',
                      style: TextStyle(
                          color: TW.indigo400,
                          fontSize: 13,
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: TW.s4),
            BsButton(
                label: 'Masuk',
                icon: Icons.login_rounded,
                loading: _loading,
                onPressed: _submit),
            const SizedBox(height: TW.s6),
            const OrDivider(),
            const SizedBox(height: TW.s4),
            const SocialRow(),
            const SizedBox(height: TW.s6),
            Center(
              child: LinkText(
                prefix: 'Belum punya akun?',
                action: 'Daftar sekarang',
                onTap: () => Navigator.pushReplacementNamed(context, '/register'),
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
  bool _agree = false;
  bool _loading = false;
  String? _msg;
  BsAlertType _msgType = BsAlertType.success;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _pass.dispose();
    _confirm.dispose();
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
    setState(() => _loading = true);
    // TODO: ganti dengan API / Firebase Auth
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() {
      _loading = false;
      _msgType = BsAlertType.success;
      _msg = 'Registrasi berhasil (demo). Silakan masuk.';
    });
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
              subtitle: 'Gratis dan hanya butuh satu menit.',
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
              validator: (v) => v != _pass.text ? 'Kata sandi tidak cocok' : null,
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
                      style: TwText.body),
                ),
              ],
            ),
            const SizedBox(height: TW.s5),
            BsButton(
                label: 'Daftar',
                icon: Icons.person_add_alt_1_rounded,
                loading: _loading,
                onPressed: _submit),
            const SizedBox(height: TW.s6),
            const OrDivider(),
            const SizedBox(height: TW.s4),
            const SocialRow(),
            const SizedBox(height: TW.s6),
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
    // TODO: ganti dengan API kirim tautan reset
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
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                icon: const Icon(Icons.arrow_back_rounded,
                    size: 16, color: TW.slate400),
                label: const Text('Kembali ke login',
                    style: TextStyle(color: TW.slate400, fontSize: 13)),
              ),
            ),
            const SizedBox(height: TW.s3),
            const AuthHeader(
              badge: 'PEMULIHAN AKUN',
              title: 'Lupa kata sandi?',
              subtitle:
              'Masukkan email Anda dan kami akan mengirim tautan untuk mengatur ulang kata sandi.',
            ),
            const SizedBox(height: TW.s6),
            if (_sent) ...[
              BsAlert(
                type: BsAlertType.success,
                message:
                'Tautan reset telah dikirim ke ${_email.text.trim()}. Periksa kotak masuk atau folder spam.',
              ),
              const SizedBox(height: TW.s5),
              BsButton(
                  label: 'Kembali ke login',
                  variant: BsVariant.outline,
                  onPressed: _toLogin),
            ] else ...[
              BsInput(
                label: 'Email',
                hint: 'nama@email.com',
                icon: Icons.mail_outline_rounded,
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.email,
              ),
              const SizedBox(height: TW.s5),
              BsButton(
                  label: 'Kirim tautan reset',
                  icon: Icons.send_rounded,
                  loading: _loading,
                  onPressed: _submit),
            ],
          ],
        ),
      ),
    );
  }
}
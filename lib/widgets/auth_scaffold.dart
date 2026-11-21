import 'package:flutter/material.dart';

class AuthScaffold extends StatelessWidget {
  final String title;
  final String? error;
  final List<Widget> children;

  const AuthScaffold({
    super.key,
    required this.title,
    this.error,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -100,
            right: -75,
            child: _Glow(color: scheme.primary.withValues(alpha: 0.08)),
          ),
          Positioned(
            bottom: -130,
            left: -90,
            child: _Glow(color: scheme.tertiary.withValues(alpha: 0.08)),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(22),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(28, 32, 28, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [scheme.primary, scheme.tertiary],
                                ),
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: scheme.primary.withValues(
                                      alpha: 0.2,
                                    ),
                                    blurRadius: 22,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.auto_stories_rounded,
                                size: 34,
                                color: scheme.onPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            'RUANG BACA',
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(
                                  color: scheme.primary,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 2.2,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            title,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.6,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Kelola koleksi perpustakaan dengan mudah dan nyaman.',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: scheme.onSurfaceVariant),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 28),
                          if (error != null) ...[
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: scheme.errorContainer,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.error_outline_rounded,
                                    color: scheme.onErrorContainer,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      error!,
                                      style: TextStyle(
                                        color: scheme.onErrorContainer,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 18),
                          ],
                          ...children,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  final Color color;

  const _Glow({required this.color});

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: Container(
      width: 260,
      height: 260,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    ),
  );
}

class LoadingButton extends StatelessWidget {
  final bool loading;
  final String label;
  final VoidCallback onPressed;

  const LoadingButton({
    super.key,
    required this.loading,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => FilledButton.icon(
    onPressed: loading ? null : onPressed,
    icon: loading
        ? SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          )
        : const Icon(Icons.arrow_forward_rounded),
    label: Text(label),
  );
}

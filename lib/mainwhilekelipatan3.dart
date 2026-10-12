import 'package:flutter/material.dart';

// Latihan Bab 5 (Control Flow) - While
// Mencetak kelipatan 3 dari 3 hingga 15 menggunakan while loop.

void main() => runApp(const AplikasiKelipatanTiga());

/// Inti latihan: while loop untuk mengumpulkan kelipatan 3 dari 3 sampai 15.
List<int> kelipatanTiga() {
  final hasil = <int>[];
  var angka = 3;

  while (angka <= 15) {
    hasil.add(angka);
    angka += 3; // kondisi berubah agar loop berhenti (tidak infinite loop)
  }

  return hasil;
}

class Palet {
  static const latar = Color(0xFFEEF1FB);
  static const tinta = Color(0xFF141B3D);
  static const kobalt = Color(0xFF2F4BDB);
  static const lilac = Color(0xFFDDE3FA);
  static const koral = Color(0xFFFF6B4A);
}

class AplikasiKelipatanTiga extends StatelessWidget {
  const AplikasiKelipatanTiga({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kelipatan 3',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Palet.kobalt),
        scaffoldBackgroundColor: Palet.latar,
      ),
      home: const HalamanUtama(),
    );
  }
}

class HalamanUtama extends StatefulWidget {
  const HalamanUtama({super.key});

  @override
  State<HalamanUtama> createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  final List<int> _hasil = kelipatanTiga();
  int _putaran = 0; // dinaikkan setiap kali animasi diulang

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Kelipatan 3,\ndari 3 sampai 15',
                    style: TextStyle(
                      fontSize: 34,
                      height: 1.1,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1,
                      color: Palet.tinta,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Dihasilkan oleh while loop yang berhenti saat angka lebih dari 15.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Palet.tinta.withOpacity(0.65),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const _KartuKode(),
                  const SizedBox(height: 20),
                  TweenAnimationBuilder<double>(
                    key: ValueKey(_putaran),
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 1200),
                    builder: (context, t, _) {
                      return Column(
                        children: [
                          for (var i = 0; i < _hasil.length; i++)
                            _BarisHasil(
                              iterasi: i + 1,
                              angka: _hasil[i],
                              terakhir: i == _hasil.length - 1,
                              progres: ((t - i * 0.15) / 0.3).clamp(0.0, 1.0),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => setState(() => _putaran++),
                      icon: const Icon(Icons.replay_rounded),
                      label: const Text('Ulangi'),
                      style: FilledButton.styleFrom(
                        backgroundColor: Palet.kobalt,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Potongan kode while yang dipakai, ditampilkan sebagai referensi.
class _KartuKode extends StatelessWidget {
  const _KartuKode();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Palet.tinta,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Text(
        'var angka = 3;\n'
            'while (angka <= 15) {\n'
            '  print(angka);\n'
            '  angka += 3;\n'
            '}',
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 15,
          height: 1.6,
          color: Palet.lilac,
        ),
      ),
    );
  }
}

class _BarisHasil extends StatelessWidget {
  const _BarisHasil({
    required this.iterasi,
    required this.angka,
    required this.terakhir,
    required this.progres,
  });

  final int iterasi;
  final int angka;
  final bool terakhir;
  final double progres;

  @override
  Widget build(BuildContext context) {
    final warnaDasar = terakhir ? Palet.koral : Palet.kobalt;

    return Opacity(
      opacity: progres,
      child: Transform.translate(
        offset: Offset(0, 12 * (1 - progres)),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: terakhir ? Palet.koral : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: warnaDasar.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$iterasi',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: warnaDasar,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  '$angka',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1,
                    color: Palet.tinta,
                  ),
                ),
              ),
              Text(
                terakhir ? '3 × $iterasi, batas akhir' : '3 × $iterasi',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: terakhir
                      ? Palet.koral
                      : Palet.tinta.withOpacity(0.55),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
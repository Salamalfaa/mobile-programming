import 'package:flutter/material.dart';

// Latihan Bab 5 (Control Flow) - For
// Menampilkan angka 1 hingga 50 dalam bentuk baris pada layar.

void main() => runApp(const AplikasiAngka());

class Palet {
  static const latar = Color(0xFFF6F4F8);
  static const tinta = Color(0xFF1B1423);
  static const magenta = Color(0xFFB5179E);
  static const magentaMuda = Color(0xFFF3D9EF);
}

/// Inti latihan: for loop untuk membuat satu baris per angka, 1 sampai 50.
List<Widget> buatBaris() {
  final baris = <Widget>[];

  for (int angka = 1; angka <= 50; angka++) {
    baris.add(BarisAngka(angka: angka));
  }

  return baris;
}

class AplikasiAngka extends StatelessWidget {
  const AplikasiAngka({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Angka 1 sampai 50',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Palet.magenta),
        scaffoldBackgroundColor: Palet.latar,
      ),
      home: const HalamanUtama(),
    );
  }
}

class HalamanUtama extends StatelessWidget {
  const HalamanUtama({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Angka 1 sampai 50',
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
                        'Setiap baris dibuat oleh for loop. Panjang garis mengikuti besar angkanya.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Palet.tinta.withOpacity(0.65),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(24, 4, 24, 32),
                    children: buatBaris(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BarisAngka extends StatelessWidget {
  const BarisAngka({super.key, required this.angka});

  final int angka;

  @override
  Widget build(BuildContext context) {
    // Kelipatan 10 diberi penekanan sebagai penanda posisi.
    final kelipatanSepuluh = angka % 10 == 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: kelipatanSepuluh ? Palet.magenta : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 44,
            child: Text(
              '$angka',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: kelipatanSepuluh ? Palet.magenta : Palet.tinta,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: angka / 50,
                minHeight: 10,
                backgroundColor: Palet.magentaMuda,
                color: Palet.magenta,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
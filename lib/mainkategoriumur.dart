import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Latihan Bab 5 (Control Flow) - If and Else
// Menampilkan kategori umur berdasarkan nilai variabel usia:
//   usia < 12          -> "Anak-anak"
//   usia 12 - 17       -> "Remaja"
//   usia 18 - 64       -> "Dewasa"
//   usia >= 65         -> "Lansia"

void main() => runApp(const AplikasiKategoriUmur());

class Kategori {
  const Kategori(this.nama, this.rentang, this.warna, this.warnaTeks, this.ikon);

  final String nama;
  final String rentang;
  final Color warna;
  final Color warnaTeks;
  final IconData ikon;
}

const kAnak = Kategori(
  'Anak-anak', 'Di bawah 12 tahun',
  Color(0xFFF2A541), Color(0xFF3A2406), Icons.toys_rounded,
);
const kRemaja = Kategori(
  'Remaja', '12 sampai 17 tahun',
  Color(0xFFE4572E), Colors.white, Icons.skateboarding_rounded,
);
const kDewasa = Kategori(
  'Dewasa', '18 sampai 64 tahun',
  Color(0xFF0E7C7B), Colors.white, Icons.work_rounded,
);
const kLansia = Kategori(
  'Lansia', '65 tahun ke atas',
  Color(0xFF5B4B8A), Colors.white, Icons.self_improvement_rounded,
);

/// Inti latihan: pernyataan if-else untuk menentukan kategori umur.
Kategori tentukanKategori(int usia) {
  if (usia < 12) {
    return kAnak;
  } else if (usia >= 12 && usia <= 17) {
    return kRemaja;
  } else if (usia >= 18 && usia <= 64) {
    return kDewasa;
  } else {
    return kLansia;
  }
}

class AplikasiKategoriUmur extends StatelessWidget {
  const AplikasiKategoriUmur({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kategori Umur',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0E7C7B)),
        scaffoldBackgroundColor: const Color(0xFFF4F3F8),
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
  static const _tinta = Color(0xFF1C1B2E);

  final _controller = TextEditingController(text: '25');
  int? _usia = 25;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _ubahDariTeks(String teks) {
    setState(() => _usia = int.tryParse(teks));
  }

  void _ubahDariSlider(double nilai) {
    final usia = nilai.round();
    _controller.value = TextEditingValue(
      text: '$usia',
      selection: TextSelection.collapsed(offset: '$usia'.length),
    );
    setState(() => _usia = usia);
  }

  @override
  Widget build(BuildContext context) {
    final usia = _usia;
    final kategori = usia == null ? null : tentukanKategori(usia);

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
                    'Masuk kategori umur yang mana?',
                    style: TextStyle(
                      fontSize: 34,
                      height: 1.1,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1,
                      color: _tinta,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Isi usia atau geser penggeser, kategorinya langsung berubah.',
                    style: TextStyle(
                      fontSize: 16,
                      color: _tinta.withOpacity(0.65),
                    ),
                  ),
                  const SizedBox(height: 28),
                  _KartuHasil(kategori: kategori, usia: usia),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: _tinta.withOpacity(0.06),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: _controller,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(3),
                          ],
                          onChanged: _ubahDariTeks,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: _tinta,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Usia (tahun)',
                            errorText:
                            usia == null ? 'Masukkan usia dalam angka.' : null,
                            filled: true,
                            fillColor: const Color(0xFFF4F3F8),
                            prefixIcon: const Icon(Icons.cake_rounded),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide(
                                color: kategori?.warna ?? _tinta,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: kategori?.warna ?? _tinta,
                            thumbColor: kategori?.warna ?? _tinta,
                            inactiveTrackColor: const Color(0xFFE6E4F0),
                          ),
                          child: Slider(
                            min: 0,
                            max: 100,
                            value: (usia ?? 0).clamp(0, 100).toDouble(),
                            onChanged: _ubahDariSlider,
                          ),
                        ),
                      ],
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

class _KartuHasil extends StatelessWidget {
  const _KartuHasil({required this.kategori, required this.usia});

  final Kategori? kategori;
  final int? usia;

  @override
  Widget build(BuildContext context) {
    final k = kategori;
    final warna = k?.warna ?? const Color(0xFFDCDAE8);
    final warnaTeks = k?.warnaTeks ?? const Color(0xFF1C1B2E);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      decoration: BoxDecoration(
        color: warna,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(k?.ikon ?? Icons.help_outline_rounded,
                  color: warnaTeks, size: 28),
              const SizedBox(width: 10),
              Text(
                usia == null ? 'Belum ada usia' : 'Usia $usia tahun',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: warnaTeks.withOpacity(0.85),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Text(
              k?.nama ?? '-',
              key: ValueKey(k?.nama),
              style: TextStyle(
                fontSize: 52,
                height: 1,
                fontWeight: FontWeight.w800,
                letterSpacing: -1.5,
                color: warnaTeks,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            k?.rentang ?? 'Isi usia untuk melihat kategorinya.',
            style: TextStyle(
              fontSize: 15,
              color: warnaTeks.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 24),
          _JalurUsia(usia: usia, warnaTeks: warnaTeks),
        ],
      ),
    );
  }
}

/// Garis usia 0-100 yang terbagi empat kategori, dengan penanda posisi usia.
class _JalurUsia extends StatelessWidget {
  const _JalurUsia({required this.usia, required this.warnaTeks});

  final int? usia;
  final Color warnaTeks;

  @override
  Widget build(BuildContext context) {
    const segmen = [
      (12, kAnak),
      (6, kRemaja),
      (47, kDewasa),
      (35, kLansia),
    ];

    return LayoutBuilder(
      builder: (context, box) {
        final lebar = box.maxWidth;
        final posisi = ((usia ?? 0).clamp(0, 100) / 100) * lebar;

        return SizedBox(
          height: 34,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: 14,
                child: Row(
                  children: [
                    for (final s in segmen)
                      Expanded(
                        flex: s.$1,
                        child: Container(
                          height: 8,
                          margin: const EdgeInsets.only(right: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: s.$2.warna,
                              width: 0,
                            ),
                          ),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: s.$2.warna,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.white, width: 1.5),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (usia != null)
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                  left: (posisi - 9).clamp(0.0, lebar - 18),
                  top: 6,
                  child: Container(
                    width: 18,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(9),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
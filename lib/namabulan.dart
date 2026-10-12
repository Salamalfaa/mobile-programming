import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Latihan Bab 5 (Control Flow) - Switch and Case
// Pengguna memasukkan angka bulan (1-12), lalu switch-case
// menentukan jumlah hari pada bulan tersebut.

void main() => runApp(const AplikasiHariBulan());

class Palet {
  static const latar = Color(0xFFF2F5F4);
  static const tinta = Color(0xFF12262B);
  static const teal = Color(0xFF0E7C7B);
  static const tealGelap = Color(0xFF0B3B3F);
  static const tealMuda = Color(0xFFD6EFEC);
  static const kuning = Color(0xFFF2A541);
  static const galat = Color(0xFFC2410C);
}

const daftarBulan = [
  'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
  'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
];

/// Inti latihan: switch-case untuk menentukan jumlah hari.
/// Mengembalikan null jika angka bulan tidak valid (case default).
int? hitungHari(int bulan) {
  int? hari;
  switch (bulan) {
    case 1:
    case 3:
    case 5:
    case 7:
    case 8:
    case 10:
    case 12:
      hari = 31;
      break;
    case 4:
    case 6:
    case 9:
    case 11:
      hari = 30;
      break;
    case 2:
      hari = 28;
      break;
    default:
      hari = null;
  }
  return hari;
}

class AplikasiHariBulan extends StatelessWidget {
  const AplikasiHariBulan({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hari dalam Bulan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Palet.teal,
          surface: Palet.latar,
        ),
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
  final _controller = TextEditingController();
  int? _bulan;
  int? _hari;
  String? _galat;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _hitung() {
    final bulan = int.tryParse(_controller.text.trim());

    if (bulan == null) {
      setState(() {
        _bulan = null;
        _hari = null;
        _galat = 'Masukkan angka bulan, dari 1 sampai 12.';
      });
      return;
    }

    final hari = hitungHari(bulan);
    if (hari == null) {
      setState(() {
        _bulan = null;
        _hari = null;
        _galat = 'Angka $bulan bukan bulan yang valid. Gunakan 1 sampai 12.';
      });
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _bulan = bulan;
      _hari = hari;
      _galat = null;
    });
  }

  void _hapus() {
    _controller.clear();
    setState(() {
      _bulan = null;
      _hari = null;
      _galat = null;
    });
  }

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
                    'Berapa hari dalam sebulan?',
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
                    'Ketik angka bulan, lalu lihat jumlah harinya.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Palet.tinta.withOpacity(0.65),
                    ),
                  ),
                  const SizedBox(height: 28),
                  _KartuInput(
                    controller: _controller,
                    galat: _galat,
                    onHitung: _hitung,
                    onHapus: _hapus,
                  ),
                  const SizedBox(height: 20),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    child: (_bulan != null && _hari != null)
                        ? _KartuHasil(
                      key: ValueKey(_bulan),
                      bulan: _bulan!,
                      hari: _hari!,
                    )
                        : const SizedBox.shrink(),
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

class _KartuInput extends StatelessWidget {
  const _KartuInput({
    required this.controller,
    required this.galat,
    required this.onHitung,
    required this.onHapus,
  });

  final TextEditingController controller;
  final String? galat;
  final VoidCallback onHitung;
  final VoidCallback onHapus;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Palet.tinta.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(2),
            ],
            onSubmitted: (_) => onHitung(),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Palet.tinta,
            ),
            decoration: InputDecoration(
              labelText: 'Angka bulan (1-12)',
              hintText: 'Contoh: 8',
              errorText: galat,
              errorMaxLines: 2,
              filled: true,
              fillColor: Palet.tealMuda.withOpacity(0.45),
              prefixIcon: const Icon(Icons.calendar_month_rounded,
                  color: Palet.teal),
              suffixIcon: IconButton(
                tooltip: 'Hapus',
                icon: const Icon(Icons.close_rounded),
                onPressed: onHapus,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(color: Palet.teal, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(color: Palet.galat, width: 1.5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(color: Palet.galat, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: onHitung,
            style: FilledButton.styleFrom(
              backgroundColor: Palet.teal,
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
            child: const Text('Tampilkan jumlah hari'),
          ),
        ],
      ),
    );
  }
}

class _KartuHasil extends StatelessWidget {
  const _KartuHasil({super.key, required this.bulan, required this.hari});

  final int bulan;
  final int hari;

  @override
  Widget build(BuildContext context) {
    final nama = daftarBulan[bulan - 1];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
      decoration: BoxDecoration(
        color: Palet.tealGelap,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            nama,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Palet.tealMuda,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$hari',
                style: const TextStyle(
                  fontSize: 88,
                  height: 1,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -3,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'hari',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Palet.tealMuda,
                ),
              ),
            ],
          ),
          if (bulan == 2) ...[
            const SizedBox(height: 8),
            Text(
              'Pada tahun kabisat, Februari memiliki 29 hari.',
              style: TextStyle(
                fontSize: 14,
                color: Palet.tealMuda.withOpacity(0.85),
              ),
            ),
          ],
          const SizedBox(height: 24),
          _GridHari(hari: hari),
        ],
      ),
    );
  }
}

/// Kalender mini: satu kotak untuk setiap hari, hari terakhir disorot.
class _GridHari extends StatelessWidget {
  const _GridHari({required this.hari});

  final int hari;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOut,
      builder: (context, t, _) {
        return GridView.count(
          crossAxisCount: 7,
          mainAxisSpacing: 6,
          crossAxisSpacing: 6,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(hari, (i) {
            final mulai = (i / hari) * 0.6;
            final p = ((t - mulai) / 0.4).clamp(0.0, 1.0);
            final terakhir = i == hari - 1;

            return Opacity(
              opacity: p,
              child: Transform.scale(
                scale: 0.7 + 0.3 * p,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: terakhir
                        ? Palet.kuning
                        : Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${i + 1}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: terakhir ? Palet.tealGelap : Palet.tealMuda,
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
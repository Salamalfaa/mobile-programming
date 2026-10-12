import 'package:flutter/material.dart';
import 'mainfor1-50.dart' as for_loop;
import 'mainkategoriumur.dart' as if_else;
import 'mainwhilekelipatan3.dart' as while_loop;
import 'namabulan.dart' as switch_case;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tugas Mobile Programming',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MenuUtamaPage(),
    );
  }
}

class MenuUtamaPage extends StatelessWidget {
  const MenuUtamaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tugas Mobile Programming'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildMenuItem(
            context,
            title: '1. Angka 1 Sampai 50 (For Loop)',
            subtitle: 'Latihan Bab 5 - Control Flow (For)',
            icon: Icons.format_list_numbered,
            page: const for_loop.HalamanUtama(),
          ),
          const SizedBox(height: 12),
          _buildMenuItem(
            context,
            title: '2. Kategori Umur (If / Else)',
            subtitle: 'Latihan Bab 5 - Control Flow (If-Else)',
            icon: Icons.person_search,
            page: const if_else.HalamanUtama(),
          ),
          const SizedBox(height: 12),
          _buildMenuItem(
            context,
            title: '3. Kelipatan 3 (While Loop)',
            subtitle: 'Latihan Bab 5 - Control Flow (While)',
            icon: Icons.repeat,
            page: const while_loop.HalamanUtama(),
          ),
          const SizedBox(height: 12),
          _buildMenuItem(
            context,
            title: '4. Hari Dalam Bulan (Switch / Case)',
            subtitle: 'Latihan Bab 5 - Control Flow (Switch)',
            icon: Icons.calendar_month,
            page: const switch_case.HalamanUtama(),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget page,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(icon, color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
      ),
    );
  }
}

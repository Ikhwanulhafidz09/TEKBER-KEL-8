import 'package:flutter/material.dart';
import '../widgets/riwayat_card.dart';
import 'detail_riwayat_page.dart';

class RiwayatPage extends StatelessWidget {
  const RiwayatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text('Riwayat Peminjaman'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            RiwayatCard(
              room: 'Teater A',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DetailRiwayatPage()),
                );
              },
            ),
            RiwayatCard(
              room: 'Tower 1',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DetailRiwayatPage()),
                );
              },
            ),
            RiwayatCard(
              room: 'Pasca',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DetailRiwayatPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

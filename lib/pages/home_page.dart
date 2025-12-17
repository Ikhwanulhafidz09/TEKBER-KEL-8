import 'package:flutter/material.dart';
import 'search_page.dart';
import '../main.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- HEADER PROFILE ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.blue.shade700,
                          child: const Icon(Icons.person, color: Colors.white, size: 28),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Welcome,', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                            const Text('Kelompok 8', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    IconButton(icon: const Icon(Icons.notifications, size: 28), onPressed: () {}),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // --- RIWAYAT SECTION ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.history, color: Color(0xFF1E3A8A), size: 24),
                        SizedBox(width: 8),
                        Text('Riwayat Peminjaman', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    TextButton(onPressed: () {}, child: const Text('Lihat Semua')),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // --- CARD PEMINJAMAN ---
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 2))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Room', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(12)),
                            child: Text('Dalam Peminjaman', style: TextStyle(fontSize: 12, color: Colors.green.shade700, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text('Teater A', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      // Button Lihat Detail
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E3A8A)),
                          child: const Text('Lihat Detail', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // --- PENCARIAN CEPAT ---
                const Text('Pencarian Cepat', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Masukkan nama ruangan...',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                    prefixIcon: const Icon(Icons.search),
                  ),
                  onTap: () {
                    context.findAncestorStateOfType<MainScreenState>()?.openInfoPage(0); 
                  },
                ),
                
                const SizedBox(height: 32),
                
                // --- INFORMASI LAINNYA
                Row(
                  children: const [
                    Icon(Icons.info_outline, color: Color(0xFF1E3A8A), size: 24),
                    SizedBox(width: 8),
                    Text('Informasi Lainnya', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 16),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoCard(
                      context,
                      'Alur\nPenjelasan',
                      Icons.folder_outlined,
                      () => context.findAncestorStateOfType<MainScreenState>()?.openInfoPage(0),
                    ),
                    _buildInfoCard(
                      context,
                      'FAQ',
                      Icons.chat_bubble_outline,
                      // Logika: Buka Tab Info -> Subtab FAQ (1)
                      () => context.findAncestorStateOfType<MainScreenState>()?.openInfoPage(1),
                    ),
                    _buildInfoCard(
                      context,
                      'Kirim\nPertanyaan',
                      Icons.help_outline,
                      // Logika: Buka Tab Info -> Subtab Kirim Pertanyaan (2)
                      () => context.findAncestorStateOfType<MainScreenState>()?.openInfoPage(2),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.15), blurRadius: 6, offset: const Offset(0, 2))],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: const Color(0xFF1E3A8A).withOpacity(0.1), shape: BoxShape.circle),
                  child: Icon(icon, color: const Color(0xFF1E3A8A), size: 28),
                ),
                const SizedBox(height: 12),
                Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
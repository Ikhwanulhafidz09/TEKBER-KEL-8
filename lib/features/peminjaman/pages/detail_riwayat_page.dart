import 'package:flutter/material.dart';
import '../widgets/timeline_item.dart';

class DetailRiwayatPage extends StatelessWidget {
  const DetailRiwayatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        title: const Text('Detail Riwayat'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ================= HEADER ROOM + STATUS =================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Room', style: TextStyle(color: Colors.grey)),
                      SizedBox(height: 6),
                      Text(
                        'Teater A',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    'Status : On Going',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// ================= INFO =================
              _infoRow(
                icon: Icons.calendar_today,
                label: 'Tanggal Pinjam',
                value: '20/01/25 - 22/01/25',
              ),
              _infoRow(
                icon: Icons.group,
                label: 'Kapasitas',
                value: '150 Orang',
              ),
              _infoRow(
                icon: Icons.payments,
                label: 'Cost',
                value: 'Rp 150.000',
              ),

              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 24),

              /// ================= TIMELINE =================
              const TimelineItem(
                title: 'Permintaan Dikirim',
                desc: 'Formulir peminjaman telah dikirim oleh pengguna',
                time: '02-08-2025 / 13:50',
              ),
              const TimelineItem(
                title: 'Diterima oleh Admin Sarpras',
                desc:
                    'Permintaan berhasil masuk dan dicatat oleh admin Sarpras',
                time: '03-08-2025 / 09:50',
              ),
              const TimelineItem(
                title: 'Permintaan Disetujui',
                desc:
                    'Admin telah menyetujui permintaan peminjaman berdasarkan ketersediaan dan dokumen.',
                time: '03-08-2025 / 14:30',
              ),
              const TimelineItem(
                title: 'Peminjaman Berlangsung',
                desc:
                    'Ruangan digunakan sesuai jadwal peminjaman. Pengguna dapat menghubungi admin atau mengakhiri peminjaman lebih awal jika perlu.',
                time: 'On Going',
                active: true,
                isLast: true,
              ),

              const SizedBox(height: 32),

              /// ================= BUTTON =================
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey,
                        side: BorderSide(color: Colors.grey.shade300),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text('Batalkan Pinjaman'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2F3E75),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text('Kontak Sarpras'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ================= INFO ROW =================
  static Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 10),
          Text(
            '$label ',
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}

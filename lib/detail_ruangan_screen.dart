import 'package:flutter/material.dart';
import 'booking_form_screen.dart';

class DetailRuanganScreen extends StatelessWidget {
  final int roomId;
  final String roomName;

  const DetailRuanganScreen({
    super.key,
    required this.roomId,
    required this.roomName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Center(
        child: Container(
          width: 360,
          margin: const EdgeInsets.symmetric(vertical: 24),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // CARD
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // BACK
                      Row(
                        children: const [
                          Icon(Icons.arrow_back_ios, size: 16),
                          SizedBox(width: 4),
                          Text('Kembali', style: TextStyle(fontSize: 12)),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // TITLE
                      Center(
                        child: Column(
                          children: [
                            Text(
                              roomName,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'Room',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // IMAGE
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          'https://picsum.photos/400/250',
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // DESCRIPTION
                      const Text(
                        'Description',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Tower ITS, menyediakan berbagai ruang kelas dengan kapasitas besar.',
                        style: TextStyle(color: Colors.grey),
                      ),

                      const SizedBox(height: 12),

                      // INFO
                      Row(
                        children: const [
                          Icon(Icons.people, size: 16),
                          SizedBox(width: 8),
                          Text('Kapasitas 150 Orang'),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: const [
                          Icon(Icons.location_on, size: 16),
                          SizedBox(width: 8),
                          Text('Gedung MIPA Tower'),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // BUTTON
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E3A8A),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BookingFormScreen(
                                  roomId: roomId,
                                  roomName: roomName,
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            'Ajukan Peminjaman',
                            style: TextStyle(color: Colors.white),
                          ),
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
    );
  }
}

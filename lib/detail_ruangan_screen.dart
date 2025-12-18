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
      backgroundColor: const Color(0xFFF3F3F3),
      body: Center(
        child: Container(
          width: 380,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),

              const SizedBox(height: 8),

              // Title
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
                    const Text('Room', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ✅ IMAGE — FIXED
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  'https://htotpkpeipxtogqzykin.supabase.co/storage/v1/object/public/room-images/teatera.jpg',
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 180,
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: Icon(Icons.broken_image, size: 40),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Description
              const Text(
                'Description',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'Ruang teater dengan kapasitas besar.',
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 12),

              // Capacity
              Row(
                children: const [
                  Icon(Icons.people, size: 18),
                  SizedBox(width: 8),
                  Text('Kapasitas 150 Orang'),
                ],
              ),

              const SizedBox(height: 8),

              // Location
              Row(
                children: const [
                  Icon(Icons.location_on, size: 18),
                  SizedBox(width: 8),
                  Text('Gedung Teater'),
                ],
              ),

              const SizedBox(height: 24),

              // BUTTON
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2F3E7E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
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
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

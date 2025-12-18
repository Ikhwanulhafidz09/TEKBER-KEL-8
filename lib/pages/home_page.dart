import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'search_page.dart';
import 'detail_ruangan_screen.dart'; // kalau mau tombol "Lihat Detail" menuju detail

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SupabaseClient supabase = Supabase.instance.client;

  bool _loadingBooking = false;
  Map<String, dynamic>? _latestBooking; // gabungan booking + rooms(...)
  String? _bookingError;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchLatestBooking();
  }

  Future<void> _fetchLatestBooking() async {
    setState(() {
      _loadingBooking = true;
      _bookingError = null;
    });

    try {
      // Ambil 1 booking terbaru + join room
      final data = await supabase
          .from('bookings')
          .select(
            'id, created_at, start_time, end_time, room_id, purpose, rooms(id, nama_ruangan, kapasitas, lokasi, harga_sewa)',
          )
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      setState(() {
        _latestBooking = data;
      });
    } catch (e) {
      setState(() {
        _bookingError = e.toString();
      });
    } finally {
      setState(() {
        _loadingBooking = false;
      });
    }
  }

  // ===== helpers format =====
  String _two(int n) => n.toString().padLeft(2, '0');

  String _formatDate(DateTime dt) => '${_two(dt.day)}/${_two(dt.month)}/${dt.year.toString().substring(2)}';

  String _formatTime(DateTime dt) => '${_two(dt.hour)}.${_two(dt.minute)} WIB';

  String _formatDateRange(DateTime start, DateTime end) => '${_formatDate(start)} - ${_formatDate(end)}';

  String _formatTimeRange(DateTime start, DateTime end) => '${_formatTime(start)} - ${_formatTime(end)}';

  String _formatRupiah(num value) {
    // format sederhana: 160000 -> Rp160.000
    final s = value.toStringAsFixed(0);
    final buf = StringBuffer();
    int count = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      buf.write(s[i]);
      count++;
      if (count % 3 == 0 && i != 0) buf.write('.');
    }
    return 'Rp${buf.toString().split('').reversed.join()}';
  }

  bool _isOngoing(DateTime start, DateTime end) {
    final now = DateTime.now().toUtc(); // Supabase biasanya simpan UTC
    return now.isAfter(start.toUtc()) && now.isBefore(end.toUtc());
  }

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
                // Header dengan Profile dan Notification
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.blue.shade700,
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome,',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            const Text(
                              'Kelompok 8',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.notifications,
                            size: 28,
                            color: Colors.black,
                          ),
                          onPressed: () {},
                        ),
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Riwayat Peminjaman Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.history,
                          color: Color(0xFF1E3A8A),
                          size: 24,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Riwayat Peminjaman',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: _fetchLatestBooking, // refresh cepat
                      child: Row(
                        children: [
                          Text(
                            'Refresh',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          Icon(
                            Icons.refresh,
                            color: Colors.grey[600],
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ===== CARD PEMINJAMAN (DYNAMIC) =====
                _buildLatestBookingCard(context),

                const SizedBox(height: 32),

                // Pencarian Cepat Section
                Row(
                  children: const [
                    Icon(
                      Icons.search,
                      color: Color(0xFF1E3A8A),
                      size: 24,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Pencarian Cepat',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Search Bar
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Masukkan nama ruangan...',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                    suffixIcon: Icon(Icons.tune, color: Colors.grey[400]),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchRuanganPage(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                // Cari Ruangan Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SearchRuanganPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E3A8A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Cari Ruangan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Informasi Lainnya Section
                Row(
                  children: const [
                    Icon(
                      Icons.info_outline,
                      color: Color(0xFF1E3A8A),
                      size: 24,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Informasi Lainnya',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Info Cards Grid
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoCard(
                      'Alur\nPenjelasan',
                      Icons.folder_outlined,
                      () {},
                    ),
                    _buildInfoCard(
                      'FAQ',
                      Icons.chat_bubble_outline,
                      () {},
                    ),
                    _buildInfoCard(
                      'Kirim\nPertanyaan',
                      Icons.help_outline,
                      () {},
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1E3A8A),
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        onTap: (index) {
          if (index == _currentIndex) return;

          setState(() => _currentIndex = index);

          if (index == 2) {
            // Search
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SearchRuanganPage()),
            ).then((_) {
              // balik dari Search -> highlight kembali ke Home
              if (mounted) setState(() => _currentIndex = 0);
            });
          }

          // nanti bisa kamu tambah:
          // else if (index == 1) { Navigator.push(...RiwayatPage...) }
          // else if (index == 3) { Navigator.push(...InfoPage...) }
          // else if (index == 4) { Navigator.push(...ProfilePage...) }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.info_outline), label: 'Info'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildLatestBookingCard(BuildContext context) {
    if (_loadingBooking) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_bookingError != null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text('Gagal load booking: $_bookingError'),
      );
    }

    if (_latestBooking == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text('Belum ada data peminjaman di tabel bookings.'),
      );
    }

    final booking = _latestBooking!;
    final room = (booking['rooms'] ?? {}) as Map<String, dynamic>;

    final roomId = (room['id'] ?? booking['room_id']) as int;
    final roomName = (room['nama_ruangan'] ?? '-') as String;
    final kapasitas = (room['kapasitas'] ?? 0).toString();
    final harga = (room['harga_sewa'] ?? 0);
    final start = DateTime.parse(booking['start_time']);
    final end = DateTime.parse(booking['end_time']);

    final ongoing = _isOngoing(start, end);
    final statusText = ongoing ? 'Dalam Peminjaman' : 'Terjadwal';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Room',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: ongoing ? Colors.green.shade50 : Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 12,
                    color: ongoing ? Colors.green.shade700 : Colors.orange.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            roomName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.calendar_today, _formatDateRange(start, end)),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.access_time, _formatTimeRange(start, end)),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.people, '$kapasitas Orang'),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.attach_money, _formatRupiah(harga)),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailRuanganScreen(
                      roomId: roomId,
                      roomName: roomName,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A8A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Lihat Detail',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[700]),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
        ),
      ],
    );
  }

  Widget _buildInfoCard(String title, IconData icon, VoidCallback onTap) {
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
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E3A8A).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: const Color(0xFF1E3A8A), size: 28),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    height: 1.3,
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

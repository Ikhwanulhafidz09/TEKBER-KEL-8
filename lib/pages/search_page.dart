import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ✅ IMPORT PENTING: Pastikan path ini sesuai dengan struktur folder Anda
import 'booking/detail_ruangan_screen.dart'; 

class SearchRuanganPage extends StatefulWidget {
  const SearchRuanganPage({super.key});

  @override
  State<SearchRuanganPage> createState() => _SearchRuanganPageState();
}

class _SearchRuanganPageState extends State<SearchRuanganPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController _searchController = TextEditingController();

  // ⚠️ PASTIKAN nama bucket ini sesuai dengan yang ada di Supabase Storage Anda
  final String bucketName = 'room-images';

  int _selectedCapacity = 0;
  List<String> _selectedFacilities = [];

  // Variabel Filter Tanggal & Waktu
  DateTime? _selectedDate;
  ShiftOption? _selectedShift;

  // Opsi Shift (Sesuaikan jamnya dengan aturan bisnis Anda)
  final List<ShiftOption> _shiftOptions = const [
    ShiftOption('Shift 1 (08.00 - 10.00)', 8, 0, 10, 0),
    ShiftOption('Shift 2 (10.00 - 12.00)', 10, 0, 12, 0),
    ShiftOption('Shift 3 (13.00 - 15.00)', 13, 0, 15, 0),
    ShiftOption('Shift 4 (15.00 - 17.00)', 15, 0, 17, 0),
  ];

  bool _loading = false;
  List<Map<String, dynamic>> rooms = [];

  @override
  void initState() {
    super.initState();
    _fetchRooms();
  }

  // ================== LOGIKA CEK KETERSEDIAAN ==================
  // Mengambil ID ruangan yang SUDAH dibooking pada rentang waktu tertentu
  Future<List<int>> _fetchBookedRoomIds(DateTime start, DateTime end) async {
    final res = await supabase
        .from('bookings')
        .select('room_id')
        .lt('start_time', end.toIso8601String()) // Mulai sebelum booking berakhir
        .gt('end_time', start.toIso8601String()); // Berakhir setelah booking mulai

    final ids = <int>{};
    for (final row in (res as List)) {
      final rid = row['room_id'];
      if (rid is int) ids.add(rid);
    }
    return ids.toList();
  }

  // ================= FETCH ROOMS =================
  Future<void> _fetchRooms({String query = ''}) async {
    setState(() => _loading = true);

    try {
      // 1. Hitung Range Waktu jika filter aktif
      DateTime? start;
      DateTime? end;
      if (_selectedDate != null && _selectedShift != null) {
        start = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          _selectedShift!.startHour,
          _selectedShift!.startMinute,
        );
        end = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          _selectedShift!.endHour,
          _selectedShift!.endMinute,
        );
      }

      // 2. Cari ID ruangan yang sibuk (booked)
      List<int> bookedIds = [];
      if (start != null && end != null) {
        bookedIds = await _fetchBookedRoomIds(start, end);
      }

      // 3. Query Utama ke Tabel Rooms
      var q = supabase.from('rooms').select(
        'id, nama_ruangan, deskripsi, kapasitas, lokasi, harga_sewa, facilities, image_path',
      );

      // Filter Pencarian Teks
      if (query.trim().isNotEmpty) {
        q = q.or('nama_ruangan.ilike.%$query%,lokasi.ilike.%$query%');
      }

      // Filter Kapasitas
      if (_selectedCapacity > 0) {
        q = q.gte('kapasitas', _selectedCapacity);
      }

      // Filter Fasilitas
      if (_selectedFacilities.isNotEmpty) {
        q = q.contains('facilities', _selectedFacilities);
      }

      // Filter: Exclude ruangan yang sudah dibooking (Not In)
      if (bookedIds.isNotEmpty) {
        final inStr = '(${bookedIds.join(',')})'; // Format "(1,2,5)"
        q = q.not('id', 'in', inStr);
      }

      final data = await q.order('nama_ruangan');

      setState(() {
        rooms = (data as List).map<Map<String, dynamic>>((r) {
          return {
            'id': r['id'].toString(), // Simpan sementara sebagai String
            'name': r['nama_ruangan'] ?? '-',
            'location': r['lokasi'] ?? '-',
            'description': r['deskripsi'] ?? '',
            'capacity': r['kapasitas'] ?? 0,
            'price': r['harga_sewa'] ?? 0,
            'facilities': List<String>.from(r['facilities'] ?? []),
            'imagePath': (r['image_path'] ?? '').toString(),
          };
        }).toList();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error load ruangan: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _searchRooms(String query) => _fetchRooms(query: query);
  void _applyFilters() => _fetchRooms(query: _searchController.text.trim());

  void _resetFilters() {
    setState(() {
      _selectedCapacity = 0;
      _selectedFacilities.clear();
      _selectedDate = null;
      _selectedShift = null;
    });
    _applyFilters();
  }

  // ============ FILTER SHEET (MODAL) ============
  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Modal
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filter',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setModalState(() {
                            _selectedCapacity = 0;
                            _selectedFacilities.clear();
                            _selectedDate = null;
                            _selectedShift = null;
                          });
                        },
                        child: const Text('Reset'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // --- Filter Tanggal ---
                  const Text(
                    'Tanggal',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () async {
                      final now = DateTime.now();
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate ?? now,
                        firstDate: DateTime(now.year, now.month, now.day),
                        lastDate: now.add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        setModalState(() => _selectedDate = picked);
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _selectedDate == null
                            ? 'Pilih tanggal'
                            : '${_selectedDate!.day.toString().padLeft(2, '0')}/'
                                '${_selectedDate!.month.toString().padLeft(2, '0')}/'
                                '${_selectedDate!.year}',
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // --- Filter Waktu (Shift) ---
                  const Text(
                    'Waktu',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<ShiftOption>(
                        value: _selectedShift,
                        isExpanded: true,
                        hint: const Text('Pilih shift'),
                        items: _shiftOptions
                            .map(
                              (s) => DropdownMenuItem(
                                value: s,
                                child: Text(s.label),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          setModalState(() => _selectedShift = val);
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // --- Filter Kapasitas ---
                  const Text(
                    'Capacity',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: [
                      _buildCapacityChip('150+', 150, setModalState),
                      _buildCapacityChip('100+', 100, setModalState),
                      _buildCapacityChip('50+', 50, setModalState),
                      _buildCapacityChip('20+', 20, setModalState),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // --- Filter Fasilitas ---
                  const Text(
                    'Facilities',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _buildFacilityChip('AC', setModalState),
                      _buildFacilityChip('Proyektor', setModalState),
                      _buildFacilityChip('Sound System', setModalState),
                      _buildFacilityChip('Whiteboard', setModalState),
                      _buildFacilityChip('WiFi', setModalState),
                    ],
                  ),

                  const Spacer(),

                  // Tombol Aksi Bawah
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _resetFilters();
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('Reset'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _applyFilters();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E3A8A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text(
                            'Apply',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  FilterChip _buildCapacityChip(
      String label, int capacity, StateSetter setModalState) {
    final isSelected = _selectedCapacity == capacity;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: const Color(0xFF1E3A8A),
      backgroundColor: Colors.grey[200],
      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
      onSelected: (selected) {
        setModalState(() => _selectedCapacity = selected ? capacity : 0);
      },
    );
  }

  FilterChip _buildFacilityChip(String facility, StateSetter setModalState) {
    final isSelected = _selectedFacilities.contains(facility);
    return FilterChip(
      label: Text(facility),
      selected: isSelected,
      selectedColor: const Color(0xFF1E3A8A),
      backgroundColor: Colors.grey[200],
      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
      onSelected: (selected) {
        setModalState(() {
          if (selected) {
            _selectedFacilities.add(facility);
          } else {
            _selectedFacilities.remove(facility);
          }
        });
      },
    );
  }

  // ============ HELPER IMAGE URL ============
  String _roomImageUrl(String imagePath) {
    if (imagePath.trim().isEmpty) {
      return 'https://via.placeholder.com/300x300.png?text=Room';
    }
    // Dapatkan Public URL dari Supabase Storage
    return supabase.storage.from(bucketName).getPublicUrl(imagePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Cari Ruangan',
          style: TextStyle(
            color: Color(0xFF1E3A8A),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  const Icon(Icons.search, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: _searchRooms,
                      decoration: const InputDecoration(
                        hintText: 'Masukkan nama ruangan...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.tune, color: Colors.grey),
                    onPressed: _showFilterDialog,
                  ),
                ],
              ),
            ),
          ),

          // Label
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              children: const [
                Text(
                  'Pencarian Cepat',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // List Ruangan
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : rooms.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: rooms.length,
                        itemBuilder: (context, index) {
                          return _buildRoomCard(rooms[index]);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 60, color: Colors.grey[400]),
          const SizedBox(height: 12),
          Text(
            'Tidak ada ruangan ditemukan',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  // ============ CARD UI ============
  Widget _buildRoomCard(Map<String, dynamic> room) {
    final facilities = (room['facilities'] as List<String>);
    final facilitiesText = facilities.isEmpty ? '-' : facilities.join(', ');
    final imageUrl = _roomImageUrl(room['imagePath'] ?? '');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        // ✅ LOGIKA NAVIGASI KE DETAIL
        onTap: () {
          // Parsing aman dari String (di map) ke Int (yang dibutuhkan page detail)
          final int roomId = int.tryParse(room['id'].toString()) ?? 0;
          
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailRuanganScreen(
                roomId: roomId,
                roomName: room['name'],
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Card(
          elevation: 1.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Kiri
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    width: 115,
                    height: 115,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 115,
                      height: 115,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Info Kanan
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Room',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),

                      Text(
                        room['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        room['description'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Colors.grey[600],
                          height: 1.25,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Fasilitas
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.settings,
                              size: 16, color: Colors.grey[700]),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              facilitiesText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      // Kapasitas
                      Row(
                        children: [
                          Icon(Icons.people,
                              size: 16, color: Colors.grey[700]),
                          const SizedBox(width: 6),
                          Text(
                            '${room['capacity']} Orang',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

// MODEL SHIFT
class ShiftOption {
  final String label;
  final int startHour;
  final int startMinute;
  final int endHour;
  final int endMinute;

  const ShiftOption(
    this.label,
    this.startHour,
    this.startMinute,
    this.endHour,
    this.endMinute,
  );
}
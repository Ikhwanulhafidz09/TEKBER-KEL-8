import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SearchRuanganPage extends StatefulWidget {
  const SearchRuanganPage({super.key});

  @override
  State<SearchRuanganPage> createState() => _SearchRuanganPageState();
}

class _SearchRuanganPageState extends State<SearchRuanganPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController _searchController = TextEditingController();

  // GANTI sesuai bucket Storage kamu
  final String bucketName = 'room-images';

  int _selectedCapacity = 0;
  List<String> _selectedFacilities = [];

  bool _loading = false;
  List<Map<String, dynamic>> rooms = [];

  @override
  void initState() {
    super.initState();
    _fetchRooms();
  }

  Future<void> _fetchRooms({String query = ''}) async {
    setState(() => _loading = true);

    try {
      var q = supabase.from('rooms').select(
        'id, nama_ruangan, deskripsi, kapasitas, lokasi, harga_sewa, facilities, image_path',
      );

      if (query.trim().isNotEmpty) {
        q = q.or('nama_ruangan.ilike.%$query%,lokasi.ilike.%$query%');
      }

      if (_selectedCapacity > 0) {
        q = q.gte('kapasitas', _selectedCapacity);
      }

      if (_selectedFacilities.isNotEmpty) {
        q = q.contains('facilities', _selectedFacilities);
      }

      final data = await q.order('nama_ruangan');

      setState(() {
        rooms = (data as List).map<Map<String, dynamic>>((r) {
          return {
            'id': r['id'].toString(),
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
    });
    _applyFilters();
  }

  // ============ FILTER SHEET ============
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
              height: MediaQuery.of(context).size.height * 0.65,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
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
                          });
                        },
                        child: const Text('Reset'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Capacity
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

                  // Facilities
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

  // ============ IMAGE URL BUILDER ============
  String _roomImageUrl(String imagePath) {
    // imagePath contoh dari DB: "teatera.jpg"
    // Jika kamu simpan di folder, mis. "rooms/teatera.jpg", ini juga aman.

    if (imagePath.trim().isEmpty) {
      return 'https://via.placeholder.com/300x300.png?text=Room';
    }

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

  // Card UI (mirip desain kamu) + pakai image storage
  Widget _buildRoomCard(Map<String, dynamic> room) {
    final facilities = (room['facilities'] as List<String>);
    final facilitiesText = facilities.isEmpty ? '-' : facilities.join(', ');

    final imageUrl = _roomImageUrl(room['imagePath'] ?? '');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          // TODO: navigate detail
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
                // Image kiri
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

                // Info kanan
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
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Colors.grey[600],
                          height: 1.25,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // fasilitas
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

                      // kapasitas
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
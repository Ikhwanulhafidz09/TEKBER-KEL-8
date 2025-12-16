import 'package:flutter/material.dart';

class SearchRuanganPage extends StatefulWidget {
  const SearchRuanganPage({super.key});

  @override
  State<SearchRuanganPage> createState() => _SearchRuanganPageState();
}

class _SearchRuanganPageState extends State<SearchRuanganPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedBuilding = '';
  String _selectedDate = '';
  int _selectedCapacity = 0;
  List<String> _selectedFacilities = [];
  
  // Data dummy untuk ruangan+gabungin supabasenya nanti, bikin tampilan dulz
  List<Map<String, dynamic>> allRooms = [
    {
      'id': 'TWT-101',
      'name': 'Teater A',
      'building': 'Tower 1 gedung Timur lt 0 ITS Surabaya',
      'image': 'assets/room.jpg',
      'capacity': 100,
      'facilities': ['AC', 'Proyektor', 'Sound System'],
      'status': 'Tersedia',
    },
    {
      'id': 'TWT-201',
      'name': 'Teater B',
      'building': 'Tower 2 gedung Timur lt 1 ITS Surabaya',
      'image': 'assets/room.jpg',
      'capacity': 150,
      'facilities': ['AC', 'Proyektor'],
      'status': 'Tersedia',
    },
  ];
  
  List<Map<String, dynamic>> filteredRooms = [];
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    filteredRooms = List.from(allRooms);
  }

  void _searchRooms(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredRooms = List.from(allRooms);
      } else {
        filteredRooms = allRooms.where((room) {
          return room['id'].toLowerCase().contains(query.toLowerCase()) ||
                 room['name'].toLowerCase().contains(query.toLowerCase()) ||
                 room['building'].toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
      _applyFilters();
    });
  }

  void _applyFilters() {
    setState(() {
      filteredRooms = filteredRooms.where((room) {
        bool matchesCapacity = _selectedCapacity == 0 || 
                               room['capacity'] >= _selectedCapacity;
        bool matchesFacilities = _selectedFacilities.isEmpty ||
                                _selectedFacilities.every(
                                  (facility) => room['facilities'].contains(facility)
                                );
        return matchesCapacity && matchesFacilities;
      }).toList();
    });
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: const EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height * 0.7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Filter',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Tanggal Filter
                const Text(
                  'End Date',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    hintText: '2/4/25',
                    suffixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setModalState(() {
                        _selectedDate = '${date.day}/${date.month}/${date.year}';
                      });
                    }
                  },
                ),
                
                const SizedBox(height: 20),
                
                // Capacity Filter
                const Text(
                  'Capacity',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    _buildCapacityChip('100+', 100, setModalState),
                    _buildCapacityChip('50+', 50, setModalState),
                    _buildCapacityChip('20+', 20, setModalState),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Filter
                const Text(
                  'Facilities',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildFacilityChip('AC', setModalState),
                    _buildFacilityChip('Proyektor', setModalState),
                    _buildFacilityChip('Sound System', setModalState),
                    _buildFacilityChip('Whiteboard', setModalState),
                    _buildFacilityChip('WiFi', setModalState),
                  ],
                ),
                
                const Spacer(),
                
                // Apply Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _applyFilters();
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E3A8A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Apply',
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
        },
      ),
    );
  }

  Widget _buildCapacityChip(String label, int capacity, StateSetter setModalState) {
    final isSelected = _selectedCapacity == capacity;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setModalState(() {
          _selectedCapacity = selected ? capacity : 0;
        });
      },
      backgroundColor: Colors.grey[200],
      selectedColor: const Color(0xFF1E3A8A),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
      ),
    );
  }

  Widget _buildFacilityChip(String facility, StateSetter setModalState) {
    final isSelected = _selectedFacilities.contains(facility);
    return FilterChip(
      label: Text(facility),
      selected: isSelected,
      onSelected: (selected) {
        setModalState(() {
          if (selected) {
            _selectedFacilities.add(facility);
          } else {
            _selectedFacilities.remove(facility);
          }
        });
      },
      backgroundColor: Colors.grey[200],
      selectedColor: const Color(0xFF1E3A8A),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
      ),
    );
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
            color: Color.fromARGB(255, 3, 0, 183),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar + Filter
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: _searchRooms,
                    decoration: InputDecoration(
                      hintText: 'Masukkan nama ruangan...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E3A8A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.tune, color: Colors.white),
                    onPressed: _showFilterDialog,
                  ),
                ),
              ],
            ),
          ),
          
          // Filters Display On
          if (_selectedCapacity > 0 || _selectedFacilities.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  if (_selectedCapacity > 0)
                    Chip(
                      label: Text('Capacity: $_selectedCapacity+'),
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () {
                        setState(() {
                          _selectedCapacity = 0;
                          _applyFilters();
                        });
                      },
                    ),
                  ..._selectedFacilities.map((facility) => Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Chip(
                          label: Text(facility),
                          deleteIcon: const Icon(Icons.close, size: 16),
                          onDeleted: () {
                            setState(() {
                              _selectedFacilities.remove(facility);
                              _applyFilters();
                            });
                          },
                        ),
                      )),
                ],
              ),
            ),
          
          const SizedBox(height: 8),
          
          // Pencarian Cepat
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pencarian Cepat',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickSearchButton('Hari Ini', Icons.today),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildQuickSearchButton('Besok', Icons.calendar_today),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildQuickSearchButton('Minggu Ini', Icons.calendar_month),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Hasil Pencarian Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hasil Pencarian',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  '${filteredRooms.length} Ruangan',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Ruangan List
          Expanded(
            child: filteredRooms.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Tidak ada ruangan ditemukan',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredRooms.length,
                    itemBuilder: (context, index) {
                      return _buildRoomCard(filteredRooms[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickSearchButton(String label, IconData icon) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        side: BorderSide(color: Colors.grey[300]!),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildRoomCard(Map<String, dynamic> room) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: InkWell(
        onTap: () {
          // Navigate ke detail page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RoomDetailPage(room: room),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ruangan Image
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[300],
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://via.placeholder.com/100',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    if (room['status'] == 'Tersedia')
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Tersedia',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Room Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E3A8A),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            room['id'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      room['name'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      room['building'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.people,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${room['capacity']} orang',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
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
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

// Room Detail Page
class RoomDetailPage extends StatelessWidget {
  final Map<String, dynamic> room;

  const RoomDetailPage({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(room['name']),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Room Image
            Container(
              width: double.infinity,
              height: 250,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage('https://via.placeholder.com/400'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        room['id'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3A8A),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          room['status'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  Text(
                    room['name'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          room['building'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  const Text(
                    'Kapasitas',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.people, color: Color(0xFF1E3A8A)),
                      const SizedBox(width: 8),
                      Text(
                        '${room['capacity']} orang',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  const Text(
                    'Fasilitas',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (room['facilities'] as List<String>)
                        .map((facility) => Chip(
                              label: Text(facility),
                              backgroundColor: const Color(0xFF1E3A8A).withOpacity(0.1),
                              labelStyle: const TextStyle(
                                color: Color(0xFF1E3A8A),
                              ),
                            ))
                        .toList(),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to booking page
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A8A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Book',
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
            ),
          ],
        ),
      ),
    );
  }
}
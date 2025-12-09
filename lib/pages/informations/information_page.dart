import 'dart:io';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InformationPage extends StatefulWidget {
  final int initialIndex; // Menerima index tab yang harus dibuka

  const InformationPage({super.key, this.initialIndex = 0});

  @override
  State<InformationPage> createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Inisialisasi TabController dengan index awal dari Home Page
    _tabController = TabController(
        length: 3, vsync: this, initialIndex: widget.initialIndex);
  }

  // --- BAGIAN PENTING (Agar Tab berubah saat diklik dari Home) ---
  @override
  void didUpdateWidget(InformationPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Jika parent (MainScreen) mengirim index baru, pindahkan tab
    if (widget.initialIndex != oldWidget.initialIndex) {
      _tabController.animateTo(widget.initialIndex);
    }
  }
  // -------------------------------------------------------------

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Informasi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        // Hapus tombol back otomatis agar tidak ada panah di kiri atas
        automaticallyImplyLeading: false, 
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF1E3A8A),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF1E3A8A),
          indicatorWeight: 3,
          labelStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: const [
            Tab(text: 'Alur Penjelasan'),
            Tab(text: 'FAQ'),
            Tab(text: 'Kirim Pertanyaan'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _AlurPenjelasanTab(),
          _FAQTab(),
          _KirimPertanyaanTab(),
        ],
      ),
    );
  }
}

// ================= TAB 1: ALUR PENJELASAN =================
class _AlurPenjelasanTab extends StatefulWidget {
  const _AlurPenjelasanTab();

  @override
  State<_AlurPenjelasanTab> createState() => _AlurPenjelasanTabState();
}

class _AlurPenjelasanTabState extends State<_AlurPenjelasanTab> {
  late YoutubePlayerController _controller;

  // Link Video
  final String _videoUrl = 'https://youtu.be/dG_gEYUfEjI?si=YaS0v4FI2fmXdrIX';
  
  // Link Dokumen
  final String _documentUrl = 'https://drive.google.com/file/d/1LZqBmON3dtwLWxKsqsLaY_-3ZtYfHG9q/view?usp=drive_link';

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(_videoUrl);
    _controller = YoutubePlayerController(
      initialVideoId: videoId ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _downloadDocument() async {
    final Uri url = Uri.parse(_documentUrl);
    // Mode externalApplication agar membuka browser/drive app
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal membuka link dokumen')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Video Tutorial',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          
          // --- YOUTUBE PLAYER ---
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              progressIndicatorColor: const Color(0xFF1E3A8A),
              progressColors: const ProgressBarColors(
                playedColor: Color(0xFF1E3A8A),
                handleColor: Color(0xFF1E3A8A),
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          const Text(
            'Alur Peminjaman',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: const Text(
              'Alur Peminjaman di myITS Sarpras adalah sebagai berikut:\n- Cari ruangan dan waktu yang sesuai\n- Cek fasilitas yang tersedia\n- Ajukan peminjaman\n- Tunggu persetujuan admin',
              style: TextStyle(height: 1.5, color: Colors.black87),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Template Dokumen Peminjaman',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _downloadDocument,
              icon: const Icon(Icons.download, color: Colors.white),
              label: const Text('Lihat Dokumen',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A8A),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ================= TAB 2: FAQ =================
class _FAQTab extends StatelessWidget {
  const _FAQTab();

  final List<Map<String, String>> faqs = const [
    {
      'question': 'Bagaimana cara filter pencarian?',
      'answer':
          'Buka halaman Cari Ruangan, lalu klik ikon Filter di sebelah kolom pencarian. Anda bisa memfilter berdasarkan tanggal, kapasitas, dan fasilitas.'
    },
    {
      'question': 'Dimana letak ruangan Sarpras?',
      'answer':
          'Ruangan Sarpras tersebar di berbagai gedung. Cek detail ruangan untuk melihat lokasi spesifik (Gedung dan Lantai).'
    },
    {
      'question': 'Berapa maksimal waktu peminjaman?',
      'answer':
          'Maksimal waktu peminjaman tergantung pada kebijakan masing-masing ruangan, umumnya maksimal 1 hari kerja.'
    },
    {
      'question': 'Apa sistem penalti saat peminjaman?',
      'answer':
          'Jika membatalkan mendadak atau merusak fasilitas, akun Anda mungkin akan ditangguhkan sementara.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: faqs.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        return Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            title: Text(
              faqs[index]['question']!,
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            expandedAlignment: Alignment.centerLeft,
            iconColor: const Color(0xFF1E3A8A),
            collapsedIconColor: Colors.grey,
            children: [
              Text(
                faqs[index]['answer']!,
                style: const TextStyle(color: Colors.grey, height: 1.4),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ================= TAB 3: KIRIM PERTANYAAN =================
class _KirimPertanyaanTab extends StatefulWidget {
  const _KirimPertanyaanTab();

  @override
  State<_KirimPertanyaanTab> createState() => _KirimPertanyaanTabState();
}

class _KirimPertanyaanTabState extends State<_KirimPertanyaanTab> {
  final TextEditingController _questionController = TextEditingController();
  String _selectedPriority = 'Sedang';
  PlatformFile? _pickedFile;
  bool _isLoading = false;

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  // Fungsi Pilih File
  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'pdf', 'doc', 'docx'],
    );

    if (result != null) {
      setState(() {
        _pickedFile = result.files.first;
      });
    }
  }

  // Fungsi Hapus File
  void _clearFile() {
    setState(() {
      _pickedFile = null;
    });
  }

  // Fungsi Kirim ke Supabase
  Future<void> _submitQuestion() async {
    if (_questionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pertanyaan tidak boleh kosong')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      String? attachmentUrl;

      // 1. Upload File jika ada
      if (_pickedFile != null && _pickedFile!.path != null) {
        final file = File(_pickedFile!.path!);
        final fileExt = _pickedFile!.extension ?? 'file';
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';
        
        // Upload ke Storage Bucket 'files'
        await Supabase.instance.client.storage
            .from('files')
            .upload(fileName, file);
        
        // Ambil Public URL
        attachmentUrl = Supabase.instance.client.storage
            .from('files')
            .getPublicUrl(fileName);
      }

      // 2. Insert ke Database
      await Supabase.instance.client.from('user_questions').insert({
        'question_text': _questionController.text,
        'priority': _selectedPriority,
        'attachment_url': attachmentUrl,
        'status': 'Pending',
      });

      if (mounted) {
        // Pindah ke halaman sukses
        Navigator.of(context).push(
          PageRouteBuilder(
            opaque: false,
            pageBuilder: (context, _, __) => const _SuccessScreen(),
          ),
        );
        
        // Reset Form
        _questionController.clear();
        setState(() {
          _pickedFile = null;
          _selectedPriority = 'Sedang';
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Buat Pertanyaan',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          
          // Input Field
          TextField(
            controller: _questionController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Pertanyaan (max. 500 kata)',
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          
          const SizedBox(height: 16),
          const Text('Dokumen (Opsional)',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          
          // --- UPLOAD BUTTON ---
          InkWell(
            onTap: _pickFile,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[50],
              ),
              child: Row(
                children: [
                  Icon(
                    _pickedFile != null ? Icons.check_circle : Icons.cloud_upload_outlined,
                    color: _pickedFile != null ? Colors.green : Colors.grey[600]
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _pickedFile != null ? _pickedFile!.name : 'Unggah file (jpg, png, pdf)',
                      style: TextStyle(
                        color: _pickedFile != null ? Colors.black87 : Colors.grey[600],
                        overflow: TextOverflow.ellipsis
                      ),
                    ),
                  ),
                  if (_pickedFile != null)
                    GestureDetector(
                      onTap: _clearFile, // Tombol X untuk hapus file
                      child: const Icon(Icons.close, size: 20, color: Colors.red),
                    )
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),
          const Text('Sifat Pertanyaan',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          
          // Radio Buttons
          Row(
            children: [
              _buildRadio('Rendah'),
              const SizedBox(width: 16),
              _buildRadio('Sedang'),
              const SizedBox(width: 16),
              _buildRadio('Menengah'),
            ],
          ),

          const SizedBox(height: 24),
          
          // Button Kirim
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submitQuestion,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A8A),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: _isLoading 
                ? const SizedBox(
                    height: 20, width: 20, 
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                  )
                : const Text('Kirim',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadio(String value) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: _selectedPriority,
          activeColor: const Color(0xFF1E3A8A),
          visualDensity: VisualDensity.compact,
          onChanged: (val) {
            setState(() {
              _selectedPriority = val!;
            });
          },
        ),
        Text(value, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}

// ================= SUCCESS SCREEN =================
class _SuccessScreen extends StatelessWidget {
  const _SuccessScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E3A8A),
      body: InkWell(
        onTap: () => Navigator.pop(context),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check,
                      color: Color(0xFF1E3A8A), size: 40),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Pertanyaan Anda\nBerhasil Dikirim!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              Text(
                'Ketuk layar untuk kembali',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.6), fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
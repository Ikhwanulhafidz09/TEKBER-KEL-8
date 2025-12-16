import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'success_booking_screen.dart';

class BookingFormScreen extends StatefulWidget {
  final String roomName;
  const BookingFormScreen({super.key, required this.roomName});

  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  final _namaC = TextEditingController();
  final _nrpC = TextEditingController();
  final _prodiC = TextEditingController();
  final _ketC = TextEditingController();
  final _contactC = TextEditingController();

  DateTime? _tanggalAwal;
  DateTime? _tanggalAkhir;

  final Color navy = const Color(0xFF2E3B7A);

  String _fmt(DateTime? d) =>
      d == null ? "" : DateFormat('dd/MM/yyyy').format(d);

  Future<void> _pickAwal() async {
    final p = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (p != null) setState(() => _tanggalAwal = p);
  }

  Future<void> _pickAkhir() async {
    final p = await showDatePicker(
      context: context,
      initialDate: _tanggalAwal ?? DateTime.now(),
      firstDate: _tanggalAwal ?? DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (p != null) setState(() => _tanggalAkhir = p);
  }

  // ============================================================
  //                 🔥 SUBMIT BOOKING SUPABASE (FIX FINAL)
  // ============================================================
  Future<void> _submitBooking() async {
    if (_ketC.text.isEmpty ||
        _contactC.text.isEmpty ||
        _tanggalAwal == null ||
        _tanggalAkhir == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lengkapi semua data terlebih dahulu.")),
      );
      return;
    }

    try {
      final supabase = Supabase.instance.client;

      print("🔎 Cari ruangan: ${widget.roomName}");

      // ---- FIX 1: SELECT HARUS DEFINISI KOLOM DAN TYPE DIPAKSA LIST ----
      final rooms = await supabase
          .from("rooms")
          .select("id, nama_ruangan")
          .then((value) => value as List);

      if (rooms.isEmpty) {
        throw "Tabel rooms kosong / tidak dapat dibaca.";
      }

      // ---- FIX 2: NORMALISASI NAMA RUANGAN ----
      String input = widget.roomName.trim().replaceAll("  ", " ").toLowerCase();

      Map<String, dynamic>? foundRoom;

      for (var r in rooms) {
        String namaDB = (r["nama_ruangan"] as String)
            .trim()
            .replaceAll("  ", " ")
            .toLowerCase();

        if (namaDB == input) {
          foundRoom = r;
          break;
        }
      }

      if (foundRoom == null) {
        throw "Ruangan '${widget.roomName}' tidak ditemukan di database.";
      }

      int roomId = foundRoom["id"];
      print("✅ Room ID ditemukan: $roomId");

      final String userId = const Uuid().v4();

      await supabase.from("bookings").insert({
        "user_id": userId,
        "room_id": roomId,
        "start_time": _tanggalAwal!.toIso8601String(),
        "end_time": _tanggalAkhir!.toIso8601String(),
        "purpose": _ketC.text,
        "contact": _contactC.text,
        "doc_path": "-",
        "status": "dikirim",
      });

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SuccessBookingScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal submit: $e")));
    }
  }

  // ============================================================
  //                           UI
  // ============================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Container(
          width: 360,
          height: 800,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: _buildContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            const SizedBox(height: 10),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Book Page",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
            ),
            const SizedBox(height: 10),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // DETAIL RUANGAN
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 16,
                      ),
                      width: double.infinity,
                      color: const Color(0xFFCECECE),
                      child: Column(
                        children: [
                          const Text(
                            "Detail Ruangan",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            widget.roomName,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // FORM
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(26),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text("Back"),
                              Text(
                                "Book",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Icon(Icons.close),
                            ],
                          ),

                          const SizedBox(height: 20),

                          _rowLabel("Room"),
                          _lineField(widget.roomName),

                          _rowLabel("Nama"),
                          _lineFieldController(_namaC, "Masukkan Nama Anda"),

                          _rowLabel("NRP"),
                          _lineFieldController(_nrpC, "Masukkan NRP"),

                          _rowLabel("Prodi"),
                          _lineFieldController(_prodiC, "Masukkan Prodi"),

                          _rowLabel("Tanggal Awal"),
                          _datePickerBox(_pickAwal, _tanggalAwal),

                          _rowLabel("Tanggal Akhir"),
                          _datePickerBox(_pickAkhir, _tanggalAkhir),

                          _rowLabel("Keterangan"),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black54),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: TextField(
                              controller: _ketC,
                              maxLines: 2,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                border: InputBorder.none,
                                hintText: "Tambahkan Keterangan",
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),
                          _fileRow(),

                          const SizedBox(height: 16),
                          _contactRow(),

                          const SizedBox(height: 30),
                          Center(
                            child: SizedBox(
                              width: 180,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: navy,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed: _submitBooking,
                                child: const Text(
                                  "Submit",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // COMPONENTS
  // ============================================================

  Widget _rowLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 4),
      child: Text(
        "$text  :",
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _lineField(String value) {
    return Container(
      decoration: const ShapeDecoration(shape: UnderlineInputBorder()),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(value),
      ),
    );
  }

  Widget _lineFieldController(TextEditingController c, String hint) {
    return Container(
      decoration: const ShapeDecoration(shape: UnderlineInputBorder()),
      child: TextField(
        controller: c,
        decoration: InputDecoration(border: InputBorder.none, hintText: hint),
      ),
    );
  }

  Widget _datePickerBox(Function() onTap, DateTime? date) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black54),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          date == null ? "Pilih Tanggal" : _fmt(date),
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  Widget _fileRow() {
    return Row(
      children: [
        const Text(
          "File  :",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              "Upload File",
              style: TextStyle(color: Colors.black54),
            ),
          ),
        ),
        const SizedBox(width: 6),
        const Icon(Icons.upload_file),
      ],
    );
  }

  Widget _contactRow() {
    return Row(
      children: [
        const Text("Contact  :", style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            decoration: const ShapeDecoration(shape: UnderlineInputBorder()),
            child: TextField(
              controller: _contactC,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Masukkan Nomor Anda",
              ),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'success_booking_screen.dart';

class BookingFormScreen extends StatefulWidget {
  final int roomId;
  final String roomName;

  const BookingFormScreen({
    super.key,
    required this.roomId,
    required this.roomName,
  });

  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  DateTime? selectedDate;
  String? selectedShift;

  final purposeCtrl = TextEditingController();
  final contactCtrl = TextEditingController();

  final supabase = Supabase.instance.client;

  final Map<String, List<int>> shifts = {
    'Shift 1 (08.00 - 10.00)': [8, 10],
    'Shift 2 (10.00 - 12.00)': [10, 12],
    'Shift 3 (15.00 - 17.00)': [15, 17],
  };

  Future<void> submitBooking() async {
    if (selectedDate == null || selectedShift == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Lengkapi tanggal & shift')));
      return;
    }

    final hours = shifts[selectedShift]!;
    final startTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      hours[0],
    );
    final endTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      hours[1],
    );

    try {
      await supabase.from('bookings').insert({
        'room_id': widget.roomId,
        'start_time': startTime.toIso8601String(),
        'end_time': endTime.toIso8601String(),
        'purpose': purposeCtrl.text,
        'contact': contactCtrl.text,
        'status': 'dikirim',
      });

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SuccessBookingScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal submit: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book'), leading: BackButton()),
      body: Center(
        child: Container(
          width: 380,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Room : ${widget.roomName}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // TANGGAL
              TextFormField(
                readOnly: true,
                decoration: const InputDecoration(labelText: 'Tanggal'),
                controller: TextEditingController(
                  text: selectedDate == null
                      ? ''
                      : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                ),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) {
                    setState(() => selectedDate = picked);
                  }
                },
              ),

              const SizedBox(height: 12),

              // SHIFT
              DropdownButtonFormField<String>(
                value: selectedShift,
                hint: const Text('Shift'),
                items: shifts.keys
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => setState(() => selectedShift = v),
              ),

              const SizedBox(height: 12),

              // KETERANGAN
              TextFormField(
                controller: purposeCtrl,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Keterangan'),
              ),

              const SizedBox(height: 12),

              // KONTAK
              TextFormField(
                controller: contactCtrl,
                decoration: const InputDecoration(labelText: 'Kontak'),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: submitBooking,
                  child: const Text('Kirim'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

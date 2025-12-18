import 'package:flutter/material.dart';

class BookPage extends StatelessWidget {
  const BookPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// DRAG HANDLE
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),

              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Back'),
                  const Text(
                    'Book',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              _label('Room'),
              const Text(
                'Teater A',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Divider(),

              _label('Nama'),
              _input('Masukkan Nama Anda'),

              _label('NRP'),
              _input('Masukkan NRP'),

              _label('Prodi'),
              _input('Masukkan Prodi'),

              _label('Tanggal Awal'),
              _dateButton(),

              _label('Tanggal Akhir'),
              _dateButton(),

              _label('Keterangan'),
              _textarea('Tambahkan Keterangan'),

              _label('File'),
              _fileUpload(),

              _label('Contact'),
              _input('Masukkan Nomor Anda'),

              const SizedBox(height: 24),

              /// SUBMIT BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2F3E75),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ===== COMPONENTS =====

  static Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 6),
      child: Text(
        '$text :',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  static Widget _input(String hint) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        enabledBorder: const UnderlineInputBorder(),
      ),
    );
  }

  static Widget _textarea(String hint) {
    return TextField(
      maxLines: 3,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  static Widget _dateButton() {
    return OutlinedButton(onPressed: () {}, child: const Text('Pilih Tanggal'));
  }

  static Widget _fileUpload() {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.upload),
      label: const Text('Upload File'),
    );
  }
}

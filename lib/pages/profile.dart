import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _imagePath;
  String? _imageUrl; // remote public URL in Supabase
  bool _isUploading = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadSavedImage();
  }

  Future<void> _loadSavedImage() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString('profile_image_path');
    if (path != null && mounted) {
      setState(() => _imagePath = path);
    }
  }

  Future<void> _pickImage() async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1000,
      imageQuality: 85,
    );
    if (picked == null) return; // user cancelled

    final appDir = await getApplicationDocumentsDirectory();
    final ext = picked.path.split('.').last;
    final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.$ext';
    final savedImage = await File(picked.path).copy('${appDir.path}/$fileName');

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image_path', savedImage.path);

    // Try upload to Supabase storage
    const bucket = 'avatars'; // Ensure this bucket exists in your Supabase project
    final remotePath = 'profiles/$fileName';

    setState(() => _isUploading = true);
    try {
      final bytes = await savedImage.readAsBytes();
      // Upload bytes to Supabase storage
      await Supabase.instance.client.storage.from(bucket).uploadBinary(remotePath, bytes);
      // Get public URL (string)
      final publicUrlStr = Supabase.instance.client.storage.from(bucket).getPublicUrl(remotePath);
      await prefs.setString('profile_image_url', publicUrlStr);
      if (mounted) setState(() => _imageUrl = publicUrlStr);

      // If user is authenticated, try to update their profile record with avatar URL
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        // Not authenticated: inform user that image is only saved locally
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Anda belum login — foto disimpan lokal saja')),
        );
      } else {
        try {
          final res = await Supabase.instance.client.from('profiles').upsert({
            'id': user.id,
            'avatar_url': publicUrlStr,
          });

          // If upsert doesn't throw, assume success. Provide feedback to user.
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Foto profil berhasil disimpan di server')),
          );
        } catch (e) {
          // Upsert failed — still keep local copy and notify user
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menyimpan avatar ke database: $e')),
          );
        }
      }
    } catch (e) {
      // Upload failed: still keep local image but inform user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload gagal: $e')),
      );
    } finally {
      if (mounted) setState(() {
        _imagePath = savedImage.path;
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Profil',
          style: TextStyle(
            color: Color.fromARGB(255, 3, 0, 183),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // Foto profil
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.black12,
                  backgroundImage: _imageUrl != null
                      ? NetworkImage(_imageUrl!) as ImageProvider
                      : (_imagePath != null ? FileImage(File(_imagePath!)) as ImageProvider : null),
                  child: (_imageUrl == null && _imagePath == null)
                      ? const Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.black,
                        )
                      : null,
                ),
                if (_isUploading)
                  const Positioned.fill(
                    child: ColoredBox(
                      color: Color.fromRGBO(255, 255, 255, 0.6),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 10),

            TextButton(
              onPressed: _isUploading ? null : _pickImage,
              child: const Text(
                "Ganti Photo",
                style: TextStyle(color: Colors.blue),
              ),
            ),

            const SizedBox(height: 30),

            // MENU Profile
            profileMenu(Icons.person, "Akun", "Ganti Password, Edit Data Akun", () {}),
            profileMenu(Icons.history, "Riwayat Aktivitas", "Lihat riwayat aktivitas anda", () {}),
            profileMenu(Icons.apps, "Versi Aplikasi", "Versi 2.5.1", () {}),
            profileMenu(Icons.logout, "Keluar", "Keluar dari akun", () {}),
          ],
        ),
      ),
    );
  }

  Widget profileMenu(
    IconData icon,
    String title,
    String subtitle,
    Function() onTap,
  ) {
    return ListTile(
      tileColor: Colors.white,
      leading: Icon(icon, size: 28, color: Colors.black87),
      title: Text(
        title,
        style: const TextStyle(color: Colors.black),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Colors.black54),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
    );
  }
}
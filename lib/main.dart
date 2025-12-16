import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_config.dart';
import 'booking_form_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(url: SupaConfig.url, anonKey: SupaConfig.anonKey);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // ❗ FIX DISINI → kasih roomName default biar tidak error
      home: const BookingFormScreen(
        roomName: "Teater A", // bebas mau apa—harus ada
      ),
    );
  }
}

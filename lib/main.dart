import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// --- IMPORT HALAMAN ---
import 'pages/home_page.dart';
import 'pages/search_page.dart';
import 'pages/informations/information_page.dart';
import 'pages/welcome_screen/welcome.dart'; // Import WelcomeScreen disini

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://cmquixcfpyypysdojnrv.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNtcXVpeGNmcHl5cHlzZG9qbnJ2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQzMjk4MTQsImV4cCI6MjA3OTkwNTgxNH0.LQgf3phWK35HJM6-UKMYJR5JwblEY1uJy5Xwjsy993s',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'myITS Sarpras',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E3A8A)),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      // Set WelcomeScreen sebagai halaman pertama
      home: const WelcomeScreen(), 
    );
  }
}

// ============================================
// MAIN SCREEN (Halaman Utama dengan BottomNav)
// ============================================

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  int _infoTabInitialIndex = 0;

  void openInfoPage(int subTabIndex) {
    setState(() {
      _selectedIndex = 3;
      _infoTabInitialIndex = subTabIndex;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomePage(),
      const Center(child: Text('Halaman Riwayat')),
      const SearchPage(),
      InformationPage(initialIndex: _infoTabInitialIndex),
      const Center(child: Text('Halaman Profile')),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1E3A8A),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
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
}
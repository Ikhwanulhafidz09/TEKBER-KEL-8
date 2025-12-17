import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'pages/home_page.dart';
import 'pages/search_page.dart';
import 'pages/informations/information_page.dart';
import 'pages/welcome_screen/welcome.dart'; 
import 'pages/supabase_config.dart'; 
import 'pages/profile.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupaConfig.url, 
    anonKey: SupaConfig.anonKey
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

  // Fungsi untuk membuka tab Info pada sub-tab tertentu (misal: FAQ)
  void openInfoPage(int subTabIndex) {
    setState(() {
      _selectedIndex = 3; // Pindah ke Tab Info (Index 3)
      _infoTabInitialIndex = subTabIndex; // Set sub-tab
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
      const HomePage(),                                       // Index 0: Home
      const Center(child: Text('Halaman Riwayat')),           // Index 1: Riwayat (Placeholder)
      const SearchRuanganPage(),                              // Index 2: Search
      InformationPage(initialIndex: _infoTabInitialIndex),    // Index 3: Info
      const ProfilePage(),                                    // Index 4: Profile
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
          BottomNavigationBarItem(
            icon: Icon(Icons.home), 
            label: 'Home'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history), 
            label: 'Riwayat'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search), 
            label: 'Search'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline), 
            label: 'Info'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline), 
            label: 'Profile'
          ),
        ],
      ),
    );
  }
}
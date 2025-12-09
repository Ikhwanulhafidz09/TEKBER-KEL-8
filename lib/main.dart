import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/home_page.dart';
import 'pages/search_page.dart';
import 'pages/informations/information_page.dart'; // Sesuaikan path ini

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://cmquixcfpyypysdojnrv.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNtcXVpeGNmcHl5cHlzZG9qbnJ2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQzMjk4MTQsImV4cCI6MjA3OTkwNTgxNH0.LQgf3phWK35HJM6-UKMYJR5JwblEY1uJy5Xwjsy993s',
  );

  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

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
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => MainScreenState(); // Ubah ke MainScreenState
}

// PERUBAHAN PENTING: Hapus tanda underscore (_) agar class ini PUBLIC
class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  int _infoTabInitialIndex = 0;

  // Fungsi ini akan dipanggil dari HomePage
  void openInfoPage(int subTabIndex) {
    setState(() {
      _selectedIndex = 3; // Pindah ke Tab Info (index 3)
      _infoTabInitialIndex = subTabIndex; // Atur sub-tab (0=Alur, 1=FAQ, 2=Kirim)
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // List halaman ditaruh di sini agar bisa akses variabel state
    final List<Widget> pages = [
      const HomePage(),      // Index 0
      const Center(child: Text('Halaman Riwayat')), // Index 1
      const SearchPage(),    // Index 2
      InformationPage(initialIndex: _infoTabInitialIndex), // Index 3
      const Center(child: Text('Halaman Profile')), // Index 4
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
        selectedFontSize: 12,
        unselectedFontSize: 12,
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
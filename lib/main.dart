import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// --- IMPORT CONFIG & PAGES ---
import 'pages/supabase_config.dart';
import 'pages/home_page.dart';
import 'pages/search_page.dart'; // Pastikan di dalam file ini class-nya bernama SearchRuanganPage
import 'pages/informations/information_page.dart';
import 'pages/welcome_screen/welcome.dart'; 
import 'pages/profile/profile.dart';
import 'pages/riwayat/riwayat_page.dart';
import 'pages/riwayat/detail_riwayat_page.dart';

// --- IMPORT AUTH PAGES ---
import 'pages/login-register/login_page.dart'; 
import 'pages/login-register/register_page.dart'; 

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupaConfig.url, 
    anonKey: SupaConfig.anonKey
  );

  runApp(const MyApp());
}

// Variabel global untuk akses klien Supabase (Dibutuhkan oleh AuthGate)
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
      ),
      // AuthGate sebagai gerbang utama: Cek Login atau Belum
      home: const AuthGate(), 
    );
  }
}

// ============================================
// AUTH GATE (Pengecekan Status Login)
// ============================================
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: supabase.auth.onAuthStateChange,
      builder: (context, snapshot) {
        // Saat pertama kali load/tunggu koneksi
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final session = snapshot.data?.session;

        if (session != null) {
          // JIKA SUDAH LOGIN -> Masuk ke Aplikasi Utama
          return const MainScreen();
        } else {
          // JIKA BELUM LOGIN -> Tampilkan Welcome Screen
          return const WelcomeScreen();
        }
      },
    );
  }
}

// ============================================
// AUTH FLOW (Logic Pindah Login <-> Register)
// ============================================
// Widget ini opsional jika WelcomeScreen Anda sudah handle switch form sendiri,
// tapi tetap saya sertakan agar tidak ada error referensi dari file lain.
class AuthFlow extends StatefulWidget {
  const AuthFlow({super.key});

  @override
  State<AuthFlow> createState() => _AuthFlowState();
}

class _AuthFlowState extends State<AuthFlow> {
  int _currentPage = 0; // 0 = Login, 1 = Register

  void _navigateToSignIn() {
    setState(() => _currentPage = 0);
  }

  void _navigateToSignUp() {
    setState(() => _currentPage = 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentPage,
        children: [
          LoginPage(onSignUpPressed: _navigateToSignUp), 
          RegisterPage(onSignInPressed: _navigateToSignIn), 
        ],
      ),
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

  // Fungsi untuk pindah ke tab Info secara spesifik (Public)
  void openInfoPage(int subTabIndex) {
    setState(() {
      _selectedIndex = 3; // Index Tab Info
      _infoTabInitialIndex = subTabIndex; 
    });
  }

  // ✅ PERBAIKAN: Fungsi ini sekarang PUBLIC (tanpa garis bawah)
  // Supaya bisa dipanggil dari HomePage (context.findAncestorStateOfType...)
  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomePage(),
      const RiwayatPage(),                                                 
      const SearchRuanganPage(),                              
      InformationPage(initialIndex: _infoTabInitialIndex),    
      const ProfilePage(),                                   
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
        
        // ✅ Panggil fungsi public yang baru
        onTap: onItemTapped, 
        
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
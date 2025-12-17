import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/home_page.dart';
import 'pages/search_page.dart';
import 'pages/informations/information_page.dart'; // Sesuaikan path ini
import 'pages/login_page.dart';
import 'pages/register_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://cmquixcfpyypysdojnrv.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNtcXVpeGNmcHl5cHlzZG9qbnJ2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQzMjk4MTQsImV4cCI6MjA3OTkwNTgxNH0.LQgf3phWK35HJM6-UKMYJR5JwblEY1uJy5Xwjsy993s',
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 9, 0, 177),
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: supabase.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.session != null) {
          return const MainScreen(); // Sudah login
        }

        // Belum login, tampilkan flow login/register
        return const AuthFlow(); // <--- Ganti di sini
      },
    );
  }
}

// ...
// Tambahkan AuthFlow di bawah AuthGate
class AuthFlow extends StatefulWidget {
  const AuthFlow({super.key});

  @override
  State<AuthFlow> createState() => _AuthFlowState();
}

class _AuthFlowState extends State<AuthFlow> {
  // 0 = Login, 1 = Register
  int _currentPage = 0;

  void _navigateToSignIn() {
    setState(() {
      _currentPage = 0;
    });
  }

  void _navigateToSignUp() {
    setState(() {
      _currentPage = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: _currentPage,
      children: [
        LoginPage(onSignUpPressed: _navigateToSignUp), // Tambahkan callback
        RegisterPage(onSignInPressed: _navigateToSignIn), // Tambahkan callback
      ],
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  // ... kode state (_selectedIndex, _infoTabInitialIndex) ...
  int _selectedIndex = 0;
  int _infoTabInitialIndex = 0;

  // Tambahkan fungsi logout (penting)
  Future<void> _signOut() async {
    try {
      await supabase.auth.signOut();
      // AuthGate akan otomatis mendeteksi perubahan ini dan mengalihkan ke LoginPage
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal logout: $e')));
      }
    }
  }

  // Fungsi ini akan dipanggil dari HomePage
  void openInfoPage(int subTabIndex) {
    setState(() {
      _selectedIndex = 3; // Pindah ke Tab Info (index 3)
      _infoTabInitialIndex =
          subTabIndex; // Atur sub-tab (0=Alur, 1=FAQ, 2=Kirim)
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
      const HomePage(), // Index 0
      const Center(child: Text('Halaman Riwayat')), // Index 1
      const SearchPage(), // Index 2
      InformationPage(initialIndex: _infoTabInitialIndex), // Index 3
      // Halaman Profile diubah
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Halaman Profile'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signOut, // Panggil fungsi logout di sini
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 9, 0, 177),
                foregroundColor: Colors.white,
              ),
              child: const Text('Logout'),
            ),
          ],
        ),
      ), // Index 4
    ];

    // ... kode BottomNavigationBar di bawah ...
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(index: _selectedIndex, children: pages),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: 'Info',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

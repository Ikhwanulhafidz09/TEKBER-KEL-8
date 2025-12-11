import 'package:flutter/material.dart';
import '../../main.dart'; 

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  // --- STATE VARIABLES ---
  bool _showKey = false;
  bool _moveKeyToSide = false;
  bool _showText = false;
  bool _hideLogoBeforeSlide = false;
  double _blueHeight = 0.0;
  bool _showFinalUI = false;

  @override
  void initState() {
    super.initState();
    _startAnimationSequence();
  }

  Future<void> _startAnimationSequence() async {
    // 1. Layar Putih (1 detik)
    await Future.delayed(const Duration(seconds: 1));

    // 2. Kunci Muncul (Besar & Tengah)
    if (mounted) setState(() => _showKey = true);
    await Future.delayed(const Duration(milliseconds: 1000));

    // 3. Kunci Geser + Teks Muncul
    if (mounted) {
      setState(() {
        _moveKeyToSide = true; 
        _showText = true;
      });
    }
    
    // Tahan Logo
    await Future.delayed(const Duration(seconds: 2));

    // 4. Logo Fade Out
    if (mounted) setState(() => _hideLogoBeforeSlide = true);
    await Future.delayed(const Duration(milliseconds: 600));

    // 5. Background Slide
    double screenHeight = MediaQuery.of(context).size.height;
    if (mounted) setState(() => _blueHeight = screenHeight);
    await Future.delayed(const Duration(milliseconds: 800));

    // 6. Final UI
    if (mounted) setState(() => _showFinalUI = true);
  }

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    // ==========================================================
    // AREA PENGATURAN MANUAL (TWEAK DISINI JIKA KURANG PAS)
    // ==========================================================
    
    // 1. Ukuran Area Container Animasi
    const double containerWidth = 320.0; 
    const double containerHeight = 100.0;

    // 2. Ukuran Objek
    const double textHeight = 80.0;   // Tinggi gambar teks
    const double keySizeBig = 100.0;   // Ukuran kunci awal
    const double keySizeSmall = 80.0; // Ukuran kunci akhir

    // 3. Posisi Akhir Kunci (Mengatur Jarak Kiri-Kanan)
    // Semakin KECIL angkanya, semakin DEKAT ke teks (kiri)
    // Semakin BESAR angkanya, semakin JAUH dari teks (kanan)
    // Sebelumnya sekitar 240, saya turunkan drastis ke 195 agar nempel.
    const double keyEndPositionLeft = 195.0; 

    // 4. Koreksi Posisi Vertikal (Mengatur Naik-Turun Kunci)
    // Jika kunci terlihat kurang naik, kurangi angkanya (misal -5.0)
    // Jika kunci terlihat kurang turun, tambah angkanya (misal 5.0)
    const double keyVerticalCorrection = 0.0; 

    // ==========================================================
    // RUMUS POSISI OTOMATIS (JANGAN DIUBAH)
    // ==========================================================
    
    // Posisi Tengah Container
    const double centerX = (containerWidth / 2);
    
    // Posisi Awal Kunci (Tepat di Tengah)
    const double keyStartPosLeft = (containerWidth - keySizeBig) / 2;
    
    // Posisi Vertikal Kunci (Tengah Vertikal)
    const double keyTopBig = (containerHeight - keySizeBig) / 2;
    const double keyTopSmall = ((containerHeight - keySizeSmall) / 2) + keyVerticalCorrection;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // --------------------------------------------------
          // LAYER 1: ANIMASI LOGO (Floating Center)
          // --------------------------------------------------
          Center(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: _hideLogoBeforeSlide ? 0.0 : 1.0,
              child: SizedBox(
                width: containerWidth,
                height: containerHeight,
                child: Stack(
                  alignment: Alignment.center, // Memastikan Teks selalu di Center
                  children: [
                    
                    // A. GAMBAR TEKS (Anchor di Tengah)
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 800),
                      opacity: _showText ? 1.0 : 0.0,
                      child: Padding(
                        // Padding kanan ini untuk mengimbangi visual center
                        // karena nanti ada kunci di kanan
                        padding: const EdgeInsets.only(right: 30.0), 
                        child: Image.asset(
                          'assets/images/text-sarana-biru.png',
                          height: textHeight,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    // B. GAMBAR KUNCI (Animasi Posisi)
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.fastOutSlowIn,
                      
                      // LOGIKA POSISI HORIZONTAL
                      left: _moveKeyToSide ? keyEndPositionLeft : keyStartPosLeft,
                      
                      // LOGIKA POSISI VERTIKAL (Sejajar)
                      top: _moveKeyToSide ? keyTopSmall : keyTopBig,
                      
                      // LOGIKA UKURAN
                      width: _moveKeyToSide ? keySizeSmall : keySizeBig,
                      height: _moveKeyToSide ? keySizeSmall : keySizeBig,
                      
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 500),
                        opacity: _showKey ? 1.0 : 0.0,
                        child: Image.asset(
                          'assets/images/kunci-biru.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // --------------------------------------------------
          // LAYER 2: BACKGROUND IMAGE (Slide Down)
          // --------------------------------------------------
          Align(
            alignment: Alignment.topCenter,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOut,
              width: double.infinity,
              height: _blueHeight,
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(),
              child: Stack(
                children: [
                  SizedBox(
                    height: fullHeight,
                    width: fullWidth,
                    child: Image.asset(
                      'assets/images/bg_welcome.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    height: fullHeight,
                    width: fullWidth,
                    color: const Color(0xFF003875).withOpacity(0.85),
                  ),
                ],
              ),
            ),
          ),

          // --------------------------------------------------
          // LAYER 3: FINAL UI (Form Login)
          // --------------------------------------------------
          if (_blueHeight > 0)
            AnimatedOpacity(
              duration: const Duration(milliseconds: 800),
              opacity: _showFinalUI ? 1.0 : 0.0,
              child: _buildFinalUI(context),
            ),
        ],
      ),
    );
  }

  Widget _buildFinalUI(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 3),
          
          // --- LOGO PUTIH FINAL ---
          SizedBox(
            width: 250, 
            height: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Teks Putih
                Padding(
                  padding: const EdgeInsets.only(right: 30.0), // Samakan dengan animasi
                  child: ColorFiltered(
                    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    child: Image.asset('assets/images/logo-full.png', height: 120),
                  ),
                ),
                // Kunci Putih (Posisi disesuaikan manual biar mirip animasi)
              ],
            ),
          ),

          const Spacer(flex: 1),

          // Tombol Login
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context, 
                  MaterialPageRoute(builder: (context) => const MainScreen())
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF003875),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Login", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),

          const SizedBox(height: 15),

          // Tombol Signup
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Signup", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
            ),
          ),

          const Spacer(flex: 3),
          const Text("MyITSSarpras Versi 1.0.0", style: TextStyle(color: Colors.white54, fontSize: 12)),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
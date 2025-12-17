import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../main.dart'; // Akses variabel supabase

class LoginPage extends StatefulWidget {
  final VoidCallback onSignUpPressed;

  const LoginPage({super.key, required this.onSignUpPressed});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isObscure = true;

  // UPDATED: Warna Biru Baru (#2B5CFF)
  final Color _itsBlue = const Color(0xFF003875);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showSnackBar(context, 'Email dan Password harus diisi.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final AuthResponse response = await supabase.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (response.session != null) {
        // Login Sukses
        return;
      }
    } on AuthException catch (error) {
      if (mounted) {
        _showSnackBar(context, error.message);
        setState(() => _isLoading = false);
      }
    } catch (error) {
      if (mounted) {
        _showSnackBar(context, 'Terjadi kesalahan: $error');
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // 1. BACKGROUND IMAGE
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg_its.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: _itsBlue),
            ),
          ),

          // 2. OVERLAY WARNA BIRU (Updated Color)
          Positioned.fill(
            child: Container(
              color: _itsBlue.withOpacity(
                0.70,
              ), // Transparansi 85% dari warna #2B5CFF
            ),
          ),

          // 3. KONTEN UTAMA
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: SizedBox(
              height: size.height,
              child: Column(
                children: [
                  // --- BAGIAN ATAS (LOGO - 1/3 Layar) ---
                  SizedBox(
                    height: size.height / 3,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),

                        // LOGO FULL (Teks + Kunci jadi satu)
                        Image.asset(
                          'assets/images/logo-full.png',
                          height: 100,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Column(
                              children: [
                                Icon(
                                  Icons.broken_image,
                                  color: Colors.white,
                                  size: 50,
                                ),
                                Text(
                                  "logo-full.png not found",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  // --- BAGIAN BAWAH (FORM LOGIN - 2/3 Layar) ---
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(30, 40, 30, 20),
                        child: Column(
                          children: [
                            Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: _itsBlue, // Menggunakan warna baru
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                top: 10,
                                bottom: 40,
                              ),
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),

                            // Input Email
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Alamat Email',
                                labelStyle: TextStyle(
                                  color: Colors.grey.shade600,
                                ),
                                hintText: '----------',
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: _itsBlue,
                                    width: 2,
                                  ), // Warna border baru
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Input Password
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _isObscure,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                  color: Colors.grey.shade600,
                                ),
                                hintText: '----------------',
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: _itsBlue,
                                    width: 2,
                                  ), // Warna border baru
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isObscure
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isObscure = !_isObscure;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),

                            // Tombol Masuk
                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _signIn,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      _itsBlue, // Background tombol baru
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                  disabledBackgroundColor: _itsBlue,
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        'Masuk',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Link Daftar
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Belum punya akun? ',
                                  style: TextStyle(color: Colors.grey.shade800),
                                ),
                                GestureDetector(
                                  onTap: widget.onSignUpPressed,
                                  child: Text(
                                    'Daftar Sekarang',
                                    style: TextStyle(
                                      color: _itsBlue, // Warna link baru
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 40),

                            Text(
                              'MyITSSarpras Versi 1.0.0',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

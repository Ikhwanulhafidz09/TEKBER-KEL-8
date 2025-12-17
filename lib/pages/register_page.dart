import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../main.dart'; // Akses variabel supabase

class RegisterPage extends StatefulWidget {
  final VoidCallback onSignInPressed;

  const RegisterPage({super.key, required this.onSignInPressed});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController(); // Confirm Pass
  final _fullNameController = TextEditingController();
  final _nrpController = TextEditingController();
  final _prodiController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isObscure = true;
  bool _isConfirmObscure = true;

  // Warna Biru ITS (#003875)
  final Color _itsBlue = const Color(0xFF003875);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameController.dispose();
    _nrpController.dispose();
    _prodiController.dispose();
    super.dispose();
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    // Validasi Password Match
    if (_passwordController.text != _confirmPasswordController.text) {
      _showSnackBar(context, 'Password dan Ulangi Password tidak sama.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 1. Auth Sign Up
      final AuthResponse response = await supabase.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final user = response.user;

      if (user != null) {
        // 2. Insert ke tabel 'profiles'
        await supabase.from('profiles').insert({
          'id': user.id,
          'full_name': _fullNameController.text.trim(),
          'NRP': int.tryParse(_nrpController.text.trim()) ?? 0,
          'prodi': _prodiController.text.trim(),
        });

        if (mounted) {
          _showSnackBar(context, 'Pendaftaran berhasil! Silakan login.');
          widget.onSignInPressed(); // Balik ke halaman login
        }
      }
    } on AuthException catch (error) {
      if (mounted) {
        _showSnackBar(context, error.message);
      }
    } catch (error) {
      if (mounted) {
        _showSnackBar(context, 'Terjadi kesalahan: $error');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      // resizeToAvoidBottomInset: true is CRITICAL for scrollable forms
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

          // 2. OVERLAY WARNA BIRU
          Positioned.fill(child: Container(color: _itsBlue.withOpacity(0.85))),

          // 3. KONTEN UTAMA
          SingleChildScrollView(
            // ClampingScrollPhysics prevents "bouncing" that reveals background behind header
            physics: const ClampingScrollPhysics(),
            child: SizedBox(
              // Using constraint to ensure layout takes full height initially
              height: size.height,
              child: Column(
                children: [
                  // --- BAGIAN ATAS (LOGO - 1/4 Layar agar form muat) ---
                  SizedBox(
                    height: size.height * 0.25,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30),
                        Image.asset(
                          'assets/images/logo-full.png',
                          height: 90, // Ukuran logo
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.broken_image,
                              color: Colors.white,
                              size: 50,
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  // --- BAGIAN BAWAH (FORM REGISTER - 3/4 Layar) ---
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
                      // Scrollable content inside the white box
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 30,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: _itsBlue,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                  top: 10,
                                  bottom: 30,
                                ),
                                width: 40,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),

                              // --- INPUT FIELDS ---

                              // 1. Nama Lengkap
                              _buildTextField(
                                controller: _fullNameController,
                                label: 'Nama Lengkap',
                                hint: 'Masukkan nama lengkap',
                                validator: (v) =>
                                    v!.isEmpty ? 'Wajib diisi' : null,
                              ),
                              const SizedBox(height: 16),

                              // 2. Email
                              _buildTextField(
                                controller: _emailController,
                                label: 'Alamat Email',
                                hint: 'email@example.com',
                                inputType: TextInputType.emailAddress,
                                validator: (v) =>
                                    v!.isEmpty ? 'Wajib diisi' : null,
                              ),
                              const SizedBox(height: 16),

                              // 3. NRP
                              _buildTextField(
                                controller: _nrpController,
                                label: 'NRP',
                                hint: '50252...',
                                inputType: TextInputType.number,
                                validator: (v) =>
                                    v!.isEmpty ? 'Wajib diisi' : null,
                              ),
                              const SizedBox(height: 16),

                              // 4. Prodi
                              _buildTextField(
                                controller: _prodiController,
                                label: 'Program Studi',
                                hint: 'Teknik Informatika',
                                validator: (v) =>
                                    v!.isEmpty ? 'Wajib diisi' : null,
                              ),
                              const SizedBox(height: 16),

                              // 5. Password
                              _buildPasswordField(
                                controller: _passwordController,
                                label: 'Password',
                                obscureText: _isObscure,
                                onToggle: () =>
                                    setState(() => _isObscure = !_isObscure),
                                validator: (v) =>
                                    v!.length < 6 ? 'Min 6 karakter' : null,
                              ),
                              const SizedBox(height: 16),

                              // 6. Ulangi Password
                              _buildPasswordField(
                                controller: _confirmPasswordController,
                                label: 'Ulangi Password',
                                obscureText: _isConfirmObscure,
                                onToggle: () => setState(
                                  () => _isConfirmObscure = !_isConfirmObscure,
                                ),
                                validator: (v) => v != _passwordController.text
                                    ? 'Password tidak sama'
                                    : null,
                              ),

                              const SizedBox(height: 40),

                              // --- TOMBOL DAFTAR ---
                              SizedBox(
                                width: double.infinity,
                                height: 55,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _signUp,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _itsBlue,
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
                                          'Daftar',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                              ),

                              const SizedBox(height: 24),

                              // --- LINK LOGIN ---
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Sudah punya akun? ',
                                    style: TextStyle(
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: widget.onSignInPressed,
                                    child: Text(
                                      'Login',
                                      style: TextStyle(
                                        color: _itsBlue,
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widget untuk membuat TextField biasa agar kodenya rapi
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType inputType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade600),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _itsBlue, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
    );
  }

  // Helper Widget khusus Password Field
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade600),
        hintText: '----------------',
        hintStyle: TextStyle(color: Colors.grey.shade400),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _itsBlue, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: Colors.grey,
          ),
          onPressed: onToggle,
        ),
      ),
    );
  }
}

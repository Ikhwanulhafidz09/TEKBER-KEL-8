import 'package:flutter/material.dart';
import 'search_page.dart'; // ← IMPORT SEARCH PAGE

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final Color navy = const Color(0xFF2E3B7A);
  final Color bg = const Color(0xFFF5F5F5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: LayoutBuilder(
        builder: (context, constraints) {
          double deviceWidth = constraints.maxWidth;
          if (deviceWidth > 400) deviceWidth = 360; // tampilan HP 360px

          return Center(
            child: Container(
              width: deviceWidth,
              color: bg,
              child: SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    // =================== HEADER =====================
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.black87,
                          ),
                          const SizedBox(width: 10),

                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Welcome, Ezra",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  "5026221191@student.its.ac.id",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Icon(Icons.notifications_none, size: 26),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // BUTTON PROFIL
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: navy,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () {},
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Lihat Profil",
                                style: TextStyle(fontSize: 15),
                              ),
                              SizedBox(width: 6),
                              Icon(Icons.arrow_forward_ios, size: 14),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // =================== HISTORY ======================
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: const [
                          Icon(Icons.remove_red_eye_outlined, size: 20),
                          SizedBox(width: 6),
                          Text(
                            "History Peminjaman",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // CARD TEATER A
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Text(
                                  "Room",
                                  style: TextStyle(color: Colors.black54),
                                ),
                                Spacer(),
                                Text(
                                  "Status : On Going",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 4),

                            const Text(
                              "Teater A",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),

                            const SizedBox(height: 6),
                            Container(height: 1, color: Colors.black12),

                            const SizedBox(height: 10),

                            Row(
                              children: const [
                                Icon(Icons.calendar_today, size: 15),
                                SizedBox(width: 6),
                                Text("Tanggal Pinjam"),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: const [
                                Icon(Icons.people_alt, size: 15),
                                SizedBox(width: 6),
                                Text("Kapasitas"),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: const [
                                Icon(Icons.monetization_on, size: 15),
                                SizedBox(width: 6),
                                Text("Cost"),
                              ],
                            ),

                            const SizedBox(height: 14),

                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: navy,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () {},
                                child: const Text(
                                  "Lihat Detail",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // =================== FILTER ======================
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.10),
                              blurRadius: 12,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: navy,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Nyalakan Filter",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(Icons.settings, color: Colors.white),
                                ],
                              ),
                            ),

                            const SizedBox(height: 12),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),
                              child: Row(
                                children: const [
                                  Icon(Icons.email_outlined, size: 18),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "Insert Nama Ruangan..",
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 12),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: navy,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 22,
                                      vertical: 10,
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: const Text(
                                    "Cari Ruangan",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),
                              child: Row(
                                children: const [
                                  Icon(Icons.email_outlined, size: 18),
                                  SizedBox(width: 6),
                                  Text("Filter Aktif"),
                                ],
                              ),
                            ),

                            const SizedBox(height: 10),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),
                              child: Row(
                                children: [
                                  _chip(Icons.people, "100+"),
                                  const SizedBox(width: 8),
                                  _chip(Icons.calendar_today, "27/4/25"),
                                  const SizedBox(width: 8),
                                  _chip(Icons.monetization_on, "3 jt"),
                                ],
                              ),
                            ),

                            const SizedBox(height: 18),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 26),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "FAQ & Informasi Alur",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _faqIcon("Most Asked", Icons.help_outline),
                        _faqIcon("Alur Penjelasan", Icons.info_outline),
                        _faqIcon("Kirim Pertanyaan", Icons.chat_bubble_outline),
                      ],
                    ),

                    const SizedBox(height: 50),

                    // =================== NAV BAR =======================
                    Container(
                      color: navy,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const _navItem(Icons.home, "Home", true),
                          const _navItem(Icons.history, "Histori", false),

                          // ⭐ CARI — Ubah ini saja
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SearchPage(),
                                ),
                              );
                            },
                            child: const _navItem(Icons.search, "Cari", false),
                          ),

                          const _navItem(Icons.info_outline, "Info", false),
                          const _navItem(Icons.person_outline, "Profil", false),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ======================= COMPONENTS ==============================

class _chip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _chip(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class _faqIcon extends StatelessWidget {
  final String text;
  final IconData icon;
  const _faqIcon(this.text, this.icon);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 40),
        const SizedBox(height: 4),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class _navItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool active;

  const _navItem(this.icon, this.text, this.active);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: active ? Colors.white : Colors.white70),
        const SizedBox(height: 6),
        Text(
          text,
          style: TextStyle(
            color: active ? Colors.white : Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

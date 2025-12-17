import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  final Color navy = const Color(0xFF2E3B7A);
  final Color bg = const Color(0xFFF5F5F5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: LayoutBuilder(
        builder: (context, constraints) {
          double deviceWidth = constraints.maxWidth;
          if (deviceWidth > 400) deviceWidth = 360;

          return Center(
            child: Container(
              width: deviceWidth,
              color: bg,
              child: SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    // ================= BACK =================
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Text(
                              "Back",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // ================= TITLE =================
                    const Text(
                      "Cari Ruangan",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ================= SEARCH BAR =================
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(color: Colors.black26),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Text(
                                "Masukkan nama ruangan...",
                                style: TextStyle(color: Colors.black54),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: navy,
                                borderRadius: BorderRadius.circular(40),
                              ),
                              padding: const EdgeInsets.all(10),
                              child: const Icon(
                                Icons.settings,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ================= FILTER AKTIF =================
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Filter Aktif",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),

                          Row(
                            children: [
                              _chip(Icons.people, "100+"),
                              const SizedBox(width: 8),
                              _chip(Icons.calendar_today, "27/4/25"),
                              const SizedBox(width: 8),
                              _chip(Icons.monetization_on, "3 jt"),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ================= HASIL PENCARIAN =================
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Hasil Pencarian",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ================= CARD TW1-101 =================
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _roomCard(
                              title: "TW1–101",
                              chips: const ["100+", "27/4/25", "2,5 jt"],
                              imagePath:
                                  "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Tower_1_ITS.jpg/640px-Tower_1_ITS.jpg",
                              description:
                                  "Tower 1 ITS adalah gedung 11 lantai di ITS Surabaya, berfungsi sebagai pusat perkuliahan dan kantor.",
                            ),

                            const SizedBox(height: 20),

                            // ================= CARD TEATER A =================
                            _roomCard(
                              title: "Teater A",
                              chips: const ["100+", "27/4/25", "2,5 jt"],
                              imagePath:
                                  "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5b/Teater_A_ITS.jpg/640px-Teater_A_ITS.jpg",
                              description:
                                  "Teater A ITS adalah auditorium utama di kampus ITS Surabaya untuk acara berskala besar.",
                            ),

                            const SizedBox(height: 20),

                            // ================= PAGINATION =================
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _pageButton("1", true),
                                _pageButton("2", false),
                                _pageButton("3", false),
                                _pageButton("4", false),
                                _pageButton("5", false),
                                const Text("  ....  "),
                                _pageButton("9", false),
                              ],
                            ),

                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),

                    // ================= BOTTOM NAV =================
                    Container(
                      color: navy,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          _navItem(Icons.home, "Home", false),
                          _navItem(Icons.history, "Histori", false),
                          _navItem(Icons.search, "Cari", true),
                          _navItem(Icons.info_outline, "Info", false),
                          _navItem(Icons.person_outline, "Profil", false),
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

// ===================== COMPONENTS =====================

Widget _chip(IconData icon, String label) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: Color(0xFF2E3B7A),
      borderRadius: BorderRadius.circular(30),
    ),
    child: Row(
      children: [
        Icon(icon, size: 14, color: Colors.white),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.white)),
      ],
    ),
  );
}

Widget _roomCard({
  required String title,
  required List<String> chips,
  required String imagePath,
  required String description,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: chips
              .map(
                (c) => Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: _chip(Icons.people, c),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 6),

        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 4),

        const Text("Room", style: TextStyle(color: Colors.black54)),

        const SizedBox(height: 12),

        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            imagePath,
            height: 170,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),

        const SizedBox(height: 10),

        Text(description, style: const TextStyle(fontSize: 13)),
      ],
    ),
  );
}

Widget _pageButton(String number, bool active) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 6),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: active ? Color(0xFF2E3B7A) : Colors.white,
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        number,
        style: TextStyle(
          color: active ? Colors.white : Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
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

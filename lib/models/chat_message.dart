class ChatMessage {
  String text;
  bool isUser; // true = user (kanan), false = bot (kiri)
  DateTime time;
  bool isAction; // Jika true, text ditampilkan sebagai tombol opsi

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.time,
    this.isAction = false,
  });
}
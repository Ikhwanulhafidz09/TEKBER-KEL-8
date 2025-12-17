class UserModel {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
  });

  // Factory untuk convert dari JSON (Supabase)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['full_name'] ?? 'User',
      email: json['email'] ?? '',
      avatarUrl: json['avatar_url'],
    );
  }

  // Data Dummy untuk User saat ini (Kelompok 8)
  static UserModel get currentUser => UserModel(
    id: 'user-001', 
    name: 'Kelompok 8', 
    email: 'kelompok8@its.ac.id'
  );
}
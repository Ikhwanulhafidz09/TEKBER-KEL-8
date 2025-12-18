import 'package:flutter/material.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.root,
      routes: AppRoutes.routes,

      /// 🔒 FORCE LAYOUT JADI MOBILE (HP)
      builder: (context, child) {
        return Center(
          child: Container(
            color: const Color(0xFFE5E5E5), // background desktop
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24), // bentuk device HP
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 430, // lebar HP (± iPhone besar)
                ),
                child: MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaleFactor: 1.0, // kunci skala font mobile
                  ),
                  child: child!,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

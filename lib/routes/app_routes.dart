import 'package:flutter/material.dart';
import '../core/layouts/main_layout.dart';

class AppRoutes {
  static const root = '/';

  static Map<String, WidgetBuilder> routes = {root: (_) => const MainLayout()};
}

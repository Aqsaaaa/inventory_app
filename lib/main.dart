import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
  show FlutterSecureStorage;
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory/screens/bottom_bar_screen.dart';
import 'package:inventory/screens/stats_screen.dart';
import 'screens/login_screen.dart';
// import 'screens/items_screen.dart';
import 'screens/add_item_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> checkToken() async {
  final storage = FlutterSecureStorage();
  final token = await storage.read(key: 'token');
  return token != null;
  }

  @override
  Widget build(BuildContext context) {
  return MaterialApp(
    title: 'Inventory Management',
    theme: ThemeData(
    textTheme: GoogleFonts.poppinsTextTheme(),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: FutureBuilder<bool>(
    future: checkToken(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
      return const CircularProgressIndicator();
      }
      return snapshot.data == true ? BottomNavBar() : LoginScreen();
    },
    ),
    routes: {
    '/dashboard': (context) => BottomNavBar(),
    '/add_item': (context) => AddItemScreen(),
    '/stats_status': (context) => ItemStatsScreen(),
    },
  );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory/screens/bottom_bar_screen.dart';
import 'package:inventory/screens/detail_item_screen.dart';
import 'package:inventory/screens/stats_screen.dart';
import 'package:inventory/screens/form_screen.dart';
import 'screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
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
      debugShowCheckedModeBanner: false,
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
          return snapshot.data == true
              ? const BottomNavBar()
              : const LoginScreen();
        },
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const BottomNavBar(),
        '/stats_status': (context) => const ItemStatsScreen(),
        '/detail_item': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as int?;
          if (args == null) {
            return const Scaffold(
              body: Center(child: Text("Error: No item ID provided")),
            );
          }
          return DetailItemScreen(id: args);
        },

        '/form': (context) {
          final formMode =
              ModalRoute.of(context)?.settings.arguments as String? ?? 'add';
          return UploadForm(key: UniqueKey(), formMode: formMode);
        },
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'add_note_page.dart';
import 'view_notes_page.dart';
import 'note_detail_page.dart'; // Import halaman detail

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/add-note': (context) => const AddNotePage(),
        '/view-notes': (context) => const ViewNotesPage(),
      },
      // Route dinamis untuk NoteDetailPage dengan parameter
      onGenerateRoute: (settings) {
        if (settings.name == '/note-detail') {
          final args = settings.arguments;

          // Validasi agar args tidak null dan bertipe Map
          if (args is Map<String, dynamic> &&
              args.containsKey('noteIndex') &&
              args.containsKey('initialNote')) {
            return MaterialPageRoute(
              builder: (context) => NoteDetailPage(
                noteIndex: args['noteIndex'],
                initialNote: args['initialNote'],
              ),
            );
          } else {
            return MaterialPageRoute(
              builder: (context) => const Scaffold(
                body: Center(child: Text("Argument tidak valid")),
              ),
            );
          }
        }

        // Fallback jika route tidak dikenali
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(child: Text("Halaman tidak ditemukan")),
          ),
        );
      },
    );
  }
}

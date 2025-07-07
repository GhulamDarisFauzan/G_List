import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> notes = [];

  Future<void> _navigateToAddNote() async {
    final newNote = await Navigator.pushNamed(context, '/add-note');
    if (newNote != null && newNote is String) {
      setState(() {
        notes.add(newNote);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Catatan berhasil disimpan!")),
      );
    }
  }

  void _navigateToViewNotes() {
    Navigator.pushNamed(
      context,
      '/view-notes',
      arguments: notes,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[700],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.star,
                size: 80,
                color: Colors.white70,
              ),
              const SizedBox(height: 16),
              const Text(
                'G-List',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),

              // Tombol Masukkan Catatan Baru
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: _navigateToAddNote,
                  child: const Text("Masukkan Catatan Baru"),
                ),
              ),
              const SizedBox(height: 16),

              // Tombol Lihat Catatan
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: _navigateToViewNotes,
                  child: const Text("Lihat Catatan"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewNotesPage extends StatefulWidget {
  const ViewNotesPage({super.key});

  @override
  State<ViewNotesPage> createState() => _ViewNotesPageState();
}

class _ViewNotesPageState extends State<ViewNotesPage> {
  List<String> allNotes = [];
  List<String> filteredNotes = [];
  String searchQuery = "";
  int currentPage = 1;
  final int notesPerPage = 5;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notes = prefs.getStringList('notes') ?? [];

    setState(() {
      allNotes = notes;
      _filterNotes();
    });
  }

  void _filterNotes() {
    final query = searchQuery.toLowerCase();
    filteredNotes = allNotes
        .where((note) => note.toLowerCase().contains(query))
        .toList();
    currentPage = 1;
  }

  List<String> get currentNotes {
    if (filteredNotes.isEmpty) return [];

    int start = (currentPage - 1) * notesPerPage;
    int end = (start + notesPerPage).clamp(0, filteredNotes.length);
    if (start >= filteredNotes.length) return [];

    return filteredNotes.sublist(start, end);
  }

  int get totalPages =>
      (filteredNotes.length / notesPerPage).ceil().clamp(1, filteredNotes.length);

  void _nextPage() {
    if (currentPage < totalPages) {
      setState(() => currentPage++);
    }
  }

  void _prevPage() {
    if (currentPage > 1) {
      setState(() => currentPage--);
    }
  }

  void _goToPage(int page) {
    setState(() => currentPage = page);
  }

  void _onSearch(String query) {
    setState(() {
      searchQuery = query;
      _filterNotes();
    });
  }

  List<Widget> _buildPageNumbers() {
    List<Widget> pages = [];
    int startPage = (currentPage - 2).clamp(1, totalPages);
    int endPage = (currentPage + 2).clamp(1, totalPages);

    for (int i = startPage; i <= endPage; i++) {
      pages.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: ElevatedButton(
            onPressed: () => _goToPage(i),
            style: ElevatedButton.styleFrom(
              backgroundColor: currentPage == i ? Colors.yellow : Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: Text(i.toString()),
          ),
        ),
      );
    }

    return pages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[700],
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Daftar Catatan', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            TextField(
              onChanged: _onSearch,
              decoration: InputDecoration(
                hintText: 'Cari Catatan Anda',
                prefixIcon: const Icon(Icons.search),
                fillColor: Colors.white,
                filled: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: currentNotes.isEmpty
                  ? const Center(
                      child: Text(
                        "Tidak ada catatan ditemukan.",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: currentNotes.length,
                      itemBuilder: (context, index) {
                        int noteNumber = (currentPage - 1) * notesPerPage + index;
                        int actualIndex = noteNumber;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  "$noteNumber. ${currentNotes[index]}",
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  final result = await Navigator.pushNamed(
                                    context,
                                    '/note-detail',
                                    arguments: {
                                      'noteIndex': actualIndex, // ✅ fix
                                      'initialNote': currentNotes[index], // ✅ fix
                                    },
                                  );

                                  if (result == true) {
                                    _loadNotes(); // Refresh notes kalau ada perubahan
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text("Cek lebih lanjut"),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            if (filteredNotes.isNotEmpty && totalPages > 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ElevatedButton(
                      onPressed: _prevPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                      child: const Text("Previous"),
                    ),
                  ),
                  ..._buildPageNumbers(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                      child: const Text("Next"),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Journal Intime',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        textTheme: GoogleFonts.poppinsTextTheme(),
                 appBarTheme: const AppBarTheme(
          foregroundColor: Colors.white, // couleur du texte et icônes
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white), // icônes en blanc
        ),
      ),
      home: const JournalLockPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Page pour entrer le mot de passe
class JournalLockPage extends StatefulWidget {
  const JournalLockPage({super.key});

  @override
  State<JournalLockPage> createState() => _JournalLockPageState();
}

class _JournalLockPageState extends State<JournalLockPage> {
  final TextEditingController _passwordController = TextEditingController();
  final String _password = "1234"; // mot de passe par défaut

  void _unlockJournal() {
    if (_passwordController.text == _password) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const JournalPage()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Mot de passe incorrect")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Entrer le mot de passe pour accéder au journal",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Mot de passe",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _unlockJournal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text("Accéder", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Modèle de journal
class JournalEntry {
  String title;
  String content;
  DateTime createdAt;

  JournalEntry({
    required this.title,
    required this.content,
    required this.createdAt,
  });
}

// Page principale du journal
class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  List<JournalEntry> entries = [];

  // Ouvrir l'éditeur de journal
  void _openJournalEntry({JournalEntry? entry, int? index}) async {
    final JournalEntry? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => JournalEditorPage(entry: entry)),
    );

    setState(() {
      if (result != null) {
        if (index != null) {
          entries[index] = result;
        } else {
          entries.add(result);
        }
      } else if (entry != null && index != null) {
        // Supprime l'entrée vide si on enregistre sans contenu
        if (entry.title.isEmpty && entry.content.isEmpty) {
          entries.removeAt(index);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
                "Mon Journal Intime",
                style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openJournalEntry(),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add, size: 28),
      ),
      body:
          entries.isEmpty
              ? Center(
                child: Text(
                  "Aucune confession pour l'instant",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  JournalEntry entry = entries[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 6,
                      shadowColor: Colors.deepPurpleAccent.withOpacity(0.2),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap:
                            () => _openJournalEntry(entry: entry, index: index),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(
                            entry.title.isEmpty ? "Sans titre" : entry.title,
                            style: GoogleFonts.poppins(
                              fontSize: 22, // titre plus grand
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple[700],
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              DateFormat(
                                'yyyy-MM-dd HH:mm',
                              ).format(entry.createdAt), // seulement la date
                              style: GoogleFonts.poppins(
                                fontSize: 12, // date plus petite
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                entries.removeAt(index);
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}

// Page d'édition/création d'une entrée de journal
class JournalEditorPage extends StatefulWidget {
  final JournalEntry? entry;
  const JournalEditorPage({super.key, this.entry});

  @override
  State<JournalEditorPage> createState() => _JournalEditorPageState();
}

class _JournalEditorPageState extends State<JournalEditorPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  late DateTime _createdAt;

  @override
  void initState() {
    super.initState();
    if (widget.entry != null) {
      _titleController.text = widget.entry!.title;
      _contentController.text = widget.entry!.content;
      _createdAt = widget.entry!.createdAt;
    } else {
      _createdAt = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          widget.entry == null ? "Nouvelle Entrée" : "Modifier ",
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: () {
              // Supprime l'entrée si vide
              if (_titleController.text.isEmpty &&
                  _contentController.text.isEmpty) {
                Navigator.pop(context, null);
                return;
              }

              final JournalEntry newEntry = JournalEntry(
                title: _titleController.text,
                content: _contentController.text,
                createdAt: _createdAt,
              );
              Navigator.pop(context, newEntry);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Date : ${DateFormat('yyyy-MM-dd HH:mm').format(_createdAt)}",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: Colors.deepPurple[400],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: "Titre",
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  hintText: "Écrire votre entrée ici...",
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
                maxLines: null,
                expands: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

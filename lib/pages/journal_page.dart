import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: _isPasswordSet(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          bool isSet = snapshot.data!;
          return JournalLockPage(isFirstTime: !isSet);
        },
      ),
    );
  }

  Future<bool> _isPasswordSet() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("journal_password") != null;
  }
}

// Page de verrouillage / création de mot de passe
class JournalLockPage extends StatefulWidget {
  final bool isFirstTime;
  const JournalLockPage({Key? key, required this.isFirstTime})
    : super(key: key);

  @override
  State<JournalLockPage> createState() => _JournalLockPageState();
}

class _JournalLockPageState extends State<JournalLockPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  String? _savedPassword;

  @override
  void initState() {
    super.initState();
    if (!widget.isFirstTime) _loadPassword();
  }

  Future<void> _loadPassword() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedPassword = prefs.getString("journal_password");
    });
  }

  Future<void> _setPassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("journal_password", password);
    _unlockJournal();
  }

  void _unlockJournal() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const JournalPage()),
    );
  }

  void _checkPassword() {
    if (_passwordController.text == _savedPassword) {
      _unlockJournal();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Mot de passe incorrect")));
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isFirstTime = widget.isFirstTime;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isFirstTime
                    ? "Définissez un mot de passe pour votre journal"
                    : "Entrez le mot de passe pour accéder au journal",
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
              if (isFirstTime) ...[
                const SizedBox(height: 16),
                TextField(
                  controller: _confirmController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Confirmer le mot de passe",
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
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed:
                    isFirstTime
                        ? () {
                          if (_passwordController.text.isEmpty ||
                              _confirmController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Veuillez remplir les champs"),
                              ),
                            );
                            return;
                          }
                          if (_passwordController.text !=
                              _confirmController.text) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Les mots de passe ne correspondent pas",
                                ),
                              ),
                            );
                            return;
                          }
                          _setPassword(_passwordController.text);
                        }
                        : _checkPassword,
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

  Map<String, dynamic> toMap() => {
    "title": title,
    "content": content,
    "createdAt": createdAt.toIso8601String(),
  };

  factory JournalEntry.fromMap(Map<String, dynamic> map) => JournalEntry(
    title: map["title"],
    content: map["content"],
    createdAt: DateTime.parse(map["createdAt"]),
  );
}

// Page principale du journal
class JournalPage extends StatefulWidget {
  const JournalPage({Key? key}) : super(key: key);

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  List<JournalEntry> entries = [];

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString("journal_entries");
    if (data != null) {
      List<dynamic> decoded = jsonDecode(data);
      setState(() {
        entries = decoded.map((e) => JournalEntry.fromMap(e)).toList();
      });
    }
  }

  Future<void> _saveEntries() async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> jsonList =
        entries.map((e) => e.toMap()).toList();
    await prefs.setString("journal_entries", jsonEncode(jsonList));
  }

  void _openJournalEntry({JournalEntry? entry, int? index}) async {
    final JournalEntry? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => JournalEditorPage(entry: entry)),
    );

    if (result != null) {
      setState(() {
        if (index != null) {
          entries[index] = result;
        } else {
          entries.add(result);
        }
      });
      _saveEntries();
    }
  }

  void _deleteEntry(int index) {
    setState(() {
      entries.removeAt(index);
    });
    _saveEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Mon Journal Intime"),
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
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple[700],
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              DateFormat(
                                'yyyy-MM-dd HH:mm',
                              ).format(entry.createdAt),
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteEntry(index),
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

// Page d'édition du journal
class JournalEditorPage extends StatefulWidget {
  final JournalEntry? entry;
  const JournalEditorPage({Key? key, this.entry}) : super(key: key);

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

  void _save() {
    if (_titleController.text.isEmpty && _contentController.text.isEmpty) {
      Navigator.pop(context, null);
      return;
    }

    final JournalEntry newEntry = JournalEntry(
      title: _titleController.text,
      content: _contentController.text,
      createdAt: _createdAt,
    );
    Navigator.pop(context, newEntry);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(widget.entry == null ? "Nouvelle confession" : "Modifier"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: _save,
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
                  hintText: "Écrire votre confession...",
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

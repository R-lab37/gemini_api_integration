import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

void main() async {
  const apiKey = 'YOUR_API_KEY';
  final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

  runApp(MainApp(model: model));
}

class MainApp extends StatefulWidget {
  final GenerativeModel model;

  const MainApp({Key? key, required this.model}) : super(key: key);

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final TextEditingController _queryController = TextEditingController();
  String _response = '';
  bool _isLoading = false;

  Future<void> generateResponse() async {
    final query = _queryController.text;
    if (query.isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final content = [Content.text(query)];
    final response = await widget.model.generateContent(content);

    setState(() {
      _response = response.text!;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          filled: true,
          fillColor: Colors.grey[200], // Example color
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Gemini'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _queryController,
                decoration: InputDecoration(
                  hintText: 'Enter prompt here...',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => _queryController.clear(),
                  ),
                ),
                onSubmitted: (_) => generateResponse(),
              ),
              const SizedBox(height: 20.0),
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    _response,
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

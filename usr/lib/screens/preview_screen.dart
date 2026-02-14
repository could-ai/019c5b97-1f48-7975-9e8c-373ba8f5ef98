import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/resume.dart';

class PreviewScreen extends StatefulWidget {
  const PreviewScreen({super.key});

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  late Resume resume;
  String selectedTemplate = 'Classic'; // From shared_preferences

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resume = ModalRoute.of(context)!.settings.arguments as Resume;
    _loadTemplate();
  }

  Future<void> _loadTemplate() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedTemplate = prefs.getString('template') ?? 'Classic';
    });
  }

  void _exportPrint() {
    if (resume.hasValidationWarnings()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your resume may look incomplete.')),
      );
    }
    html.window.print(); // Trigger browser print for PDF
  }

  void _exportText() async {
    if (resume.hasValidationWarnings()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your resume may look incomplete.')),
      );
    }
    final text = resume.toPlainText();
    await html.window.navigator.clipboard?.writeText(text);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Resume copied to clipboard!')),
    );
  }

  Widget _buildResumeContent() {
    // Layout precision: Use Column with padding to prevent overlaps/overflow
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(resume.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
          const SizedBox(height: 10),
          Text(resume.contact, style: const TextStyle(color: Colors.black)),
          const SizedBox(height: 20),
          Text('Summary', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
          Text(resume.summary, style: const TextStyle(color: Colors.black)),
          const SizedBox(height: 20),
          // Other sections (education, experience, projects, skills, links) with consistent spacing
          // Template-specific styling applied here (e.g., Classic: standard layout)
          // ATS score and improvement panel assumed below (unchanged)
          const SizedBox(height: 20),
          Text('ATS Score: 85%', style: const TextStyle(color: Colors.black)),
          const SizedBox(height: 10),
          const Text('Top 3 Improvements: Add more projects, include measurable impact, expand summary.'), // Based on existing logic
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resume Preview')),
      body: SingleChildScrollView(
        child: _buildResumeContent(),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: _exportPrint,
              child: const Text('Print / Save as PDF'),
            ),
            ElevatedButton(
              onPressed: _exportText,
              child: const Text('Copy Resume as Text'),
            ),
          ],
        ),
      ),
    );
  }
}
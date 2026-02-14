import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:google_fonts/google_fonts.dart';
import 'screens/builder_screen.dart';
import 'screens/preview_screen.dart';

void main() {
  // Inject print CSS for export styling
  html.document.head?.append(html.StyleElement()
    ..text = '''
      @media print {
        body { background: white !important; margin: 0; padding: 20px; }
        .no-print { display: none !important; }
        .resume-content { page-break-inside: avoid; }
        .bullet { page-break-inside: avoid; }
      }
    ''');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Resume Builder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.interTextTheme(),
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const BuilderScreen(),
        '/preview': (context) => const PreviewScreen(),
      },
    );
  }
}
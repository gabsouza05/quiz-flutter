import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'quiz_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final TextEditingController _nomeController = TextEditingController();
  bool _visivel = false;
  double _posicaoY = 30.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _visivel = true;
          _posicaoY = 0;
        });
      }
    });
  }

  void _iniciarQuiz() async {
    String nome = _nomeController.text.trim();
    if (nome.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('nome_usuario', nome);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const QuizScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Ei, mostre sua carinha! Digite seu nome, irmão."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: AnimatedOpacity(
            opacity: _visivel ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 800),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 800),
              transform: Matrix4.translationValues(0, _posicaoY, 0),
              child: Column(
                children: [
                  const Text("🎸", style: TextStyle(fontSize: 80)),
                  const SizedBox(height: 12),
                  const Text(
                    "RAUL SEIXAS QUIZ",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFD700),
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "\"Eu prefiro ser essa metamorfose ambulante...\"",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFFAAAAAA),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    controller: _nomeController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Qual é o seu nome, maluco?",
                      labelStyle: const TextStyle(color: Color(0xFFFFD700)),
                      filled: true,
                      fillColor: const Color(0xFF2A2A3E),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFFFFD700)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Color(0xFFFFD700), width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _iniciarQuiz,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFD700),
                        foregroundColor: const Color(0xFF1A1A2E),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("VAMOS LÁ, IRMÃO!"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
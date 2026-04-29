import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'splash_screen.dart';

class ResultadoScreen extends StatefulWidget {
  final int acertos;
  final int total;

  const ResultadoScreen(
      {super.key, required this.acertos, required this.total});

  @override
  State<ResultadoScreen> createState() => _ResultadoScreenState();
}

class _ResultadoScreenState extends State<ResultadoScreen> {
  String _nome = "Maluco Beleza";

  @override
  void initState() {
    super.initState();
    _recuperarNome();
  }

  void _recuperarNome() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nome = prefs.getString('nome_usuario') ?? "Maluco Beleza";
    });
  }

  String _getMensagem() {
    final pct = widget.acertos / widget.total;
    if (pct == 1.0) {
      return "Perfeito! Você é o Raul reencarnado! 🌟";
    } else if (pct >= 0.7) {
      return "Socieda­de Alternativa te aprova! 🤘";
    } else if (pct >= 0.4) {
      return "Tá aprendendo, mostre sua carinha! 🎸";
    } else {
      return "Vai ouvir mais Raul e volta, irmão! 🎵";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D1A),
        title: const Text(
          "Resultado",
          style: TextStyle(
            color: Color(0xFFFFD700),
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("🎸", style: TextStyle(fontSize: 72)),
              const SizedBox(height: 20),
              Text(
                "Parabéns, $_nome!",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFD700),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A3E),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFFD700), width: 1.5),
                ),
                child: Text(
                  "${widget.acertos} / ${widget.total}",
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _getMensagem(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFFAAAAAA),
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SplashScreen()),
                      (route) => false,
                    );
                  },
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
                  child: const Text("TENTAR DE NOVO"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
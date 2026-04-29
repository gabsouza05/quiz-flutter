import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'resultado_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List _perguntas = [];
  int _perguntaAtual = 0;
  int _pontuacao = 0;
  int? _respostaSelecionada;
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarPerguntas();
  }

  Future<void> _carregarPerguntas() async {
    try {
      final String response =
          await rootBundle.loadString('assets/mockup/perguntas.json');
      final data = await json.decode(response);
      setState(() {
        _perguntas = data;
        _carregando = false;
      });
    } catch (e) {
      debugPrint("Erro ao carregar JSON: $e");
    }
  }

  void _responder() {
    if (_respostaSelecionada == (_perguntas[_perguntaAtual]['correta'] - 1)) {
      _pontuacao++;
    }
    if (_perguntaAtual < _perguntas.length - 1) {
      setState(() {
        _perguntaAtual++;
        _respostaSelecionada = null;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ResultadoScreen(acertos: _pontuacao, total: _perguntas.length),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Scaffold(
        backgroundColor: Color(0xFF1A1A2E),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFFFD700)),
        ),
      );
    }

    final perguntaData = _perguntas[_perguntaAtual];
    final List opcoes = perguntaData['respostas'] ?? [];
    final String caminhoImagem = perguntaData['ilustracao'] ?? "";

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D1A),
        title: const Text(
          "🎸 Raul Seixas Quiz",
          style: TextStyle(
            color: Color(0xFFFFD700),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Barra de progresso
            LinearProgressIndicator(
              value: (_perguntaAtual + 1) / _perguntas.length,
              backgroundColor: const Color(0xFF2A2A3E),
              color: const Color(0xFFFFD700),
              minHeight: 6,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            Text(
              "Questão ${_perguntaAtual + 1} de ${_perguntas.length}",
              style: const TextStyle(
                color: Color(0xFFAAAAAA),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                caminhoImagem,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(
                  height: 180,
                  color: const Color(0xFF2A2A3E),
                  child: const Icon(Icons.music_note,
                      size: 60, color: Color(0xFFFFD700)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              perguntaData['pergunta'] ?? "",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: opcoes.length,
                itemBuilder: (context, index) {
                  final selecionado = _respostaSelecionada == index;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: GestureDetector(
                      onTap: () =>
                          setState(() => _respostaSelecionada = index),
                      child: Container(
                        decoration: BoxDecoration(
                          color: selecionado
                              ? const Color(0xFFFFD700).withValues(alpha: 0.15)
                              : const Color(0xFF2A2A3E),
                          border: Border.all(
                            color: selecionado
                                ? const Color(0xFFFFD700)
                                : Colors.transparent,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        child: Row(
                          children: [
                            Icon(
                              selecionado
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_unchecked,
                              color: selecionado
                                  ? const Color(0xFFFFD700)
                                  : const Color(0xFF888888),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                opcoes[index].toString(),
                                style: TextStyle(
                                  color: selecionado
                                      ? const Color(0xFFFFD700)
                                      : Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _respostaSelecionada == null ? null : _responder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD700),
                  foregroundColor: const Color(0xFF1A1A2E),
                  disabledBackgroundColor: const Color(0xFF3A3A4E),
                  disabledForegroundColor: const Color(0xFF666666),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 1.2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("PRÓXIMA ➜"),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
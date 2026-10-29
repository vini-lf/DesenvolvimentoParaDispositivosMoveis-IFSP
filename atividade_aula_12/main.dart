import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MathMultiplicationApp());

class MathMultiplicationApp extends StatelessWidget {
  const MathMultiplicationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MultiplicationScreen(),
    );
  }
}

class MultiplicationScreen extends StatefulWidget {
  const MultiplicationScreen({super.key});

  @override
  State<MultiplicationScreen> createState() => _MultiplicationScreenState();
}

class _MultiplicationScreenState extends State<MultiplicationScreen> {
  final TextEditingController _controller = TextEditingController();
  int currentFactor = 2;
  int currentMultiplier = 1;
  final int maxMultiplier = 10;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentFactor = prefs.getInt('currentFactor') ?? 2;
      currentMultiplier = prefs.getInt('currentMultiplier') ?? 1;
    });
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentFactor', currentFactor);
    await prefs.setInt('currentMultiplier', currentMultiplier);
  }

  void _onNumberPressed(String number) {
    setState(() {
      _controller.text += number;
    });
  }

  void _onClear() {
    setState(() {
      _controller.clear();
    });
  }

  void _checkAnswer() {
    if (_controller.text.isEmpty) return;

    int? userAnswer = int.tryParse(_controller.text);
    int correctAnswer = currentFactor * currentMultiplier;

    if (userAnswer == correctAnswer) {
      setState(() {
        if (currentMultiplier >= maxMultiplier) {
          currentFactor++;
          currentMultiplier = 1;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Parabéns! Avançando para o fator $currentFactor.'),
              duration: const Duration(seconds: 2),
            ),
          );
        } else {
          currentMultiplier++;
        }
        _controller.clear();
        _saveProgress();
      });
    } else {
      int previousFactor = currentFactor;

      setState(() {
        currentFactor++;
        currentMultiplier = 1;
        _controller.clear();
        _saveProgress();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Errou!'),
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Clique aqui para continuar',
            onPressed: () {
              setState(() {
                currentFactor = previousFactor;
                currentMultiplier = 1;
                _saveProgress();
              });
            },
          ),
        ),
      );
    }
  }

  Widget _buildKeypadButton(String label, VoidCallback onPressed,
      {Color? color}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onPressed,
      child: Text(label,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
    );
  }

  @override
  Widget build(BuildContext context) {
    double progress = (currentMultiplier - 1) / maxMultiplier;

    return Scaffold(
      appBar: AppBar(title: const Text('Desafio de Multiplicação')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Colors.grey[300],
                color: Colors.blue,
              ),
              const SizedBox(height: 10),
              Text(
                'Progresso: ${(progress * 100).toInt()}%',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              Text(
                'Quanto é $currentFactor x $currentMultiplier?',
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _controller,
                readOnly: true,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Sua resposta',
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 2,
                  children: [
                    _buildKeypadButton('1', () => _onNumberPressed('1')),
                    _buildKeypadButton('2', () => _onNumberPressed('2')),
                    _buildKeypadButton('3', () => _onNumberPressed('3')),
                    _buildKeypadButton('4', () => _onNumberPressed('4')),
                    _buildKeypadButton('5', () => _onNumberPressed('5')),
                    _buildKeypadButton('6', () => _onNumberPressed('6')),
                    _buildKeypadButton('7', () => _onNumberPressed('7')),
                    _buildKeypadButton('8', () => _onNumberPressed('8')),
                    _buildKeypadButton('9', () => _onNumberPressed('9')),
                    _buildKeypadButton('C', _onClear, color: Colors.red[300]),
                    _buildKeypadButton('0', () => _onNumberPressed('0')),
                    _buildKeypadButton('OK', _checkAnswer,
                        color: Colors.green[300]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

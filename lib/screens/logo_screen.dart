import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

class LogoScreen extends StatefulWidget {
  final String category;
  final int logoIndex;
  final List<dynamic> logos;
  final Function(int) onAnswered;
  const LogoScreen({super.key, required this.category, required this.logoIndex, required this.logos, required this.onAnswered});

  @override
  _LogoScreenState createState() => _LogoScreenState();
}

class _LogoScreenState extends State<LogoScreen> with TickerProviderStateMixin {
  late String logoImage;
  late List<String> correctAnswers;
  final TextEditingController _controller = TextEditingController();
  late AnimationController _animationController;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isCorrect = false;

  @override
  void initState() {
    super.initState();
    logoImage = widget.logos[widget.logoIndex]['image'];
    correctAnswers = List<String>.from(widget.logos[widget.logoIndex]['answer']);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  void _checkAnswer() {
    String userAnswer = _controller.text.trim().toLowerCase();
    bool isCorrect = correctAnswers.any((answer) => answer.toLowerCase() == userAnswer);

    if (isCorrect) {
      _audioPlayer.play(AssetSource('/assets/correct.mp3'));
      setState(() {
        _isCorrect = true;
      });

      widget.onAnswered(widget.logoIndex);

      Future.delayed(const Duration(seconds: 1), () {
        _goToNextLogo();
      });
    } else {
      _audioPlayer.play(AssetSource('/assets/wrong.mp3'));
      _animationController.forward(from: 0.0); 

      setState(() {
        _isCorrect = false;
      });
    }
  }


  void _goToNextLogo() {
    if (widget.logoIndex < widget.logos.length - 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LogoScreen(
            category: widget.category,
            logoIndex: widget.logoIndex + 1,
            logos: widget.logos,
            onAnswered: widget.onAnswered,
          ),
        ),
      );
    } else {
      Navigator.pop(context); // Return to CategoryScreen when finished
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Guess the Logo")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Guess the Logo",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    10 * (1 - (_animationController.value * 2)), // Smooth shake effect
                    0,
                  ),
                  child: child,
                );
              },
              child: Image.network(
                logoImage,
                width: 200,
                height: 200,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child; // Fully loaded
                  return Center(child: CircularProgressIndicator()); // Show loader
                },
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.error, size: 50, color: Colors.red); // Show error icon if loading fails
                },
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter the logo name",
                ),
              ),
            ),
            const SizedBox(height: 20),
            ScaleTransition(
              scale: _animationController.drive(Tween(begin: 1.0, end: 1.1).chain(CurveTween(curve: Curves.elasticIn))),
              child: ElevatedButton(
                onPressed: _checkAnswer,
                child: const Text("Submit"),
              ),
            ),
            if (_isCorrect)
              const Icon(Icons.check_circle, color: Colors.green, size: 50),
          ],
        ),
      ),
    );
  }
}

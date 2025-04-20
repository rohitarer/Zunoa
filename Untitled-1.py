import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() => runApp(const TinyDragonJumper());

class TinyDragonJumper extends StatelessWidget {
  const TinyDragonJumper({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  double dragonY = 1;
  double initialPos = 1;
  double time = 0;
  double height = 0;
  bool gameHasStarted = false;

  double gravity = -4.9;
  double velocity = 3.5;

  List<double> obstacleX = [2, 3.5];
  double obstacleWidth = 0.2;

  Random random = Random();

  int score = 0;
  int highScore = 0;
  int attempts = 0;

  void startGame() {
    gameHasStarted = true;
    time = 0;
    initialPos = dragonY;

    Timer.periodic(const Duration(milliseconds: 30), (timer) {
      time += 0.03;
      height = gravity * time * time + velocity * time;

      setState(() {
        dragonY = initialPos - height;

        // Prevent going too high
        if (dragonY < -1) dragonY = -1;

        // Move obstacles
        for (int i = 0; i < obstacleX.length; i++) {
          obstacleX[i] -= 0.03;
          if (obstacleX[i] < -1.5) {
            obstacleX[i] += 3.0 + random.nextDouble(); // random spacing
            score++;
            if (score > highScore) highScore = score;
          }
        }

        // Check for collision
        for (double x in obstacleX) {
          if ((x < -0.3 && x > -0.7) && (dragonY > 0.75)) {
            timer.cancel();
            _showGameOver();
            resetGame();
          }
        }

        // Hit the ground
        if (dragonY > 1.1) {
          timer.cancel();
          _showGameOver();
          resetGame();
        }
      });
    });
  }

  void jump() {
    if (!gameHasStarted) return;
    setState(() {
      time = 0;
      initialPos = dragonY;
    });
  }

  void resetGame() {
    setState(() {
      dragonY = 1;
      obstacleX = [2, 3.5];
      gameHasStarted = false;
      score = 0;
      attempts++;
    });
  }

  void _showGameOver() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("😵 Game Over"),
        content: const Text("The dragon hit something!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }

  Widget _scoreCard(String title, int value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Text(
            "$value",
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => gameHasStarted ? jump() : startGame(),
      child: Scaffold(
        body: Stack(
          children: [
            // Background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF89f7fe), Color(0xFF66a6ff)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            // Scoreboard Panel
            Positioned(
              top: 50,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _scoreCard("Score", score, Icons.star, Colors.amber),
                  _scoreCard("High", highScore, Icons.emoji_events, Colors.orangeAccent),
                  _scoreCard("Tries", attempts, Icons.refresh, Colors.redAccent),
                ],
              ),
            ),

            // Dragon
            AnimatedContainer(
              alignment: Alignment(-0.8, dragonY),
              duration: const Duration(milliseconds: 0),
              child: const Text("🐉", style: TextStyle(fontSize: 60)),
            ),

            // Obstacles
            for (double x in obstacleX)
              AnimatedContainer(
                alignment: Alignment(x, 1),
                duration: const Duration(milliseconds: 0),
                child: const Text("🔺", style: TextStyle(fontSize: 45)),
              ),

            // TAP TO START
            if (!gameHasStarted)
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "🕹️ TAP TO START",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// 🎮 Pop the Stress Bubbles Game - Flutter + Flame
// Game file: pop_stress_bubbles_game.dart

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class PopStressBubblesGame extends FlameGame
    with TapDetector, HasCollisionDetection {
  final List<String> stressWords = [
    'anxiety', 'overthinking', 'fear', 'doubt', 'anger', 'regret', 'guilt'
  ];

  final Random _random = Random();
  late TimerComponent gameTimer;
  int score = 0;
  bool isGameOver = false;

  @override
  Future<void> onLoad() async {
    await Flame.images.loadAll(['bubble.png']);
    FlameAudio.bgm.initialize();
    FlameAudio.loop('calm_music.mp3');

    gameTimer = TimerComponent(
      period: 60,
      removeOnFinish: true,
      onTick: () {
        isGameOver = true;
        overlays.add('GameOver');
      },
    );

    add(gameTimer);
    add(BubbleSpawner());
  }

  void increaseScore() {
    score++;
  }
}

class BubbleSpawner extends Component with HasGameRef<PopStressBubblesGame> {
  final Random _random = Random();

  @override
  Future<void> onLoad() async {
    add(TimerComponent(
      period: 1,
      repeat: true,
      autoStart: true,
      onTick: () {
        final x = _random.nextDouble() * gameRef.size.x;
        final word = gameRef.stressWords[_random.nextInt(gameRef.stressWords.length)];
        gameRef.add(StressBubble(position: Vector2(x, gameRef.size.y), word: word));
      },
    ));
  }
}

class StressBubble extends SpriteComponent
    with CollisionCallbacks, TapCallbacks, HasGameRef<PopStressBubblesGame> {
  final String word;
  late TextComponent label;

  StressBubble({required Vector2 position, required this.word}) {
    this.position = position;
    size = Vector2.all(70);
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('bubble.png');
    label = TextComponent(
      text: word,
      position: Vector2(size.x / 2, size.y / 2),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
      ),
    );
    add(label);
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y -= 50 * dt;
    if (position.y < -50) removeFromParent();
  }

  @override
  void onTapDown(TapDownEvent event) {
    FlameAudio.play('pop.mp3');
    gameRef.increaseScore();
    removeFromParent();
  }
}

// Widget integration with Flutter
class PopStressGamePage extends StatelessWidget {
  const PopStressGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GameWidget(
            game: PopStressBubblesGame(),
            overlayBuilderMap: {
              'GameOver': (ctx, game) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('🎉 Pixie Released!',
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                    Text('You popped \${(game as PopStressBubblesGame).score} bubbles!'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Back to Games'),
                    ),
                  ],
                ),
              )
            },
          ),
          Positioned(
            top: 50,
            left: 20,
            child: Text(
              '🫧 Pixie Release 🫧',
              style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}

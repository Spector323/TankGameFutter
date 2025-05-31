import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'game_bloc.dart';
import 'game_state.dart';
import 'tank_painter.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        onKeyEvent: (KeyEvent event) {
          final bloc = context.read<GameBloc>();
          String? key;
          String playerId = 'player1';
          bool isPressed = event is KeyDownEvent;

          if (event.logicalKey == LogicalKeyboardKey.keyW) {
            key = '${playerId}_up';
          } else if (event.logicalKey == LogicalKeyboardKey.keyS) {
            key = '${playerId}_down';
          } else if (event.logicalKey == LogicalKeyboardKey.keyA) {
            key = '${playerId}_left';
          } else if (event.logicalKey == LogicalKeyboardKey.keyD) {
            key = '${playerId}_right';
          } else if (event.logicalKey == LogicalKeyboardKey.space) {
            key = '${playerId}_shoot';
          } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
            key = 'player2_up';
            playerId = 'player2';
          } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
            key = 'player2_down';
            playerId = 'player2';
          } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
            key = 'player2_left';
            playerId = 'player2';
          } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
            key = 'player2_right';
            playerId = 'player2';
          } else if (event.logicalKey == LogicalKeyboardKey.enter) {
            key = 'player2_shoot';
            playerId = 'player2';
          }

          if (key != null) {
            bloc.add(KeyPressed(key, isPressed));
          }
        },
        child: BlocBuilder<GameBloc, GameState>(
          builder: (context, state) {
            return Stack(
              children: [
                for (var tank in state.tanks)
                  Positioned(
                    left: tank.x,
                    top: tank.y,
                    child: CustomPaint(
                      size: const Size(40, 40),
                      painter: TankPainter(
                        bodyAngle: tank.angle,
                        turretAngle: tank.angle,
                        color: tank.id == 'player1' ? Colors.blue : Colors.red,
                      ),
                    ),
                  ),
                for (var bullet in state.bullets)
                  Positioned(
                    left: bullet.x,
                    top: bullet.y,
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                if (state.isGameOver)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Game Over! Winner: ${state.winner}'),
                        ElevatedButton(
                          onPressed: () {
                            context.read<GameBloc>().add(StartGame(state.mode));
                          },
                          child: const Text('Restart'),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
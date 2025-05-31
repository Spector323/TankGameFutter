import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'game_bloc.dart';
import 'game_screen.dart';
import 'data/game_repository_impl.dart';
import 'game_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameBloc(GameRepositoryImpl()),
      child: MaterialApp(
        home: const ModeSelectionScreen(),
      ),
    );
  }
}

class ModeSelectionScreen extends StatelessWidget {
  const ModeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                context.read<GameBloc>().add(const StartGame(GameMode.twoPlayers));
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GameScreen()),
                );
              },
              child: const Text('Two Players'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<GameBloc>().add(const StartGame(GameMode.vsComputer));
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GameScreen()),
                );
              },
              child: const Text('Vs Computer'),
            ),
          ],
        ),
      ),
    );
  }
}
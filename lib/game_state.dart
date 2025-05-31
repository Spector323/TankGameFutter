import 'domain/entities/tank.dart';
import 'domain/entities/bullet.dart';

enum GameMode { twoPlayers, vsComputer }

class GameState {
  final List<Tank> tanks;
  final List<Bullet> bullets;
  final GameMode mode;
  final bool isGameOver;
  final String? winner;

  GameState({
    required this.tanks,
    required this.bullets,
    required this.mode,
    this.isGameOver = false,
    this.winner,
  });

  GameState copyWith({
    List<Tank>? tanks,
    List<Bullet>? bullets,
    GameMode? mode,
    bool? isGameOver,
    String? winner,
  }) {
    return GameState(
      tanks: tanks ?? this.tanks,
      bullets: bullets ?? this.bullets,
      mode: mode ?? this.mode,
      isGameOver: isGameOver ?? this.isGameOver,
      winner: winner ?? this.winner,
    );
  }
}
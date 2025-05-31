import 'dart:async';
import 'dart:math';
import 'package:uuid/uuid.dart';
import '../domain/entities/tank.dart';
import '../domain/entities/bullet.dart';
import '../game_state.dart';
import '../domain/repositories/game_repository.dart';

class GameRepositoryImpl implements GameRepository {
  Timer? _aiShootTimer;

  @override
  GameState getInitialState(GameMode mode) {
    _aiShootTimer?.cancel();
    return GameState(
      tanks: [
        Tank(id: 'player1', x: 100, y: 100),
        Tank(id: mode == GameMode.twoPlayers ? 'player2' : 'computer', x: 700, y: 500),
      ],
      bullets: [],
      mode: mode,
    );
  }

  @override
  GameState updateState(GameState state, Duration deltaTime) {
    final newTanks = List<Tank>.from(state.tanks);
    final newBullets = List<Bullet>.from(state.bullets);
    final double dt = deltaTime.inMilliseconds / 1000.0;

    for (var bullet in newBullets) {
      bullet.x += cos(bullet.angle) * bullet.speed * dt * 100;
      bullet.y += sin(bullet.angle) * bullet.speed * dt * 100;

      for (var tank in newTanks) {
        if (tank.id != bullet.ownerId && _isCollision(tank, bullet)) {
          tank.health -= 10;
          newBullets.remove(bullet);
          break;
        }
      }
    }

    newBullets.removeWhere((bullet) => bullet.x < 0 || bullet.x > 800 || bullet.y < 0 || bullet.y > 600);

    if (state.mode == GameMode.vsComputer) {
      final computer = newTanks.firstWhere((tank) => tank.id == 'computer');
      final player = newTanks.firstWhere((tank) => tank.id == 'player1');
      final dx = player.x - computer.x;
      final dy = player.y - computer.y;
      computer.angle = atan2(dy, dx);
      computer.x += cos(computer.angle) * computer.speed * dt * 100;
      computer.y += sin(computer.angle) * computer.speed * dt * 100;

      if (Random().nextDouble() < 0.02 && _aiShootTimer == null) {
        _aiShootTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
          final newState = state.copyWith();
          final comp = newState.tanks.firstWhere((tank) => tank.id == 'computer');
          for (int i = 0; i < 3; i++) {
            newBullets.add(Bullet(
              id: const Uuid().v4(),
              x: comp.x + cos(comp.angle) * 20,
              y: comp.y + sin(comp.angle) * 20,
              angle: comp.angle + (Random().nextDouble() - 0.5) * 0.2,
              ownerId: comp.id,
            ));
          }
        });
        Timer(const Duration(milliseconds: 300), () {
          _aiShootTimer?.cancel();
          _aiShootTimer = null;
        });
      }
    }

    String? winner;
    bool isGameOver = false;
    if (newTanks.any((tank) => tank.health <= 0)) {
      isGameOver = true;
      winner = newTanks.firstWhere((tank) => tank.health > 0).id;
    }

    return GameState(
      tanks: newTanks,
      bullets: newBullets,
      mode: state.mode,
      isGameOver: isGameOver,
      winner: winner,
    );
  }

  @override
  void handleInput(String playerId, String input) {}

  bool _isCollision(Tank tank, Bullet bullet) {
    final distance = sqrt(pow(tank.x - bullet.x, 2) + pow(tank.y - bullet.y, 2));
    return distance < 20;
  }
}
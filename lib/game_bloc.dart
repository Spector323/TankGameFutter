import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import 'dart:math';
import 'domain/entities/bullet.dart';
import 'domain/entities/tank.dart';
import 'game_state.dart';
import 'domain/repositories/game_repository.dart';

part 'game_event.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final GameRepository gameRepository;
  Timer? _gameLoop;
  final Map<String, bool> _keyStates = {};
  final Map<String, Timer?> _shootTimers = {};

  GameBloc(this.gameRepository) : super(gameRepository.getInitialState(GameMode.twoPlayers)) {
    on<StartGame>((event, emit) {
      _gameLoop?.cancel();
      _keyStates.clear();
      _shootTimers.clear();
      emit(gameRepository.getInitialState(event.mode));
      _gameLoop = Timer.periodic(const Duration(milliseconds: 10), (timer) {
        add(const UpdateGame());
      });
    });

    on<UpdateGame>((event, emit) {
      final newState = gameRepository.updateState(state, const Duration(milliseconds: 10));
      final newTanks = List<Tank>.from(newState.tanks);

      for (var tank in newTanks) {
        if (_keyStates['${tank.id}_up'] == true) {
          tank.x += cos(tank.angle) * tank.speed;
          tank.y += sin(tank.angle) * tank.speed;
        }
        if (_keyStates['${tank.id}_down'] == true) {
          tank.x -= cos(tank.angle) * tank.speed;
          tank.y -= sin(tank.angle) * tank.speed;
        }
        if (_keyStates['${tank.id}_left'] == true) {
          tank.angle -= tank.rotationSpeed;
        }
        if (_keyStates['${tank.id}_right'] == true) {
          tank.angle += tank.rotationSpeed;
        }
      }

      emit(newState.copyWith(tanks: newTanks));
    });

    on<KeyPressed>((event, emit) {
      _keyStates[event.key] = event.isPressed;
      if (event.key.endsWith('_shoot') && event.isPressed) {
        final playerId = event.key.split('_')[0];
        if (_shootTimers[playerId] == null) {
          _shootTimers[playerId] = Timer.periodic(const Duration(milliseconds: 100), (timer) {
            final newState = state.copyWith();
            final tank = newState.tanks.firstWhere((t) => t.id == playerId);
            for (int i = 0; i < 3; i++) {
              newState.bullets.add(Bullet(
                id: const Uuid().v4(),
                x: tank.x + cos(tank.angle) * 20,
                y: tank.y + sin(tank.angle) * 20,
                angle: tank.angle + (Random().nextDouble() - 0.5) * 0.2,
                ownerId: tank.id,
              ));
            }
            emit(newState);
          });
        }
      } else if (event.key.endsWith('_shoot') && !event.isPressed) {
        final playerId = event.key.split('_')[0];
        _shootTimers[playerId]?.cancel();
        _shootTimers[playerId] = null;
      }
    });
  }

  @override
  Future<void> close() {
    _gameLoop?.cancel();
    for (var timer in _shootTimers.values) {
      timer?.cancel();
    }
    return super.close();
  }
}
part of 'game_bloc.dart';

abstract class GameEvent {
  const GameEvent();
}

class StartGame extends GameEvent {
  final GameMode mode;
  const StartGame(this.mode);
}

class UpdateGame extends GameEvent {
  const UpdateGame();
}

class KeyPressed extends GameEvent {
  final String key;
  final bool isPressed;
  const KeyPressed(this.key, this.isPressed);
}
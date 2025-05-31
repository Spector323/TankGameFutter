import '../../game_state.dart';

abstract class GameRepository {
  GameState getInitialState(GameMode mode);
  GameState updateState(GameState state, Duration deltaTime);
  void handleInput(String playerId, String input);
}
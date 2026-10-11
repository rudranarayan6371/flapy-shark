import 'package:flame_audio/flame_audio.dart';
import 'package:flappy_flame/workshop/game_settings.dart';

/// 🔊 AUDIO SERVICE
/// Manages all game sounds and music
class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  bool _initialized = false;
  bool _soundEnabled = true;

  /// Initialize audio system and preload sounds
  Future<void> initialize() async {
    if (_initialized) return;
    
    try {
      _soundEnabled = WorkshopSettings.soundEnabled;
      
      // Ensure FlameAudio loads directly from Flutter assets matching pubspec.yaml
      FlameAudio.audioCache.prefix = '';

      if (_soundEnabled) {
        // Preload all sound effects
        await FlameAudio.audioCache.loadAll([
          'workshop/sounds/${WorkshopSettings.jumpSound}',
          'workshop/sounds/${WorkshopSettings.scoreSound}',
          'workshop/sounds/${WorkshopSettings.hitSound}',
          'workshop/sounds/${WorkshopSettings.swooshSound}',
        ]);
      }
      
      _initialized = true;
    } catch (e) {
      // Sound files or WebAudio format fallback - handle gracefully
      _soundEnabled = false;
    }
  }

  /// Play jump sound when bird flaps
  void playJump() {
    if (!_soundEnabled || !WorkshopSettings.soundEnabled) return;
    
    try {
      FlameAudio.play(
        'workshop/sounds/${WorkshopSettings.jumpSound}',
        volume: WorkshopSettings.jumpVolume,
      );
    } catch (e) {
      // Sound file not available
    }
  }

  /// Play score sound when passing a pipe
  void playScore() {
    if (!_soundEnabled || !WorkshopSettings.soundEnabled) return;
    
    try {
      FlameAudio.play(
        'workshop/sounds/${WorkshopSettings.scoreSound}',
        volume: WorkshopSettings.scoreVolume,
      );
    } catch (e) {
      // Sound file not available
    }
  }

  /// Play hit sound on collision
  void playHit() {
    if (!_soundEnabled || !WorkshopSettings.soundEnabled) return;
    
    try {
      FlameAudio.play(
        'workshop/sounds/${WorkshopSettings.hitSound}',
        volume: WorkshopSettings.hitVolume,
      );
    } catch (e) {
      // Sound file not available
    }
  }

  /// Play swoosh sound (for menu transitions, etc.)
  void playSwoosh() {
    if (!_soundEnabled || !WorkshopSettings.soundEnabled) return;
    
    try {
      FlameAudio.play(
        'workshop/sounds/${WorkshopSettings.swooshSound}',
        volume: WorkshopSettings.swooshVolume,
      );
    } catch (e) {
      // Sound file not available
    }
  }

  /// Toggle sound on/off
  void toggleSound() {
    _soundEnabled = !_soundEnabled;
  }

  /// Check if sound is enabled
  bool get isSoundEnabled => _soundEnabled && WorkshopSettings.soundEnabled;

  /// Dispose audio resources
  void dispose() {
    FlameAudio.audioCache.clearAll();
    _initialized = false;
  }
}
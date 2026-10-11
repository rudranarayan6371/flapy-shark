import 'package:flutter/material.dart';
import 'package:flappy_flame/workshop/student_code.dart';

/// ════════════════════════════════════════════════════════════════
/// 🎮 GAME SETTINGS
/// ════════════════════════════════════════════════════════════════

class WorkshopSettings {
  
  // ═══════════════════════════════════════════════════════════════
  // 🎯 CHOOSE MODE
  // ═══════════════════════════════════════════════════════════════
  
  /// Set to TRUE: Use code from student_code.dart
  /// Set to FALSE: Use settings from this file
  static const bool useStudentCode = false;
  
  
  // ═══════════════════════════════════════════════════════════════
  // 🦈 SHARK / BIRD SETTINGS
  // ═══════════════════════════════════════════════════════════════
  
  static const Color _birdColorFallback = Color(0xFF5A738E); // Ocean shark slate blue
  static Color get birdColor => 
      useStudentCode ? StudentCode.getBirdColor() : _birdColorFallback;
  
  static const double birdSize = 42;
  static const double birdStartX = 100;
  static const Color birdEyeColor = Colors.white;
  static const Color birdPupilColor = Colors.black;
  static const Color birdBeakColor = Color(0xFFFF8C00);
  static Color get birdWingColor => const Color(0xFF455A64); // Shark fin slate
  static const Color birdBellyColor = Color(0xFFE2E8F0); // Counter-shaded pale belly
  
  
  // ═══════════════════════════════════════════════════════════════
  // ⚙️ PHYSICS SETTINGS
  // ═══════════════════════════════════════════════════════════════
  
  static const double _gravityFallback = 880;
  static double get gravity =>
      useStudentCode ? StudentCode.getGravity() : _gravityFallback;
  
  static const double _jumpStrengthFallback = -325;
  static double get jumpStrength =>
      useStudentCode ? StudentCode.calculateJumpStrength(gravity) : _jumpStrengthFallback;
  
  
  // ═══════════════════════════════════════════════════════════════
  // 🚧 ANCIENT BRICK PIPE SETTINGS
  // ═══════════════════════════════════════════════════════════════
  
  static const double pipeWidth = 80;
  
  static const double _gapHeightFallback = 215;
  static double get gapHeight =>
      useStudentCode ? StudentCode.getGapSize() : _gapHeightFallback;
  
  static const double _pipeSpeedFallback = 160;
  static double get pipeSpeed =>
      useStudentCode ? StudentCode.getPipeSpeed() : _pipeSpeedFallback;
  
  static const double pipeSpawnInterval = 2.0;
  static const double minGapDistance = 150;
  
  static const Color _pipeColorFallback = Color(0xFF8D5B4C); // Ancient weathered brick
  static Color get pipeColor =>
      useStudentCode ? StudentCode.getPipeColor() : _pipeColorFallback;
  
  static Color get pipeBorderColor => const Color(0xFF4E3629); // Aged mortar border
  static Color get pipeHighlightColor => const Color(0xFFA66F5E); // Weathered brick highlight
  static Color get pipeShadowColor => const Color(0xFF3E2723); // Deep masonry shadow
  
  
  // ═══════════════════════════════════════════════════════════════
  // 🌊 WATER / BACKGROUND (EXCEPT CLOUDS)
  // ═══════════════════════════════════════════════════════════════
  
  static const Color _skyColorTopFallback = Color(0xFF006994); // Ocean water surface blue
  static const Color _skyColorBottomFallback = Color(0xFF001F3F); // Deep ocean water abyss
  
  static Color get skyColorTop =>
      useStudentCode ? StudentCode.getSkyTopColor() : _skyColorTopFallback;
  static Color get skyColorBottom =>
      useStudentCode ? StudentCode.getSkyBottomColor() : _skyColorBottomFallback;
  
  static const Color cloudColor = Colors.white; // Preserved white clouds
  static const double cloudOpacity = 0.6;
  
  
  // ═══════════════════════════════════════════════════════════════
  // 🌍 SEABED / GROUND
  // ═══════════════════════════════════════════════════════════════
  
  static const double groundHeight = 100;
  static const Color groundColor = Color(0xFFC2B280); // Ocean floor sand
  static const Color grassColor = Color(0xFF2E8B57); // Sea kelp / seaweed
  static const Color groundLineColor = Color(0xFF8F7B55); // Sand ripple lines
  
  
  // ═══════════════════════════════════════════════════════════════
  // 🏆 SCORING
  // ═══════════════════════════════════════════════════════════════
  
  static int getPoints(int currentScore) =>
      useStudentCode ? StudentCode.calculatePoints(currentScore) : 1;
  
  static String get creatorName =>
      useStudentCode ? StudentCode.getCreatorName() : "Shark Navigator";
  
  
  // ═══════════════════════════════════════════════════════════════
  // ✨ VISUAL EFFECTS
  // ═══════════════════════════════════════════════════════════════
  
  static const bool enableBirdRotation = true;
  static const double maxRotationUp = -0.4;
  static const double maxRotationDown = 0.7;
  static const bool enableBirdTrail = false;
  static const Color trailColor = Color(0xFF80DEEA);
  static const double trailOpacity = 0.3;
  
  
  // ═══════════════════════════════════════════════════════════════
  // 🔊 SOUND
  // ═══════════════════════════════════════════════════════════════
  
  static const bool soundEnabled = true;
  static const String jumpSound = 'jump.wav';
  static const String scoreSound = 'score.wav';
  static const String hitSound = 'hit.wav';
  static const String swooshSound = 'swoosh.wav';
  static const double jumpVolume = 0.5;
  static const double scoreVolume = 0.7;
  static const double hitVolume = 0.8;
  static const double swooshVolume = 0.4;
  static const double masterVolume = 1.0;
  
  
  // ═══════════════════════════════════════════════════════════════
  // 🖼️ CUSTOM DESIGNS
  // ═══════════════════════════════════════════════════════════════
  
  static const bool useCustomBirdImage = false;
  static const bool useCustomPipeImage = false;
  static const String birdImageFile = 'bird.png';
  static const String pipeImageFile = 'pipe.png';
  static const String birdDesign = 'shark';
  static const String birdEmoji = '🦈';
  static const String pipeDesign = 'ancient_brick';
  static const Color pipeGradientStart = Color(0xFF8D5B4C);
  static const Color pipeGradientEnd = Color(0xFF5D3A2E);
  static const Color candyStripe1 = Color(0xFFFF69B4);
  static const Color candyStripe2 = Colors.white;
}
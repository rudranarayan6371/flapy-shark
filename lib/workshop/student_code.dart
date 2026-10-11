import 'package:flutter/material.dart';
import 'dart:math';

/// ════════════════════════════════════════════════════════════════
/// 🎓 STUDENT CODE & LOGIC MODULE
/// ════════════════════════════════════════════════════════════════
/// 
/// This module implements silky-smooth flight dynamics and a creative
/// twilight-sunset visual aesthetic using dependency injection.
/// 
/// ════════════════════════════════════════════════════════════════

/// Contract for student game logic & configuration.
abstract class IStudentLogic {
  Color getBirdColor();
  double getGravity();
  double getGapSize();
  double getPipeSpeed();
  double calculateJumpStrength(double gravity);
  Color getPipeColor();
  Color getSkyTopColor();
  Color getSkyBottomColor();
  int calculatePoints(int currentScore);
  String getCreatorName();
}

/// Smooth, responsive physics and creative twilight-sunset theme implementation.
class SmoothCreativeStudentLogic implements IStudentLogic {
  const SmoothCreativeStudentLogic();

  @override
  Color getBirdColor() {
    // Radiant Phoenix Coral - vibrant, glowing pop on screen
    return const Color(0xFFFF6B6B);
  }

  @override
  double getGravity() {
    // Balanced at 880.0 for a floaty, graceful arc instead of heavy falling
    return 880.0;
  }

  @override
  double getGapSize() {
    // Generous and fair gap (215.0) allowing smooth flight corridors
    return 215.0;
  }

  @override
  double getPipeSpeed() {
    // Silky smooth scroll speed (160.0) preventing visual stutter
    return 160.0;
  }

  @override
  double calculateJumpStrength(double gravity) {
    // Error handling & bounds validation
    if (gravity.isNaN || gravity.isInfinite || gravity <= 0) {
      return -325.0; // Safe graceful fallback
    }

    try {
      // Physics-based kinetic impulse: v = -sqrt(2 * g * target_jump_height)
      // Designed for an optimal 58.0 pixel hop height
      final calculatedImpulse = -sqrt(2 * gravity * 58.0);
      
      // Clamp between safe bounds to guarantee fluid gameplay
      return calculatedImpulse.clamp(-360.0, -300.0);
    } catch (_) {
      return -325.0;
    }
  }

  @override
  Color getPipeColor() {
    // Modern Cyberpunk Neon Mint - crisp contrast against twilight skies
    return const Color(0xFF00E676);
  }

  @override
  Color getSkyTopColor() {
    // Deep Twilight Royal Amethyst
    return const Color(0xFF2E1C4E);
  }

  @override
  Color getSkyBottomColor() {
    // Radiant Sunset Peach Coral
    return const Color(0xFFFF8E72);
  }

  @override
  int calculatePoints(int currentScore) {
    // Error handling for negative or corrupted values
    if (currentScore < 0) {
      return 1;
    }

    // Creative dynamic scoring:
    // Base point = 1
    // Streak bonus (score >= 5) = +1 extra
    // Milestone burst (multiples of 10) = +2 extra bonus!
    int points = 1;

    if (currentScore >= 5) {
      points += 1; // Streak multiplier
    }

    if ((currentScore + 1) % 10 == 0) {
      points += 2; // Milestone jackpot bonus
    }

    return points;
  }

  @override
  String getCreatorName() {
    return "Flame Phoenix Architect";
  }
}

/// Facade preserving the exact existing API contracts for the workshop game.
class StudentCode {
  // Dependency injection: defaults to SmoothCreativeStudentLogic
  static IStudentLogic _delegate = const SmoothCreativeStudentLogic();

  /// Inject custom game logic implementation (ideal for testing or dynamic themes).
  static void setLogic(IStudentLogic logic) {
    _delegate = logic;
  }

  /// Get the currently active logic instance.
  static IStudentLogic get logic => _delegate;

  /// Reset to the default smooth creative logic.
  static void resetToDefault() {
    _delegate = const SmoothCreativeStudentLogic();
  }

  // ═══════════════════════════════════════════════════════════════
  // ✏️ TASK 1: Bird Color
  // ═══════════════════════════════════════════════════════════════
  static Color getBirdColor() {
    try {
      return _delegate.getBirdColor();
    } catch (_) {
      return const Color(0xFFFF6B6B);
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // ✏️ TASK 2: Gravity
  // ═══════════════════════════════════════════════════════════════
  static double getGravity() {
    try {
      final value = _delegate.getGravity();
      if (value.isNaN || value.isInfinite || value <= 0) {
        return 880.0;
      }
      return value;
    } catch (_) {
      return 880.0;
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // ✏️ TASK 3: Gap Size
  // ═══════════════════════════════════════════════════════════════
  static double getGapSize() {
    try {
      final value = _delegate.getGapSize();
      if (value.isNaN || value.isInfinite || value <= 50) {
        return 215.0;
      }
      return value;
    } catch (_) {
      return 215.0;
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // ✏️ TASK 4: Pipe Speed
  // ═══════════════════════════════════════════════════════════════
  static double getPipeSpeed() {
    try {
      final value = _delegate.getPipeSpeed();
      if (value.isNaN || value.isInfinite || value <= 0) {
        return 160.0;
      }
      return value;
    } catch (_) {
      return 160.0;
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // ✏️ TASK 5: Calculate Jump Strength
  // ═══════════════════════════════════════════════════════════════
  static double calculateJumpStrength(double gravity) {
    try {
      final safeGravity = (gravity.isNaN || gravity.isInfinite || gravity <= 0)
          ? getGravity()
          : gravity;
      return _delegate.calculateJumpStrength(safeGravity);
    } catch (_) {
      return -325.0;
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // ✏️ TASK 6: Choose Pipe Color
  // ═══════════════════════════════════════════════════════════════
  static Color getPipeColor() {
    try {
      return _delegate.getPipeColor();
    } catch (_) {
      return const Color(0xFF00E676);
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // ✏️ TASK 7: Sky Colors
  // ═══════════════════════════════════════════════════════════════
  static Color getSkyTopColor() {
    try {
      return _delegate.getSkyTopColor();
    } catch (_) {
      return const Color(0xFF2E1C4E);
    }
  }

  static Color getSkyBottomColor() {
    try {
      return _delegate.getSkyBottomColor();
    } catch (_) {
      return const Color(0xFFFF8E72);
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // ✏️ TASK 8: Calculate Points
  // ═══════════════════════════════════════════════════════════════
  static int calculatePoints(int currentScore) {
    try {
      return _delegate.calculatePoints(currentScore);
    } catch (_) {
      return 1;
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // ✏️ TASK 9: Creator Name
  // ═══════════════════════════════════════════════════════════════
  static String getCreatorName() {
    try {
      return _delegate.getCreatorName();
    } catch (_) {
      return "Flame Phoenix Architect";
    }
  }
}
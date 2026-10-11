import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flappy_flame/workshop/student_code.dart';
import 'package:flappy_flame/workshop/game_settings.dart';

class MockTestLogic implements IStudentLogic {
  @override
  Color getBirdColor() => Colors.purple;

  @override
  double getGravity() => 500.0;

  @override
  double getGapSize() => 300.0;

  @override
  double getPipeSpeed() => 120.0;

  @override
  double calculateJumpStrength(double gravity) => -250.0;

  @override
  Color getPipeColor() => Colors.yellow;

  @override
  Color getSkyTopColor() => Colors.black;

  @override
  Color getSkyBottomColor() => Colors.blueGrey;

  @override
  int calculatePoints(int currentScore) => 99;

  @override
  String getCreatorName() => 'Mock Creator';
}

class FaultyLogic implements IStudentLogic {
  @override
  Color getBirdColor() => throw Exception('Bird color error');

  @override
  double getGravity() => double.nan;

  @override
  double getGapSize() => -50.0;

  @override
  double getPipeSpeed() => double.infinity;

  @override
  double calculateJumpStrength(double gravity) => throw Exception('Jump error');

  @override
  Color getPipeColor() => throw Exception('Pipe color error');

  @override
  Color getSkyTopColor() => throw Exception('Sky top error');

  @override
  Color getSkyBottomColor() => throw Exception('Sky bottom error');

  @override
  int calculatePoints(int currentScore) => throw Exception('Score error');

  @override
  String getCreatorName() => throw Exception('Name error');
}

void main() {
  setUp(() {
    StudentCode.resetToDefault();
  });

  tearDown(() {
    StudentCode.resetToDefault();
  });

  group('SmoothCreativeStudentLogic Direct Tests', () {
    const logic = SmoothCreativeStudentLogic();

    test('verifies smooth physics values', () {
      expect(logic.getGravity(), equals(880.0));
      expect(logic.getGapSize(), equals(215.0));
      expect(logic.getPipeSpeed(), equals(160.0));
    });

    test('calculates jump strength smoothly and safely', () {
      final jump = logic.calculateJumpStrength(880.0);
      // Impulse should be negative and within smooth flight corridor
      expect(jump, lessThan(0));
      expect(jump, greaterThanOrEqualTo(-360.0));
      expect(jump, lessThanOrEqualTo(-300.0));

      // Error handling on invalid inputs
      expect(logic.calculateJumpStrength(double.nan), equals(-325.0));
      expect(logic.calculateJumpStrength(double.infinity), equals(-325.0));
      expect(logic.calculateJumpStrength(-100.0), equals(-325.0));
    });

    test('verifies creative color palette and theme', () {
      expect(logic.getBirdColor(), equals(const Color(0xFFFF6B6B)));
      expect(logic.getPipeColor(), equals(const Color(0xFF00E676)));
      expect(logic.getSkyTopColor(), equals(const Color(0xFF2E1C4E)));
      expect(logic.getSkyBottomColor(), equals(const Color(0xFFFF8E72)));
      expect(logic.getCreatorName(), equals('Flame Phoenix Architect'));
    });

    test('calculates points with creative combo multipliers', () {
      // Normal points
      expect(logic.calculatePoints(0), equals(1));
      expect(logic.calculatePoints(3), equals(1));

      // Streak bonus (score >= 5)
      expect(logic.calculatePoints(5), equals(2));
      expect(logic.calculatePoints(7), equals(2));

      // Milestone bonus at milestone transitions (e.g. going from 9 to 10 or 19 to 20)
      expect(logic.calculatePoints(9), equals(4)); // 1 base + 1 streak + 2 milestone = 4

      // Negative score boundary check
      expect(logic.calculatePoints(-1), equals(1));
    });
  });

  group('StudentCode Facade & Dependency Injection Tests', () {
    test('delegates properly to default smooth logic', () {
      expect(StudentCode.getBirdColor(), equals(const Color(0xFFFF6B6B)));
      expect(StudentCode.getGravity(), equals(880.0));
      expect(StudentCode.getGapSize(), equals(215.0));
      expect(StudentCode.getPipeSpeed(), equals(160.0));
      expect(StudentCode.calculateJumpStrength(880.0), lessThan(0));
      expect(StudentCode.getPipeColor(), equals(const Color(0xFF00E676)));
      expect(StudentCode.getSkyTopColor(), equals(const Color(0xFF2E1C4E)));
      expect(StudentCode.getSkyBottomColor(), equals(const Color(0xFFFF8E72)));
      expect(StudentCode.getCreatorName(), equals('Flame Phoenix Architect'));
    });

    test('supports dependency injection with custom implementation', () {
      StudentCode.setLogic(MockTestLogic());

      expect(StudentCode.getBirdColor(), equals(Colors.purple));
      expect(StudentCode.getGravity(), equals(500.0));
      expect(StudentCode.getGapSize(), equals(300.0));
      expect(StudentCode.getPipeSpeed(), equals(120.0));
      expect(StudentCode.calculateJumpStrength(500.0), equals(-250.0));
      expect(StudentCode.getPipeColor(), equals(Colors.yellow));
      expect(StudentCode.getSkyTopColor(), equals(Colors.black));
      expect(StudentCode.getSkyBottomColor(), equals(Colors.blueGrey));
      expect(StudentCode.calculatePoints(0), equals(99));
      expect(StudentCode.getCreatorName(), equals('Mock Creator'));

      StudentCode.resetToDefault();
      expect(StudentCode.getCreatorName(), equals('Flame Phoenix Architect'));
    });

    test('safely falls back during runtime exceptions from faulty logic', () {
      StudentCode.setLogic(FaultyLogic());

      // Should not throw, should use resilient fallbacks
      expect(StudentCode.getBirdColor(), equals(const Color(0xFFFF6B6B)));
      expect(StudentCode.getGravity(), equals(880.0));
      expect(StudentCode.getGapSize(), equals(215.0));
      expect(StudentCode.getPipeSpeed(), equals(160.0));
      expect(StudentCode.calculateJumpStrength(880.0), equals(-325.0));
      expect(StudentCode.getPipeColor(), equals(const Color(0xFF00E676)));
      expect(StudentCode.getSkyTopColor(), equals(const Color(0xFF2E1C4E)));
      expect(StudentCode.getSkyBottomColor(), equals(const Color(0xFFFF8E72)));
      expect(StudentCode.calculatePoints(10), equals(1));
      expect(StudentCode.getCreatorName(), equals('Flame Phoenix Architect'));
    });
  });

  group('WorkshopSettings Shark, Water & Ancient Brick Theme Tests', () {
    test('verifies shark configuration in WorkshopSettings', () {
      expect(WorkshopSettings.birdDesign, equals('shark'));
      expect(WorkshopSettings.birdEmoji, equals('🦈'));
      expect(WorkshopSettings.birdColor, equals(const Color(0xFF5A738E)));
      expect(WorkshopSettings.birdBellyColor, equals(const Color(0xFFE2E8F0)));
    });

    test('verifies ocean water background while preserving clouds', () {
      expect(WorkshopSettings.skyColorTop, equals(const Color(0xFF006994)));
      expect(WorkshopSettings.skyColorBottom, equals(const Color(0xFF001F3F)));
      expect(WorkshopSettings.cloudColor, equals(Colors.white));
      expect(WorkshopSettings.cloudOpacity, equals(0.6));
      expect(WorkshopSettings.groundColor, equals(const Color(0xFFC2B280)));
      expect(WorkshopSettings.grassColor, equals(const Color(0xFF2E8B57)));
    });

    test('verifies ancient brick pipe configuration', () {
      expect(WorkshopSettings.pipeDesign, equals('ancient_brick'));
      expect(WorkshopSettings.pipeColor, equals(const Color(0xFF8D5B4C)));
      expect(WorkshopSettings.pipeBorderColor, equals(const Color(0xFF4E3629)));
      expect(WorkshopSettings.pipeHighlightColor, equals(const Color(0xFFA66F5E)));
      expect(WorkshopSettings.pipeShadowColor, equals(const Color(0xFF3E2723)));
    });

    test('verifies game audio settings and audio files presence', () {
      expect(WorkshopSettings.soundEnabled, isTrue);
      expect(WorkshopSettings.jumpSound, equals('jump.wav'));
      expect(WorkshopSettings.scoreSound, equals('score.wav'));
      expect(WorkshopSettings.hitSound, equals('hit.wav'));
      expect(WorkshopSettings.swooshSound, equals('swoosh.wav'));
    });
  });
}

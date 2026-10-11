import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'package:flappy_flame/game/flappy_game.dart';
import 'package:flappy_flame/workshop/game_settings.dart';
import 'package:flappy_flame/services/audio_service.dart';

class Bird extends PositionComponent with HasGameReference<FlappyGame>, CollisionCallbacks {
  
  // Physics
  double velocity = 0;
  bool isAlive = true;
  
  // Settings from WorkshopSettings
  double get gravity => WorkshopSettings.gravity;
  double get jumpVelocity => WorkshopSettings.jumpStrength;
  double get birdSize => WorkshopSettings.birdSize;
  
  // Audio service
  final AudioService _audioService = AudioService();
  
  // Custom image sprite (if using custom image)
  Sprite? _customSprite;
  bool _useCustomImage = false;
  
  // Animation
  double _wingAngle = 0;
  bool _wingUp = true;

  @override
  Future<void> onLoad() async {
    size = Vector2.all(birdSize);
    position = Vector2(WorkshopSettings.birdStartX, game.size.y / 2);
    anchor = Anchor.center;
    
    // Add hitbox (slightly smaller for fairness)
    add(CircleHitbox(
      radius: birdSize * 0.4,
      position: size / 2,
      anchor: Anchor.center,
    ));
    
    // Try to load custom image if enabled
    if (WorkshopSettings.useCustomBirdImage) {
      await _loadCustomImage();
    }
  }

  Future<void> _loadCustomImage() async {
    try {
      _customSprite = await Sprite.load(
        'workshop/images/${WorkshopSettings.birdImageFile}',
      );
      _useCustomImage = true;
    } catch (e) {
      _useCustomImage = false;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!isAlive) return;

    // Apply gravity
    velocity += gravity * dt;
    position.y += velocity * dt;
    
    // Update rotation based on velocity
    if (WorkshopSettings.enableBirdRotation) {
      _updateRotation();
    }
    
    // Animate wings
    _animateWings(dt);

    // Check boundaries
    if (position.y > game.size.y - birdSize / 2 || position.y < birdSize / 2) {
      game.gameOver();
    }
  }

  void _updateRotation() {
    // Rotate bird based on velocity
    if (velocity < 0) {
      // Going up
      angle = WorkshopSettings.maxRotationUp * (velocity / jumpVelocity).clamp(0, 1);
    } else {
      // Falling down
      angle = WorkshopSettings.maxRotationDown * (velocity / 500).clamp(0, 1);
    }
  }

  void _animateWings(double dt) {
    // Simple wing flapping animation
    if (_wingUp) {
      _wingAngle += dt * 10;
      if (_wingAngle > 0.3) _wingUp = false;
    } else {
      _wingAngle -= dt * 10;
      if (_wingAngle < -0.3) _wingUp = true;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    if (_useCustomImage && _customSprite != null) {
      // Draw custom sprite image
      _customSprite!.render(
        canvas,
        size: size,
      );
    } else {
      // Draw based on selected design
      switch (WorkshopSettings.birdDesign) {
        case 'circle':
          _drawCircleBird(canvas);
          break;
        case 'square':
          _drawSquareBird(canvas);
          break;
        case 'triangle':
          _drawTriangleBird(canvas);
          break;
        case 'star':
          _drawStarBird(canvas);
          break;
        case 'emoji':
          _drawEmojiBird(canvas);
          break;
        case 'shark':
          _drawShark(canvas);
          break;
        case 'detailed':
        default:
          _drawDetailedBird(canvas);
          break;
      }
    }
  }

  /// 🟡 Simple Circle Bird
  void _drawCircleBird(Canvas canvas) {
    final paint = Paint()..color = WorkshopSettings.birdColor;
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), birdSize / 2, paint);
    
    // Eye
    final eyePaint = Paint()..color = WorkshopSettings.birdEyeColor;
    canvas.drawCircle(Offset(size.x / 2 + 8, size.y / 2 - 5), 5, eyePaint);
    
    // Pupil
    final pupilPaint = Paint()..color = WorkshopSettings.birdPupilColor;
    canvas.drawCircle(Offset(size.x / 2 + 10, size.y / 2 - 5), 2, pupilPaint);
    
    // Beak
    _drawBeak(canvas);
  }

  /// 🟨 Square/Pixel Bird
  void _drawSquareBird(Canvas canvas) {
    final paint = Paint()..color = WorkshopSettings.birdColor;
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(size.x / 2, size.y / 2),
        width: birdSize * 0.9,
        height: birdSize * 0.9,
      ),
      paint,
    );
    
    // Pixel eye
    final eyePaint = Paint()..color = WorkshopSettings.birdPupilColor;
    canvas.drawRect(
      Rect.fromLTWH(size.x / 2 + 5, size.y / 2 - 8, 6, 6),
      eyePaint,
    );
    
    // Pixel beak
    final beakPaint = Paint()..color = WorkshopSettings.birdBeakColor;
    canvas.drawRect(
      Rect.fromLTWH(size.x / 2 + 15, size.y / 2 - 2, 8, 6),
      beakPaint,
    );
  }

  /// 🔺 Triangle Bird
  void _drawTriangleBird(Canvas canvas) {
    final paint = Paint()..color = WorkshopSettings.birdColor;
    final path = Path()
      ..moveTo(size.x / 2 + birdSize / 2, size.y / 2)
      ..lineTo(size.x / 2 - birdSize / 2, size.y / 2 - birdSize / 2)
      ..lineTo(size.x / 2 - birdSize / 2, size.y / 2 + birdSize / 2)
      ..close();
    canvas.drawPath(path, paint);
    
    // Eye
    final eyePaint = Paint()..color = WorkshopSettings.birdPupilColor;
    canvas.drawCircle(Offset(size.x / 2 - 5, size.y / 2 - 5), 3, eyePaint);
  }

  /// ⭐ Star Bird
  void _drawStarBird(Canvas canvas) {
    final paint = Paint()..color = WorkshopSettings.birdColor;
    final path = _createStarPath(
      Offset(size.x / 2, size.y / 2),
      birdSize / 2,
      birdSize / 4,
      5,
    );
    canvas.drawPath(path, paint);
    
    // Eye in center
    final eyePaint = Paint()..color = WorkshopSettings.birdPupilColor;
    canvas.drawCircle(Offset(size.x / 2, size.y / 2 - 3), 4, eyePaint);
  }

  Path _createStarPath(Offset center, double outerRadius, double innerRadius, int points) {
    final path = Path();
    final angle = pi / points;
    
    for (int i = 0; i < points * 2; i++) {
      final radius = i.isEven ? outerRadius : innerRadius;
      final x = center.dx + radius * cos(i * angle - pi / 2);
      final y = center.dy + radius * sin(i * angle - pi / 2);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  /// 😊 Emoji Bird
  void _drawEmojiBird(Canvas canvas) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: WorkshopSettings.birdEmoji,
        style: TextStyle(fontSize: birdSize * 0.9),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size.x - textPainter.width) / 2,
        (size.y - textPainter.height) / 2,
      ),
    );
  }

  /// 🐦 Detailed Bird (Default)
  void _drawDetailedBird(Canvas canvas) {
    final centerX = size.x / 2;
    final centerY = size.y / 2;
    
    // Body
    final bodyPaint = Paint()..color = WorkshopSettings.birdColor;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX, centerY),
        width: birdSize,
        height: birdSize * 0.8,
      ),
      bodyPaint,
    );
    
    // Belly
    final bellyPaint = Paint()..color = WorkshopSettings.birdBellyColor;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX - 2, centerY + 3),
        width: birdSize * 0.5,
        height: birdSize * 0.4,
      ),
      bellyPaint,
    );
    
    // Wing
    canvas.save();
    canvas.translate(centerX - 5, centerY);
    canvas.rotate(_wingAngle);
    final wingPaint = Paint()..color = WorkshopSettings.birdWingColor;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset.zero,
        width: birdSize * 0.4,
        height: birdSize * 0.25,
      ),
      wingPaint,
    );
    canvas.restore();
    
    // Eye white
    final eyeWhitePaint = Paint()..color = WorkshopSettings.birdEyeColor;
    canvas.drawCircle(
      Offset(centerX + 8, centerY - 5),
      6,
      eyeWhitePaint,
    );
    
    // Pupil
    final pupilPaint = Paint()..color = WorkshopSettings.birdPupilColor;
    canvas.drawCircle(
      Offset(centerX + 10, centerY - 5),
      3,
      pupilPaint,
    );
    
    // Eye shine
    final shinePaint = Paint()..color = Colors.white;
    canvas.drawCircle(
      Offset(centerX + 9, centerY - 7),
      1.5,
      shinePaint,
    );
    
    // Beak
    _drawBeak(canvas);
    
    // Tail feathers
    final tailPaint = Paint()..color = WorkshopSettings.birdWingColor;
    final tailPath = Path()
      ..moveTo(centerX - birdSize / 2, centerY - 3)
      ..lineTo(centerX - birdSize / 2 - 8, centerY - 8)
      ..lineTo(centerX - birdSize / 2 - 6, centerY)
      ..lineTo(centerX - birdSize / 2 - 10, centerY + 5)
      ..lineTo(centerX - birdSize / 2, centerY + 3)
      ..close();
    canvas.drawPath(tailPath, tailPaint);
  }

  void _drawBeak(Canvas canvas) {
    final beakPaint = Paint()..color = WorkshopSettings.birdBeakColor;
    final beakPath = Path()
      ..moveTo(size.x / 2 + birdSize / 2 - 5, size.y / 2 - 2)
      ..lineTo(size.x / 2 + birdSize / 2 + 8, size.y / 2 + 2)
      ..lineTo(size.x / 2 + birdSize / 2 - 5, size.y / 2 + 5)
      ..close();
    canvas.drawPath(beakPath, beakPaint);
  }

  /// 🦈 Shark Bird
  void _drawShark(Canvas canvas) {
    final centerX = size.x / 2;
    final centerY = size.y / 2;
    final bodyPaint = Paint()..color = WorkshopSettings.birdColor;
    final bellyPaint = Paint()..color = WorkshopSettings.birdBellyColor;
    final finPaint = Paint()..color = WorkshopSettings.birdWingColor;

    // 1. Caudal (Tail) Fin
    final tailPath = Path()
      ..moveTo(centerX - birdSize * 0.35, centerY)
      ..lineTo(centerX - birdSize * 0.65, centerY - birdSize * 0.45)
      ..quadraticBezierTo(centerX - birdSize * 0.45, centerY - birdSize * 0.1, centerX - birdSize * 0.35, centerY)
      ..lineTo(centerX - birdSize * 0.58, centerY + birdSize * 0.3)
      ..quadraticBezierTo(centerX - birdSize * 0.45, centerY + birdSize * 0.1, centerX - birdSize * 0.35, centerY)
      ..close();
    canvas.drawPath(tailPath, finPaint);

    // 2. Dorsal Fin on top
    final dorsalPath = Path()
      ..moveTo(centerX - birdSize * 0.1, centerY - birdSize * 0.25)
      ..quadraticBezierTo(centerX, centerY - birdSize * 0.6, centerX + birdSize * 0.05, centerY - birdSize * 0.62)
      ..quadraticBezierTo(centerX + birdSize * 0.02, centerY - birdSize * 0.45, centerX + birdSize * 0.18, centerY - birdSize * 0.22)
      ..close();
    canvas.drawPath(dorsalPath, finPaint);

    // 3. Torpedo Shark Body
    final bodyPath = Path()
      ..moveTo(centerX - birdSize * 0.4, centerY)
      ..cubicTo(
        centerX - birdSize * 0.3, centerY - birdSize * 0.4,
        centerX + birdSize * 0.2, centerY - birdSize * 0.4,
        centerX + birdSize * 0.55, centerY - birdSize * 0.05,
      )
      ..cubicTo(
        centerX + birdSize * 0.3, centerY + birdSize * 0.4,
        centerX - birdSize * 0.2, centerY + birdSize * 0.35,
        centerX - birdSize * 0.4, centerY,
      )
      ..close();
    canvas.drawPath(bodyPath, bodyPaint);

    // 4. Pale Counter-Shaded Underbelly
    final bellyPath = Path()
      ..moveTo(centerX - birdSize * 0.35, centerY + birdSize * 0.05)
      ..cubicTo(
        centerX - birdSize * 0.1, centerY + birdSize * 0.08,
        centerX + birdSize * 0.2, centerY + birdSize * 0.08,
        centerX + birdSize * 0.52, centerY - birdSize * 0.02,
      )
      ..cubicTo(
        centerX + birdSize * 0.28, centerY + birdSize * 0.38,
        centerX - birdSize * 0.18, centerY + birdSize * 0.34,
        centerX - birdSize * 0.35, centerY + birdSize * 0.05,
      )
      ..close();
    canvas.drawPath(bellyPath, bellyPaint);

    // 5. Pectoral Fin
    canvas.save();
    canvas.translate(centerX - birdSize * 0.05, centerY + birdSize * 0.1);
    canvas.rotate(_wingAngle * 0.5);
    final pectoralPath = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(birdSize * 0.05, birdSize * 0.3, -birdSize * 0.15, birdSize * 0.35)
      ..quadraticBezierTo(-birdSize * 0.05, birdSize * 0.15, 0, 0)
      ..close();
    canvas.drawPath(pectoralPath, finPaint);
    canvas.restore();

    // 6. Gills
    final gillPaint = Paint()
      ..color = const Color(0xFF37474F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    for (int i = 0; i < 3; i++) {
      final gx = centerX + birdSize * 0.02 - (i * 3.5);
      canvas.drawLine(Offset(gx, centerY - 4), Offset(gx - 1.5, centerY + 6), gillPaint);
    }

    // 7. Sharp Tooth & Mouth
    final mouthPaint = Paint()
      ..color = const Color(0xFF263238)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;
    final mouthPath = Path()
      ..moveTo(centerX + birdSize * 0.45, centerY + birdSize * 0.08)
      ..quadraticBezierTo(centerX + birdSize * 0.32, centerY + birdSize * 0.18, centerX + birdSize * 0.2, centerY + birdSize * 0.12);
    canvas.drawPath(mouthPath, mouthPaint);

    final teethPaint = Paint()..color = Colors.white;
    for (int i = 0; i < 2; i++) {
      final tx = centerX + birdSize * 0.38 - (i * 5);
      final toothPath = Path()
        ..moveTo(tx, centerY + birdSize * 0.1)
        ..lineTo(tx + 2.5, centerY + birdSize * 0.17)
        ..lineTo(tx + 5, centerY + birdSize * 0.1)
        ..close();
      canvas.drawPath(toothPath, teethPaint);
    }

    // 8. Shark Eye
    final eyeWhite = Paint()..color = WorkshopSettings.birdEyeColor;
    final eyeCenter = Offset(centerX + birdSize * 0.28, centerY - birdSize * 0.12);
    canvas.drawCircle(eyeCenter, 4.5, eyeWhite);

    final eyePupil = Paint()..color = WorkshopSettings.birdPupilColor;
    canvas.drawCircle(Offset(eyeCenter.dx + 1, eyeCenter.dy), 2.2, eyePupil);

    final eyeGlint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(eyeCenter.dx + 0.5, eyeCenter.dy - 1.2), 1.2, eyeGlint);
  }

  void jump() {
    if (isAlive) {
      velocity = jumpVelocity;
      _audioService.playJump();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (isAlive) {
      game.gameOver();
    }
  }

  void reset() {
    position = Vector2(WorkshopSettings.birdStartX, game.size.y / 2);
    velocity = 0;
    angle = 0;
    isAlive = true;
  }
}
import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ManaParticle {
  double x;
  double y;
  double size;
  double speedY;
  double speedX;
  double opacity;
  Color color;

  ManaParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.speedY,
    required this.speedX,
    required this.opacity,
    required this.color,
  });
}

class ParticleBackground extends StatefulWidget {
  final Widget child;
  const ParticleBackground({Key? key, required this.child}) : super(key: key);

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<ManaParticle> _particles = [];
  final Random _random = Random();
  final int _count = 25;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _count; i++) {
      _particles.add(
        ManaParticle(
          x: _random.nextDouble(),
          y: _random.nextDouble(),
          size: _random.nextDouble() * 2.5 + 1.2,
          speedY: _random.nextDouble() * 0.0015 + 0.0008,
          speedX: (_random.nextDouble() - 0.5) * 0.0006,
          opacity: _random.nextDouble() * 0.6 + 0.25,
          color: _random.nextBool()
              ? AriseColors.neonCyan
              : AriseColors.neonPurple,
        ),
      );
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(() {
        setState(() {
          for (var p in _particles) {
            p.y -= p.speedY;
            p.x += p.speedX;
            if (p.y < 0) {
              p.y = 1.0;
              p.x = _random.nextDouble();
            }
          }
        });
      })
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: ParticlePainter(_particles),
          ),
        ),
        widget.child,
      ],
    );
  }
}

class ParticlePainter extends CustomPainter {
  final List<ManaParticle> particles;
  ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (var p in particles) {
      final paint = Paint()
        ..color = p.color.withOpacity(p.opacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

      canvas.drawCircle(
        Offset(p.x * size.width, p.y * size.height),
        p.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) => true;
}

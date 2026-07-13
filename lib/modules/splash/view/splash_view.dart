import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:timesmed_project/modules/splash/controller/splash_controller.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  late final SplashController controller;

  // ── Animation Controllers ──
  late final AnimationController _flipCtrl;       // 3D flip entrance
  late final AnimationController _glowBurstCtrl;  // glow burst on landing
  late final AnimationController _breatheCtrl;    // subtle breathing
  late final AnimationController _orbitalCtrl;    // orbital rings
  late final AnimationController _pulseCtrl;      // pulse ripples
  late final AnimationController _particleCtrl;   // floating particles
  late final AnimationController _textCtrl;       // tagline text
  late final AnimationController _heartbeatCtrl;  // EKG heartbeat
  late final AnimationController _shimmerCtrl;    // shimmer sweep
  late final AnimationController _haloCtrl;       // rotating halo

  late final Animation<double> _flipAngle;
  late final Animation<double> _flipScale;
  late final Animation<double> _flipFade;
  late final Animation<double> _glowBurstScale;
  late final Animation<double> _glowBurstOpacity;
  late final Animation<double> _breatheScale;
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();
    controller = Get.put(SplashController());

    // ═══════════════════════════════════════════════
    //  1. 3D FLIP REVEAL — logo flips in from Y-axis
    // ═══════════════════════════════════════════════
    _flipCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    // Flip rotation: starts at 90° (edge-on, invisible) → 0° (face-on)
    _flipAngle = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: pi / 2, end: -0.15)
            .chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 70,
      ),
      // Small overshoot bounce back
      TweenSequenceItem(
        tween: Tween<double>(begin: -0.15, end: 0.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 30,
      ),
    ]).animate(_flipCtrl);

    // Scale: starts slightly small, pops to 1.08 on landing, settles to 1.0
    _flipScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.6, end: 1.08)
            .chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 65,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.08, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 35,
      ),
    ]).animate(_flipCtrl);

    // Fade in during first half of the flip
    _flipFade = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(1.0),
        weight: 65,
      ),
    ]).animate(_flipCtrl);

    // ═══════════════════════════════════════════════
    //  2. GLOW BURST — expands outward when logo lands
    // ═══════════════════════════════════════════════
    _glowBurstCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _glowBurstScale = Tween<double>(begin: 0.3, end: 2.5).animate(
      CurvedAnimation(parent: _glowBurstCtrl, curve: Curves.easeOutQuart),
    );
    _glowBurstOpacity = Tween<double>(begin: 0.7, end: 0.0).animate(
      CurvedAnimation(parent: _glowBurstCtrl, curve: Curves.easeOut),
    );

    // ═══════════════════════════════════════════════
    //  3. BREATHING — subtle scale pulse after landing
    // ═══════════════════════════════════════════════
    _breatheCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _breatheScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.04)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.04, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(_breatheCtrl);

    // ═══════════════════════════════════════════════
    //  4. ORBITAL RINGS — full rotation within 2s window
    // ═══════════════════════════════════════════════
    _orbitalCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // ═══════════════════════════════════════════════
    //  5. PULSE RIPPLES — completes exactly within the 2s splash window
    // ═══════════════════════════════════════════════
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // ═══════════════════════════════════════════════
    //  6. PARTICLES — runs once across the 2s window
    // ═══════════════════════════════════════════════
    _particleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // ═══════════════════════════════════════════════
    //  7. TAGLINE TEXT
    // ═══════════════════════════════════════════════
    _textCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textCtrl, curve: Curves.easeOut),
    );

    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _textCtrl, curve: Curves.easeOutCubic),
    );

    // ═══════════════════════════════════════════════
    //  8. HEARTBEAT EKG — single 3-peak sweep finishes inside window
    // ═══════════════════════════════════════════════
    _heartbeatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    // ═══════════════════════════════════════════════
    //  9. SHIMMER SWEEP
    // ═══════════════════════════════════════════════
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    // ═══════════════════════════════════════════════
    //  10. ROTATING GRADIENT HALO
    // ═══════════════════════════════════════════════
    _haloCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // ────────────────────────────────────────────────
    //  ORCHESTRATION — every animation completes within 2000ms
    // ────────────────────────────────────────────────

    // 0ms — Flip entrance (ends 1100ms)
    _flipCtrl.forward();
    // 0ms — Pulse ripples one full cycle (ends 2000ms)
    _pulseCtrl.forward();
    // 0ms — Particle drift one pass (ends 2000ms)
    _particleCtrl.forward();
    // 0ms — Halo rotation one revolution (ends 2000ms)
    _haloCtrl.forward();
    // 0ms — Orbital rings one revolution (ends 2000ms)
    _orbitalCtrl.forward();
    // 0ms — Shimmer sweep (ends 1400ms)
    _shimmerCtrl.forward();

    // 800ms — Glow burst on logo landing (ends 1500ms)
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) _glowBurstCtrl.forward();
    });

    // 1000ms — Text fade-in (ends 1600ms)
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) _textCtrl.forward();
    });

    // 1100ms — Heartbeat EKG sweep (ends 2000ms)
    Future.delayed(const Duration(milliseconds: 1100), () {
      if (mounted) _heartbeatCtrl.forward();
    });

    // 1100ms — Single breathe cycle after flip settles (ends 2000ms)
    Future.delayed(const Duration(milliseconds: 1100), () {
      if (mounted) _breatheCtrl.forward();
    });
  }

  @override
  void dispose() {
    _flipCtrl.dispose();
    _glowBurstCtrl.dispose();
    _breatheCtrl.dispose();
    _orbitalCtrl.dispose();
    _pulseCtrl.dispose();
    _particleCtrl.dispose();
    _textCtrl.dispose();
    _heartbeatCtrl.dispose();
    _shimmerCtrl.dispose();
    _haloCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF020A18),
              Color(0xFF061728),
              Color(0xFF0A2440),
              Color(0xFF082038),
              Color(0xFF040E1E),
            ],
            stops: [0.0, 0.2, 0.5, 0.75, 1.0],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // ── Layer 1: Subtle grid/mesh overlay for premium depth ──
            CustomPaint(
              size: size,
              painter: _PremiumGridPainter(),
            ),

            // ── Layer 2: Floating particles (refined, fewer, more elegant) ──
            AnimatedBuilder(
              animation: _particleCtrl,
              builder: (context, _) => CustomPaint(
                size: size,
                painter: _PremiumParticlePainter(progress: _particleCtrl.value),
              ),
            ),

            // ── Layer 3: Rotating gradient halo ──
            AnimatedBuilder(
              animation: _haloCtrl,
              builder: (context, _) => Transform.rotate(
                angle: _haloCtrl.value * 2 * pi,
                child: Container(
                  width: 340,
                  height: 340,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: SweepGradient(
                      colors: [
                        const Color(0xFF0473EA).withOpacity(0.0),
                        const Color(0xFF0473EA).withOpacity(0.10),
                        const Color(0xFF2196F3).withOpacity(0.08),
                        const Color(0xFF6CBD4F).withOpacity(0.06),
                        const Color(0xFF0473EA).withOpacity(0.0),
                      ],
                      stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                    ),
                  ),
                ),
              ),
            ),

            // ── Layer 4: Multi-ring pulse ripples ──
            ..._buildPulseRings(),

            // ── Layer 5: Orbital rings (refined) ──
            AnimatedBuilder(
              animation: _orbitalCtrl,
              builder: (context, _) => CustomPaint(
                size: const Size(320, 320),
                painter: _PremiumOrbitalPainter(
                  progress: _orbitalCtrl.value,
                ),
              ),
            ),

            // ── Layer 6: Glow burst on logo landing ──
            AnimatedBuilder(
              animation: _glowBurstCtrl,
              builder: (context, _) => Opacity(
                opacity: _glowBurstOpacity.value,
                child: Transform.scale(
                  scale: _glowBurstScale.value,
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.white.withOpacity(0.3),
                          const Color(0xFF0473EA).withOpacity(0.2),
                          const Color(0xFF47A6FF).withOpacity(0.1),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.3, 0.6, 1.0],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ── Layer 7: Radial glow behind logo (persistent, subtle) ──
            AnimatedBuilder(
              animation: Listenable.merge([_flipCtrl, _breatheCtrl]),
              builder: (context, _) {
                final breathe =
                    _breatheCtrl.isAnimating ? _breatheScale.value : 1.0;
                return Opacity(
                  opacity: _flipFade.value * 0.4,
                  child: Transform.scale(
                    scale: breathe,
                    child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFF0473EA).withOpacity(0.25),
                            const Color(0xFF2196F3).withOpacity(0.10),
                            const Color(0xFF6CBD4F).withOpacity(0.05),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.35, 0.6, 1.0],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            // ── Layer 8: Main content (logo + text) ──
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 3D Flip Logo
                AnimatedBuilder(
                  animation: Listenable.merge([
                    _flipCtrl,
                    _breatheCtrl,
                    _shimmerCtrl,
                  ]),
                  builder: (context, child) {
                    final breathe =
                        _breatheCtrl.isAnimating ? _breatheScale.value : 1.0;
                    return Opacity(
                      opacity: _flipFade.value,
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001) // perspective
                          ..rotateY(_flipAngle.value)
                          ..scale(_flipScale.value * breathe),
                        child: child,
                      ),
                    );
                  },
                  child: _buildLogoContainer(),
                ),

                const SizedBox(height: 48),

                // Heartbeat EKG line
                AnimatedBuilder(
                  animation: Listenable.merge([_heartbeatCtrl, _textCtrl]),
                  builder: (context, _) => Opacity(
                    opacity: _textFade.value,
                    child: SizedBox(
                      width: 260,
                      height: 36,
                      child: CustomPaint(
                        painter: _HeartbeatPainter(
                          progress: _heartbeatCtrl.value,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Tagline
                SlideTransition(
                  position: _textSlide,
                  child: FadeTransition(
                    opacity: _textFade,
                    child: Column(
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [
                              Color(0xFF87CEFA),
                              Color(0xFFE0F0FF),
                              Color(0xFF87CEFA),
                            ],
                          ).createShader(bounds),
                          child: const Text(
                            'Your Health, Our Priority',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              letterSpacing: 3.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 36),
                        // Premium loading indicator
                        SizedBox(
                          width: 180,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: _PremiumProgressBar(
                              controller: _particleCtrl,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Logo container with glass morphism + shimmer ──
  Widget _buildLogoContainer() {
    return AnimatedBuilder(
      animation: _shimmerCtrl,
      builder: (context, child) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Stack(
              children: [
                // Main container
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30, vertical: 28),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    color: Colors.white.withOpacity(0.04),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.12),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0473EA).withOpacity(0.20),
                        blurRadius: 60,
                        spreadRadius: 5,
                      ),
                      BoxShadow(
                        color: const Color(0xFF2196F3).withOpacity(0.08),
                        blurRadius: 80,
                        spreadRadius: 15,
                      ),
                    ],
                  ),
                  child: SvgPicture.asset(
                    'assets/logos/svg/timesmed_logo.svg',
                    width: 190,
                  ),
                ),

                // Shimmer sweep overlay
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: ShaderMask(
                      shaderCallback: (bounds) {
                        final shimmerPos = _shimmerCtrl.value * 3.0 - 1.0;
                        return LinearGradient(
                          begin: Alignment(shimmerPos - 0.3, -0.3),
                          end: Alignment(shimmerPos + 0.3, 0.3),
                          colors: [
                            Colors.transparent,
                            Colors.white.withOpacity(0.08),
                            Colors.white.withOpacity(0.15),
                            Colors.white.withOpacity(0.08),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
                        ).createShader(bounds);
                      },
                      blendMode: BlendMode.srcATop,
                      child: Container(
                        color: Colors.white.withOpacity(0.05),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Pulse rings — refined, fewer, cleaner ──
  List<Widget> _buildPulseRings() {
    return List.generate(3, (i) {
      final delay = i * 0.33;
      return AnimatedBuilder(
        animation: _pulseCtrl,
        builder: (context, _) {
          final t = (_pulseCtrl.value + delay) % 1.0;
          final scale = 0.7 + t * 1.8;
          final opacity = (1.0 - t).clamp(0.0, 0.35);
          return Transform.scale(
            scale: scale,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: i == 0
                      ? Color(0xFF0473EA).withOpacity(opacity)
                      : i == 1
                          ? Color(0xFF2196F3).withOpacity(opacity * 0.7)
                          : Color(0xFF6CBD4F).withOpacity(opacity * 0.5),
                  width: 1.2,
                ),
              ),
            ),
          );
        },
      );
    });
  }
}

// ══════════════════════════════════════════════════════════
//  PAINTERS — Premium Medical
// ══════════════════════════════════════════════════════════

/// Subtle grid mesh for premium depth
class _PremiumGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF0473EA).withOpacity(0.03)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    const spacing = 60.0;

    // Horizontal lines
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    // Vertical lines
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

/// Premium orbital rings — cleaner, thinner, more medical
class _PremiumOrbitalPainter extends CustomPainter {
  final double progress;
  _PremiumOrbitalPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Ring 1 — large, slow, primary blue
    _drawOrbitRing(
      canvas, center,
      radiusX: 148, radiusY: 52,
      rotation: progress * 2 * pi,
      tilt: 0.25,
      color: const Color(0xFF0473EA),
      dotCount: 3,
      dotRadius: 2.5,
    );

    // Ring 2 — medium, reverse, lighter blue
    _drawOrbitRing(
      canvas, center,
      radiusX: 115, radiusY: 42,
      rotation: -progress * 2 * pi * 1.2,
      tilt: -0.45,
      color: const Color(0xFF47A6FF),
      dotCount: 2,
      dotRadius: 2.0,
    );

    // Ring 3 — small, fast, green accent
    _drawOrbitRing(
      canvas, center,
      radiusX: 85, radiusY: 32,
      rotation: progress * 2 * pi * 1.6,
      tilt: 0.7,
      color: const Color(0xFF6CBD4F),
      dotCount: 2,
      dotRadius: 1.8,
    );
  }

  void _drawOrbitRing(
    Canvas canvas,
    Offset center, {
    required double radiusX,
    required double radiusY,
    required double rotation,
    required double tilt,
    required Color color,
    required int dotCount,
    required double dotRadius,
  }) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(tilt);

    // Dashed ring path (faint)
    final ringPaint = Paint()
      ..color = color.withOpacity(0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6;
    final ringRect = Rect.fromCenter(
      center: Offset.zero,
      width: radiusX * 2,
      height: radiusY * 2,
    );
    canvas.drawOval(ringRect, ringPaint);

    // Glowing dots along the ring
    for (int i = 0; i < dotCount; i++) {
      final angle = rotation + (i * 2 * pi / dotCount);
      final dx = radiusX * cos(angle);
      final dy = radiusY * sin(angle);

      // Soft glow
      final glowPaint = Paint()
        ..color = color.withOpacity(0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(Offset(dx, dy), dotRadius + 4, glowPaint);

      // Core dot
      final dotPaint = Paint()..color = color.withOpacity(0.85);
      canvas.drawCircle(Offset(dx, dy), dotRadius, dotPaint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PremiumOrbitalPainter old) => true;
}

/// Premium floating particles — fewer, more elegant, varied opacity
class _PremiumParticlePainter extends CustomPainter {
  final double progress;
  final List<_PremiumParticle> _particles;

  _PremiumParticlePainter({required this.progress})
      : _particles = List.generate(25, (i) => _PremiumParticle(i));

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in _particles) {
      final dx = p.x * size.width;
      final rawY = (p.y + progress * p.speed) % 1.0;
      final dy = rawY * size.height;

      // Smooth twinkle
      final twinkle = (sin((progress * 2.5 + p.phase) * pi * 2) * 0.5 + 0.5);
      final opacity = twinkle * p.maxAlpha;
      if (opacity < 0.01) continue;

      // Soft glow
      final glowPaint = Paint()
        ..color = p.color.withOpacity(opacity * 0.4)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, p.radius * 2.5);
      canvas.drawCircle(Offset(dx, dy), p.radius * 2, glowPaint);

      // Core
      final corePaint = Paint()..color = p.color.withOpacity(opacity);
      canvas.drawCircle(Offset(dx, dy), p.radius, corePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _PremiumParticlePainter old) => true;
}

class _PremiumParticle {
  final double x, y, speed, phase, radius, maxAlpha;
  final Color color;

  // Premium medical palette — blues with subtle green accent
  static const _colors = [
    Color(0xFF0473EA),
    Color(0xFF2196F3),
    Color(0xFF47A6FF),
    Color(0xFF87CEFA),
    Color(0xFF6CBD4F),
  ];

  _PremiumParticle(int index)
      : x = _sr(index * 7),
        y = _sr(index * 13),
        speed = 0.10 + _sr(index * 19) * 0.30,
        phase = _sr(index * 23),
        radius = 0.8 + _sr(index * 29) * 2.5,
        maxAlpha = 0.10 + _sr(index * 37) * 0.20,
        color = _colors[index % _colors.length];

  static double _sr(int seed) =>
      ((seed * 9301 + 49297) % 233280) / 233280.0;
}

/// Heartbeat / EKG line — 3 distinct pulse peaks with premium gradient
class _HeartbeatPainter extends CustomPainter {
  final double progress;
  _HeartbeatPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final mid = h / 2;
    final amp = h * 0.38;

    final List<Offset> wave = [];
    wave.add(Offset(0.0, mid));

    for (int beat = 0; beat < 3; beat++) {
      final base = beat / 3.0;
      final s = 1.0 / 3.0;
      wave.addAll([
        Offset(base + s * 0.10, mid),
        Offset(base + s * 0.20, mid + 3),
        Offset(base + s * 0.28, mid - 2),
        Offset(base + s * 0.33, mid),
        Offset(base + s * 0.38, mid - amp),
        Offset(base + s * 0.44, mid + amp * 0.6),
        Offset(base + s * 0.50, mid - amp * 0.2),
        Offset(base + s * 0.56, mid),
        Offset(base + s * 0.66, mid - 4),
        Offset(base + s * 0.76, mid),
        Offset(base + s * 1.00, mid),
      ]);
    }

    final path = Path();
    path.moveTo(wave.first.dx * w, wave.first.dy);
    for (int i = 1; i < wave.length; i++) {
      final prev = wave[i - 1];
      final curr = wave[i];
      final cpX = (prev.dx * w + curr.dx * w) / 2;
      path.cubicTo(cpX, prev.dy, cpX, curr.dy, curr.dx * w, curr.dy);
    }

    // Animated reveal
    final revealX = progress * w * 1.15;

    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, revealX, h));

    // Glow line
    final glowPaint = Paint()
      ..color = const Color(0xFF0473EA).withOpacity(0.20)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.5
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawPath(path, glowPaint);

    // Main gradient line
    final linePaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF0473EA), Color(0xFF47A6FF), Color(0xFF6CBD4F)],
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, linePaint);

    canvas.restore();

    // Leading dot with glow
    if (revealX > 0 && revealX < w * 1.05) {
      final metrics = path.computeMetrics().first;
      final fraction = (revealX / w).clamp(0.0, 1.0);
      final tangent =
          metrics.getTangentForOffset(metrics.length * fraction);
      if (tangent != null) {
        // Outer glow
        final outerGlow = Paint()
          ..color = const Color(0xFF47A6FF).withOpacity(0.35)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
        canvas.drawCircle(tangent.position, 7, outerGlow);
        // Core dot
        final dotPaint = Paint()
          ..color = Colors.white
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
        canvas.drawCircle(tangent.position, 2.5, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _HeartbeatPainter old) => true;
}

/// Premium shimmer progress bar
class _PremiumProgressBar extends StatelessWidget {
  final AnimationController controller;
  const _PremiumProgressBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Container(
          height: 2.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.white.withOpacity(0.05),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: 0.35,
            child: Transform.translate(
              offset: Offset(180 * 1.8 * controller.value - 80, 0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: const LinearGradient(
                    colors: [
                      Colors.transparent,
                      Color(0xFF0473EA),
                      Color(0xFF47A6FF),
                      Color(0xFF87CEFA),
                      Colors.transparent,
                    ],
                    stops: [0.0, 0.2, 0.5, 0.8, 1.0],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

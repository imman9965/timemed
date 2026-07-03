import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:timesmed_project/modules/doctor/theme/doctor_theme.dart';
import '../controller/login_controller.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> with TickerProviderStateMixin {
  final controller = Get.find<LoginController>();

  late final AnimationController _bgCtrl;
  late final AnimationController _cardCtrl;
  late final Animation<double> _cardScale;
  late final Animation<double> _cardFade;

  @override
  void initState() {
    super.initState();

    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _cardCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _cardScale = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _cardCtrl, curve: Curves.easeOutBack),
    );
    _cardFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cardCtrl, curve: Curves.easeOut),
    );

    _cardCtrl.forward();
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _cardCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // ── Pin Themes ──
    final defaultTheme = PinTheme(
      width: 60,
      height: 58,
      textStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.normal,
        color: Colors.black, // 👈 TEXT COLOR
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withOpacity(0.12),
          width: 1.2,
        ),
      ),
    );

    final focusedTheme = defaultTheme.copyWith(
      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: DoctorColors.primaryAccent,
          width: 2,
        ),
        // boxShadow: [
        //   BoxShadow(
        //     color: DoctorColors.primaryDeep.withOpacity(0.3),
        //     blurRadius: 12,
        //     offset: const Offset(0, 4),
        //   ),
        // ],
      ),
    );

    final submittedTheme = defaultTheme.copyWith(
      decoration: BoxDecoration(

        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: DoctorColors.primaryDeep.withOpacity(0.4),
          width: 1.5,
        ),
      ),
    );

    return Scaffold(
      body: Stack(
        children: [
          // ── GRADIENT BACKGROUND ──
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              // gradient: LinearGradient(
              //   begin: Alignment.topLeft,
              //   end: Alignment.bottomRight,
              //   colors: [
              //     Color(0xFF0A1628),
              //     Color(0xFF0D2137),
              //     Color(0xFF0F2D4A),
              //     Color(0xFF0A1E35),
              //   ],
              // ),
            ),
          ),

          // ── FLOATING ORBS ──
          AnimatedBuilder(
            animation: _bgCtrl,
            builder: (context, _) => CustomPaint(
              size: size,
              painter: _OtpOrbsPainter(progress: _bgCtrl.value),
            ),
          ),

          // ── BACK BUTTON ──
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),

          // ── MAIN CONTENT ──
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: AnimatedBuilder(
                  animation: _cardCtrl,
                  builder: (context, child) => Transform.scale(
                    scale: _cardScale.value,
                    child: Opacity(
                      opacity: _cardFade.value,
                      child: child,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ── LOCK ICON ──
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              DoctorColors.primaryDeep.withOpacity(0.3),
                              DoctorColors.primaryAccent.withOpacity(0.15),
                            ],
                          ),
                          border: Border.all(
                            color: DoctorColors.primaryAccent.withOpacity(0.3),
                          ),
                        ),
                        child: const Icon(
                          Icons.lock_outline_rounded,
                          color: DoctorColors.primaryAccent,
                          size: 36,
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ── GLASS CARD ──
                      ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: Container(
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            color: DoctorColors.primaryBrand,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.12),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 30,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "OTP Verification",
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Enter the 6-digit code sent to\nyour mobile number",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.9),
                                  height: 1.5,
                                ),
                              ),

                              const SizedBox(height: 32),

                              // ── PINPUT ──
                              Pinput(
                                controller: controller.otpController,
                                keyboardType: TextInputType.number,
                                length: 6,
                                defaultPinTheme: defaultTheme,
                                focusedPinTheme: focusedTheme,
                                submittedPinTheme: submittedTheme,
                                onChanged: (_) =>
                                    controller.otpError.value = '',
                                cursor: Container(
                                  width: 2,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: DoctorColors.primary,
                                    borderRadius: BorderRadius.circular(1),
                                  ),
                                ),
                                showCursor: true,
                                separatorBuilder: (index) =>
                                    const SizedBox(width: 8),
                              ),

                              // ── OTP ERROR MESSAGE (outside the pin boxes) ──
                              Obx(() {
                                if (controller.otpError.value.isEmpty) {
                                  return const SizedBox(height: 32);
                                }
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      top: 14, bottom: 14),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.error_outline_rounded,
                                          color: Colors.redAccent, size: 16),
                                      const SizedBox(width: 5),
                                      Flexible(
                                        child: Text(
                                          controller.otpError.value,
                                          style: const TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),

                              // ── VERIFY BUTTON ──
                              GestureDetector(
                                onTap: controller.verifyOtp,
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    // gradient: const LinearGradient(
                                    //   colors: [
                                    //     Color(0xFF0473EA),
                                    //     Color(0xFF2196F3),
                                    //     DoctorColors.primaryAccent,
                                    //   ],
                                    // ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: DoctorColors.primaryDeep
                                            .withOpacity(0.4),
                                        blurRadius: 20,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Verify",


                                      style: TextStyle(
                                        color: DoctorColors.primary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              // ── RESEND ──
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Didn't receive the code? ",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.4),
                                      fontSize: 13,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      // Resend OTP logic
                                    },
                                    child: const Text(
                                      "Resend",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: DoctorColors.primaryAccent,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── LOADING OVERLAY ──
          Obx(() {
            if (!controller.isLoading.value) {
              return const SizedBox();
            }
            return Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.1)),
                  ),
                  child: const CircularProgressIndicator(
                    color: DoctorColors.primaryAccent,
                    strokeWidth: 3,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  FLOATING ORBS — OTP PAGE
// ══════════════════════════════════════════════════════════

class _OtpOrbsPainter extends CustomPainter {
  final double progress;
  _OtpOrbsPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final orbs = [
      _OtpOrb(0.2, 0.3, 100, DoctorColors.primaryDeep, 0.10),
      _OtpOrb(0.75, 0.2, 80, DoctorColors.primaryAccent, 0.08),
      _OtpOrb(0.5, 0.75, 130, DoctorColors.primaryDeep, 0.06),
      _OtpOrb(0.9, 0.6, 70, DoctorColors.blue500, 0.09),
    ];

    for (final orb in orbs) {
      final dx = orb.x * size.width +
          sin(progress * 2 * pi + orb.x * 12) * 25;
      final dy = orb.y * size.height +
          cos(progress * 2 * pi + orb.y * 10) * 20;

      final paint = Paint()
        ..color = orb.color.withOpacity(orb.opacity)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, orb.radius * 0.8);
      canvas.drawCircle(Offset(dx, dy), orb.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _OtpOrbsPainter old) => true;
}

class _OtpOrb {
  final double x, y, radius, opacity;
  final Color color;
  const _OtpOrb(this.x, this.y, this.radius, this.color, this.opacity);
}

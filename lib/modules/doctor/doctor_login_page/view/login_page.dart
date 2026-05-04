import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';
import 'package:timesmed_project/routes/app_routes.dart';
import '../controller/login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final LoginControllerctr = Get.put(LoginController());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isOtpLogin = true;
  bool obscurePassword = true;

  // Animations
  late final AnimationController _bgCtrl;
  late final AnimationController _cardCtrl;
  late final Animation<double> _cardSlide;
  late final Animation<double> _cardFade;

  @override
  void initState() {
    super.initState();

    // Background floating animation
    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    // Card entrance animation
    _cardCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _cardSlide = Tween<double>(begin: 60, end: 0).animate(
      CurvedAnimation(parent: _cardCtrl, curve: Curves.easeOutCubic),
    );
    _cardFade = Tween<double>(begin: 0, end: 1).animate(
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

    return Scaffold(
      body: Stack(
        children: [
          // ── GRADIENT BACKGROUND ──
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration:  BoxDecoration(
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

          // ── ANIMATED FLOATING ORBS ──
          AnimatedBuilder(
            animation: _bgCtrl,
            builder: (context, _) => CustomPaint(
              size: size,
              painter: _FloatingOrbsPainter(progress: _bgCtrl.value),
            ),
          ),

          // ── MAIN CONTENT ──
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: AnimatedBuilder(
                  animation: _cardCtrl,
                  builder: (context, child) => Transform.translate(
                    offset: Offset(0, _cardSlide.value),
                    child: Opacity(
                      opacity: _cardFade.value,
                      child: child,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ── LOGO ──
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.08),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                        child: SvgPicture.asset(
                          "assets/logos/svg/timesmed_logo.svg",
                          height: 70,
                          width: 70,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // ── GLASS CARD ──
                      ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: Container(
                            padding: const EdgeInsets.all(28),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(28),
                              color: AppColors.primary,
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
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Title
                                  const Text(
                                    "Welcome Back",
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "Sign in to continue",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white.withOpacity(0.6),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),

                                  const SizedBox(height: 28),

                                  // ── TOGGLE BUTTONS ──
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.4),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Row(
                                      children: [
                                        _toggleButton(
                                          "Mobile",
                                          Icons.phone_android_rounded,
                                          true,
                                        ),
                                        _toggleButton(
                                          "Email",
                                          Icons.email_rounded,
                                          false,
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 24),

                                  // ── INPUT FIELDS ──
                                  if (isOtpLogin) ...[
                                    _buildInputField(

                                      controller:
                                          LoginControllerctr.mobileController,
                                      hint: "Enter Mobile Number",
                                      icon: Icons.phone_rounded,
                                      // keyboardType: TextInputType.number,
                                      maxLength: 10,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Please enter mobile number";
                                        }
                                        return null;
                                      },
                                    ),
                                  ] else ...[
                                    _buildInputField(
                                      controller:
                                          LoginControllerctr.emailController,
                                      hint: "Enter Email",
                                      icon: Icons.email_rounded,
                                      validator: (value) {
                                        if (LoginControllerctr
                                            .emailController.text.isEmpty) {
                                          return "Please enter email";
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    _buildInputField(
                                      controller:
                                          LoginControllerctr.passwordController,
                                      hint: "Enter Password",
                                      icon: Icons.lock_rounded,
                                      obscureText: obscurePassword,
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            obscurePassword = !obscurePassword;
                                          });
                                        },
                                        icon: Icon(
                                          obscurePassword
                                              ? Icons.visibility_off_rounded
                                              : Icons.visibility_rounded,
                                          color: Colors.white.withOpacity(0.5),
                                          size: 20,
                                        ),
                                      ),
                                      validator: (value) {
                                        if (LoginControllerctr
                                            .passwordController.text.isEmpty) {
                                          return "Please enter password";
                                        }
                                        return null;
                                      },
                                    ),
                                  ],

                                  // Forgot Password
                                  if (!isOtpLogin) ...[
                                    const SizedBox(height: 8),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: () {},
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          minimumSize: Size.zero,
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        child: Text(
                                          "Forgot Password?",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],

                                  const SizedBox(height: 24),

                                  // ── LOGIN BUTTON ──
                                  _buildGradientButton(
                                    text: isOtpLogin ? "Send OTP" : "LOGIN",
                                    onPressed: () {
                                      if (isOtpLogin) {
                                        if (formKey.currentState!.validate()) {
                                          LoginControllerctr.sendOtp();
                                        }
                                        LoginControllerctr.mobileController
                                            .clear();
                                      } else {
                                        if (formKey.currentState!.validate()) {
                                          LoginControllerctr.loginWithEmail();
                                        }
                                        LoginControllerctr.emailController
                                            .clear();
                                        LoginControllerctr.passwordController
                                            .clear();
                                      }
                                    },
                                  ),

                                  const SizedBox(height: 20),

                                  // ── SIGN UP LINK ──
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Don't have an account? ",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          context
                                              .push(AppRoutes.patientSignup);
                                        },
                                        child: const Text(
                                          "Sign Up",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ── AI ASSISTANT BUBBLE ──
                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                ),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.08),
                                ),
                              ),
                              child: Text(
                                "How can I help you?",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF0473EA),
                                    Color(0xFF47A6FF),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: SvgPicture.asset(
                                "assets/icons/ai_robot.svg",
                                width: 22,
                                height: 22,
                                colorFilter: const ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ],
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
            if (!LoginControllerctr.isLoading.value) {
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
                    color: Color(0xFF47A6FF),
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

  // ── TOGGLE BUTTON ──
  Widget _toggleButton(String text, IconData icon, bool value) {
    final isActive = isOtpLogin == value;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            isOtpLogin = value;
            formKey.currentState?.reset();
            LoginControllerctr.mobileController.clear();
            LoginControllerctr.emailController.clear();
            LoginControllerctr.passwordController.clear();
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: isActive
                ? const LinearGradient(
                    colors: [Color(0xFF0473EA), Color(0xFF2196F3)],
                  )
                : null,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isActive
                    ? Colors.white
                    : Colors.white.withOpacity(0.4),
              ),
              const SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  color: isActive
                      ? Colors.white
                      : Colors.white.withOpacity(0.4),
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),

        /// 🎨 UPDATED BACKGROUND COLOR
        color:Colors.white,

        /// 🔵 BORDER
        border: Border.all(
          color: const Color(0xFF47A6FF).withOpacity(0.2),
        ),

        /// ✨ SHADOW (optional but nice)
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        // keyboardType: keyboardType,
        maxLength: maxLength,
        obscureText: obscureText,
        validator: validator,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          focusedBorder: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.black.withOpacity(0.5),

          ),
          prefixIcon: Icon(
            icon,
            color: const Color(0xFF47A6FF),
          ),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          counterText: '',
        ),
      ),
    );
  }

  // ── GRADIENT BUTTON ──
  Widget _buildGradientButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.green.shade300,
          // gradient: const LinearGradient(
          //   colors: [Color(0xFF0473EA), Color(0xFF2196F3), Color(0xFF47A6FF)],
          // ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0473EA).withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  FLOATING ORBS PAINTER — ambient background
// ══════════════════════════════════════════════════════════

class _FloatingOrbsPainter extends CustomPainter {
  final double progress;
  _FloatingOrbsPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final orbs = [
      _Orb(0.15, 0.2, 120, const Color(0xFF0473EA), 0.12),
      _Orb(0.8, 0.15, 90, const Color(0xFF2196F3), 0.08),
      _Orb(0.5, 0.7, 160, const Color(0xFF0473EA), 0.06),
      _Orb(0.85, 0.75, 100, const Color(0xFF47A6FF), 0.10),
      _Orb(0.3, 0.85, 80, const Color(0xFF6CBD4F), 0.05),
    ];

    for (final orb in orbs) {
      final dx = orb.x * size.width +
          sin(progress * 2 * pi + orb.x * 10) * 30;
      final dy = orb.y * size.height +
          cos(progress * 2 * pi + orb.y * 8) * 25;

      final paint = Paint()
        ..color = orb.color.withOpacity(orb.opacity)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, orb.radius * 0.8);
      canvas.drawCircle(Offset(dx, dy), orb.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _FloatingOrbsPainter old) => true;
}

class _Orb {
  final double x, y, radius, opacity;
  final Color color;
  const _Orb(this.x, this.y, this.radius, this.color, this.opacity);
}

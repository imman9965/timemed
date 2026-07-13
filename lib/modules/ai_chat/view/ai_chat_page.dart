import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';
import 'package:timesmed_project/core/widgets/title_Text_form_field.dart';

class AIChatPage extends StatefulWidget {
  final String userType; // 'patient' or 'doctor'

  const AIChatPage({super.key, this.userType = 'patient'});

  @override
  State<AIChatPage> createState() => _AIChatPageState();
}

class _AIChatPageState extends State<AIChatPage> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  bool isLoading = false;
  String selectedAppointmentType = 'Instant'; // or 'Schedule'
  String patientName = 'Pradeep'; // Replace with actual patient name

  int selectedCardIndex = -1;

  // Sample messages - replace with actual API calls
  final List<ChatMessage> messages = [
    ChatMessage(
      id: '1',
      text:
          'Hi  ! Tell me what you\'re experiencing and I\'ll help you get the appointment.',
      isUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
  ];

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (messageController.text.trim().isEmpty) return;

    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: messageController.text.trim(),
      isUser: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      messages.add(userMessage);
      isLoading = true;
    });

    messageController.clear();
    _scrollToBottom();

    // Simulate AI response delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        final aiMessage = ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: _generateAIResponse(userMessage.text),
          isUser: false,
          timestamp: DateTime.now(),
        );

        setState(() {
          messages.add(aiMessage);
          isLoading = false;
        });

        _scrollToBottom();
      }
    });
  }

  String _generateAIResponse(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();

    if (lowerMessage.contains('fever') ||
        lowerMessage.contains('temperature')) {
      return 'A fever is usually a sign that your body is fighting an infection. '
          'I recommend:\n\n'
          '• Rest and stay hydrated\n'
          '• Take paracetamol if needed\n'
          '• Monitor temperature regularly\n\n'
          'If fever persists beyond 3 days, please consult a doctor.';
    } else if (lowerMessage.contains('headache')) {
      return 'For headaches, try:\n\n'
          '• Rest in a quiet, dark room\n'
          '• Stay hydrated\n'
          '• Apply a cold compress\n'
          '• Consider over-the-counter pain relief\n\n'
          'If headaches are severe or frequent, consult a healthcare provider.';
    } else if (lowerMessage.contains('appointment') ||
        lowerMessage.contains('book')) {
      return 'You can book an appointment by:\n\n'
          '• Going to the "Appointments" section\n'
          '• Selecting your preferred doctor\n'
          '• Choosing an available time slot\n\n'
          'Would you like me to help you with that?';
    } else {
      return 'I\'m here to help! I can provide information about:\n\n'
          '• Common health symptoms\n'
          '• General wellness tips\n'
          '• Appointment booking\n'
          '• Medical guidance\n\n'
          'How can I assist you today?';
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // appBar: CommonAppBar(title: "MediBot", showBack: true),
      body: SafeArea(child: _buildChatView()),
    );
  }

  /// Chat View - Shows after chat starts
  Widget _buildChatView() {
    return Column(
      children: [
        /// 🔹 FULL SCROLLABLE CONTENT
        Expanded(
          child: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// HEADER
                _buildWelcomeHeader(),
                const SizedBox(height: 24),

                /// QUICK CARDS
                _buildQuickActionCards(),
                const SizedBox(height: 16),

                /// CHAT MESSAGES
                ...messages.map((msg) => _buildMessageBubble(msg)),

                /// TYPING
                if (isLoading) _buildTypingIndicator(),
              ],
            ),
          ),
        ),

        /// 🔹 INPUT FIXED AT BOTTOM
        _buildMessageInput(),
      ],
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    if (message.type == MessageType.appointmentType) {
      return _buildAppointmentTypeBubble(message);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: message.isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isUser) ...[
            Container(
              padding: const EdgeInsets.all(8),
              child: SvgPicture.asset(
                "assets/icons/ai_robot.svg",
                height: 20,
                width: 20,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: message.isUser ? const Color(0xff0673de) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: message.isUser
                    ? null
                    : Border.all(color: AppColors.border, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: message.isUser
                        ? const Color(0xff0673de).withOpacity(0.2)
                        : Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  fontSize: 14,
                  color: message.isUser ? Colors.white : AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          if (message.isUser) ...[
            Container(
              padding: const EdgeInsets.all(8),

              child: Icon(Icons.person_2_rounded),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: SvgPicture.asset(
              "assets/icons/ai_robot.svg",
              height: 20,
              width: 20,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border, width: 1),
            ),
            child: Row(
              children: [
                _buildTypingDot(),
                const SizedBox(width: 4),
                _buildTypingDot(),
                const SizedBox(width: 4),
                _buildTypingDot(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot() {
    return Container(
      width: 4,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.textSecondary,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight.withOpacity(0.2),
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TitleTextFormField(
              controller: messageController,
              borderRadius: 25,
              filled: true,
              fillColor: AppColors.white,
              hintText: "Type a message...",
              borderColor: AppColors.white,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xff0673de), Color(0xff2f6f7e)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hi, $patientName!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'How can I assist you today?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionCards() {
    return Column(
      children: [
        // First row - 2 cards
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                index: 1,
                icon: "assets/icons/stethoscope.svg",
                label: 'New Consult',
                subtitle: 'Describe symptoms',
                onTap: () {
                  final aiMessage = ChatMessage(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    text:
                        'Hi $patientName! Tell me what you\'re experiencing and I\'ll help you get the appointment.',
                    isUser: false,
                    timestamp: DateTime.now(),
                    type: MessageType.appointmentType,
                  );

                  setState(() {
                    messages.add(aiMessage);
                  });

                  _scrollToBottom();
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                index: 3,
                icon: "assets/icons/my_appointments.svg",
                label: 'My Appointments',
                subtitle: 'View Upcoming',
                onTap: () {
                  // Navigate to Appointments
                  Get.snackbar(
                    'Appointments',
                    'Opening your upcoming appointments...',
                    backgroundColor: Colors.blue,
                    colorText: Colors.white,
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Second row - 2 cards
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                index: 2,
                icon: "assets/icons/prescriptions.svg",
                label: 'Prescriptions',
                subtitle: 'View & refill',
                onTap: () {
                  // Navigate to Prescriptions
                  Get.snackbar(
                    'Prescriptions',
                    'Opening your prescriptions...',
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                index: 4,
                icon: "assets/icons/lab_reports.svg",
                label: 'Lab Reports',
                subtitle: 'Recent results',
                onTap: () {
                  // Navigate to Lab Reports
                  Get.snackbar(
                    'Lab Reports',
                    'Opening your recent lab results...',
                    backgroundColor: Colors.orange,
                    colorText: Colors.white,
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildQuickActionCard({
    required int index,
    required String icon,
    required String label,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    final isSelected = selectedCardIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCardIndex = index;
        });
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),

        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.7) // 🔵 selected color
              : Colors.white,

          borderRadius: BorderRadius.circular(12),

          border: Border.all(
            color: isSelected ? const Color(0xff0673de) : AppColors.border,
            width: 1,
          ),

          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? const Color(0xff0673de).withOpacity(0.25)
                  : Colors.black.withOpacity(0.1),
              blurRadius: isSelected ? 12 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Row(
          children: [
            SvgPicture.asset(icon, height: 30, width: 30),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColors.white
                          : AppColors.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected
                            ? AppColors.white
                            : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentTypeBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: message.isUser ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// AI TEXT
            _buildNormalBubble(message),

            const SizedBox(height: 10),

            /// TITLE
            Text(
              "Appointment Type",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            /// OPTIONS
            Row(
              children: [
                _appointmentOption("Instant"),
                const SizedBox(width: 14),
                _appointmentOption("Schedule"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _appointmentOption(String type) {
    final isSelected = selectedAppointmentType == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAppointmentType = type;
        });

        /// Add user selection message
        final userMsg = ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: type,
          isUser: true,
          timestamp: DateTime.now(),
        );

        messages.add(userMsg);

        /// If schedule → ask date
        if (type == "Schedule") {
          Future.delayed(const Duration(milliseconds: 500), () {
            setState(() {
              messages.add(
                ChatMessage(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  text: "Please enter your preferred appointment date.",
                  isUser: false,
                  timestamp: DateTime.now(),
                ),
              );
            });
            _scrollToBottom();
          });
        }

        _scrollToBottom();
      },
      child: Row(
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.transparent,
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            child: Center(
              child: Icon(
                isSelected ? Icons.check : null,
                size: isSelected ? 12 : 0,
                color: isSelected ? AppColors.primary : AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(type, style: TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildNormalBubble(ChatMessage message) {
    return Row(
      mainAxisAlignment: message.isUser
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            message.text,
            style: TextStyle(
              color: message.isUser ? Colors.white : Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}

enum MessageType { text, appointmentType }

class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final MessageType type;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.type = MessageType.text,
  });
}

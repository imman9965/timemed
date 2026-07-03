import 'package:flutter/material.dart';
import 'package:timesmed_project/modules/doctor/theme/doctor_theme.dart';
import 'package:timesmed_project/core/widgets/common/curved_header.dart';
import 'widgets/request_card.dart';

class RequestScreen extends StatelessWidget {
  const RequestScreen({super.key});

  final List<Map<String, String>> requests = const [
    {
      "name": "Vignesh",
      "id": "313311",
      "type": "Instant Call",
      "time": "2 min ago",
    },
    {
      "name": "Arun Kumar",
      "id": "215478",
      "type": "Video Consultation",
      "time": "5 min ago",
    },
    {
      "name": "Priya Sharma",
      "id": "198745",
      "type": "Instant Call",
      "time": "12 min ago",
    },
    {
      "name": "Rajesh M",
      "id": "302156",
      "type": "Follow-up Call",
      "time": "20 min ago",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DoctorColors.backgroundCool,
      body: Column(
        children: [
          const CurvedHeader(title: 'INSTANT CALL REQUEST'),

          Expanded(
            child: requests.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      final item = requests[index];
                      return TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: Duration(milliseconds: 400 + (index * 100)),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(0, 30 * (1 - value)),
                            child: Opacity(
                              opacity: value,
                              child: child,
                            ),
                          );
                        },
                        child: RequestCard(
                          name: item['name']!,
                          patientId: item['id']!,
                          requestType: item['type']!,
                          time: item['time']!,
                          onAccept: () {
                            // TODO: Handle accept
                          },
                          onReject: () {
                            // TODO: Handle reject
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.phone_disabled_rounded,
            size: 72,
            color: DoctorColors.avatarGrey.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'No pending requests',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: DoctorColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'New call requests will appear here',
            style: TextStyle(
              fontSize: 14,
              color: DoctorColors.textHint,
            ),
          ),
        ],
      ),
    );
  }
}

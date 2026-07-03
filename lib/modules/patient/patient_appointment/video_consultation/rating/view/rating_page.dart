import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';
import 'package:timesmed_project/core/widgets/common_app_bar.dart';
import 'package:timesmed_project/core/widgets/common_elevate_button.dart';
import 'package:timesmed_project/routes/app_routes.dart';

class RatingPage extends StatefulWidget {
  const RatingPage({super.key});

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  int rating = 0;
  final TextEditingController _controller = TextEditingController();

  String get ratingText {
    switch (rating) {
      case 1:
        return "Very Poor";
      case 2:
        return "Poor";
      case 3:
        return "Average";
      case 4:
        return "Good";
      case 5:
        return "Excellent";
      default:
        return "Select your rating";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Rate Your Experience"),
      backgroundColor: const Color(0xFFF7F9FC),
      body: Column(
        children: [
          const SizedBox(height: 20),

          /// 🧑‍⚕️ Doctor Name Section
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(color: Colors.grey.shade200, blurRadius: 10),
              ],
            ),
            child: const Row(
              children: [
                Icon(Icons.local_hospital, color: Colors.blue),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Dr. John Doe",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          /// Title
          const Text(
            "How was your consultation?",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 10),

          /// Rating Text
          Text(
            ratingText,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),

          const SizedBox(height: 20),

          /// ⭐ Star Rating
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final isSelected = index < rating;

              return GestureDetector(
                onTap: () {
                  setState(() => rating = index + 1);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  transform: Matrix4.identity()..scale(isSelected ? 1.15 : 1.0),
                  child: Icon(
                    Icons.star,
                    size: 34,
                    color: isSelected ? Colors.orange : Colors.grey.shade400,
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 30),

          /// ✍️ Feedback Box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _controller,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Write your feedback (optional)",
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.all(16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const Spacer(),

          /// 🚀 Submit Button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CommonButton(
              color: AppColors.primary,
              title: "Submit",
              onPressed: () {
                if (rating == 0) {
                  null;
                } else {
                  context.go(AppRoutes.patientHome);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

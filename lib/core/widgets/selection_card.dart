import 'package:flutter/material.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';

class SelectionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectionCard({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          padding: const EdgeInsets.symmetric(vertical: 16),

          decoration: BoxDecoration(
            color: isSelected ? const Color(0xffE6F7F1) : Colors.white,

            borderRadius: BorderRadius.circular(16),

            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.grey.shade300,
              width: 1.5,
            ),

            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
            ],
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 28,
                color: isSelected ? const Color(0xff0f674a) : Colors.orange,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: isSelected ? const Color(0xff0f674a) : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

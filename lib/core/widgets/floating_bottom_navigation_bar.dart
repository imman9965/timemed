import 'package:flutter/material.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';

class FloatingBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final List<IconData> icons;
  final Function(int) onTap;
  final double borderRadius;
  final double height;
  final Color backgroundColor;
  final Color selectedColor;
  final Color unselectedColor;

  const FloatingBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.icons,
    required this.onTap,
    this.borderRadius = 30,
    this.height = 65,
    this.backgroundColor = AppColors.primary,
    this.selectedColor = Colors.white,
    this.unselectedColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          height: height,
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(icons.length, (index) {
              bool isSelected = index == currentIndex;

              return GestureDetector(
                onTap: () => onTap(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: EdgeInsets.symmetric(
                    horizontal: isSelected ? 18 : 10,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? selectedColor.withOpacity(0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Icon(
                    icons[index],
                    color: isSelected ? selectedColor : unselectedColor,
                    size: isSelected ? 30 : 26,
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

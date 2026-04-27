import 'package:flutter/material.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';

class FloatingBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final List<String> label;
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
    required this.label,
    required this.icons,
    required this.onTap,
    this.borderRadius = 40,
    this.height = 80,
    this.backgroundColor = AppColors.primary,
    this.selectedColor = AppColors.white,
    this.unselectedColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(icons.length, (index) {
              bool isSelected = index == currentIndex;

              return GestureDetector(
                onTap: () => onTap(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// ICON
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? selectedColor
                              : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          icons[index],
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.white,
                          size: isSelected ? 26 : 22,
                        ),
                      ),

                      const SizedBox(height: 4),

                      /// LABEL (SAFE + RESPONSIVE)
                      Flexible(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: isSelected
                              ? const SizedBox.shrink()
                              : FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    label[index],
                                    key: ValueKey(index),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ],
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

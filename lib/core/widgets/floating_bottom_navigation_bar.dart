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
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
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
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(
                          icons[index],
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.white,
                          size: isSelected ? 28 : 24,
                        ),
                      ),

                      /// LABEL (only when NOT selected)
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: isSelected
                            ? const SizedBox.shrink()
                            : Text(
                                label[index], // 👈 dynamic label
                                key: ValueKey(index),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
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

  // /// 👇 Add this method for labels
  // String _getLabel(int index) {
  //   switch (index) {
  //     case 0:
  //       return "Home";
  //     case 1:
  //       return "Search";
  //     case 2:
  //       return "Profile";
  //     default:
  //       return "";
  //   }
  // }
}

// import 'package:flutter/material.dart';
// import 'package:timesmed_project/core/constants/app_colors.dart';
//
// class FloatingBottomNavigationBar extends StatelessWidget {
//   final int currentIndex;
//   final List<IconData> icons;
//   final Function(int) onTap;
//   final double borderRadius;
//   final double height;
//   final Color backgroundColor;
//   final Color selectedColor;
//   final Color unselectedColor;
//
//   const FloatingBottomNavigationBar({
//     super.key,
//     required this.currentIndex,
//     required this.icons,
//     required this.onTap,
//     this.borderRadius = 30,
//     this.height = 65,
//     this.backgroundColor = AppColors.primary,
//     this.selectedColor = Colors.white,
//     this.unselectedColor = Colors.black,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//
//
//     return SafeArea(
//       child: Padding(
//         padding: const EdgeInsets.only(bottom: 16),
//         child: Align(
//           alignment: Alignment.bottomCenter,
//           child: Container(
//             height: height,
//             padding: const EdgeInsets.symmetric(horizontal: 12), // 👈 important
//             decoration: BoxDecoration(
//               color: backgroundColor,
//               borderRadius: BorderRadius.circular(borderRadius),
//               boxShadow: const [
//                 BoxShadow(color: Colors.black26, blurRadius: 10),
//               ],
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min, // 👈 key fix
//               children: List.generate(icons.length, (index) {
//                 bool isSelected = index == currentIndex;
//
//                 return GestureDetector(
//                   onTap: () => onTap(index),
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 300),
//                     margin: const EdgeInsets.symmetric(
//                       horizontal: 4,
//                     ), // 👈 spacing control
//                     padding: EdgeInsets.symmetric(
//                       horizontal: isSelected ? 16 : 10,
//                       vertical: 10,
//                     ),
//                     decoration: BoxDecoration(
//                       color: isSelected
//                           ? selectedColor.withOpacity(0.2)
//                           : Colors.transparent,
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                     child: Icon(
//                       icons[index],
//                       color: isSelected ? selectedColor : unselectedColor,
//                       size: isSelected ? 28 : 24,
//                     ),
//                   ),
//                 );
//               }),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

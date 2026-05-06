// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import '../../../core/constants/app_colors.dart';
//
// class CurvedHeader extends StatelessWidget {
//   final String title;
//   const CurvedHeader({Key? key, required this.title}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       decoration: const BoxDecoration(
//         color: AppColors.primary1,
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(28),
//           bottomRight: Radius.circular(28),
//         ),
//       ),
//       padding: EdgeInsets.only(
//         top: MediaQuery.of(context).padding.top + 14,
//         bottom: 18,
//       ),
//       child: Text(
//         title,
//         textAlign: TextAlign.center,
//         style: const TextStyle(
//           color: Colors.white,
//           fontWeight: FontWeight.w700,
//           fontSize: 20,
//           letterSpacing: 0.3,
//         ),
//       ),
//     );
//   }
// }

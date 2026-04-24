import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

/// Blue pill tag with a dismiss icon — matches the Specialisation &
/// Language chips on the Doctor Basic Details screen.
class ChipTag extends StatelessWidget {
  const ChipTag({
    super.key,
    required this.label,
    this.onRemove,
    this.color = AppColors.primaryBlue,
  });

  final String label;
  final VoidCallback? onRemove;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 6, 6, 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: const CircleAvatar(
              radius: 9,
              backgroundColor: Colors.white,
              child: Icon(Icons.close, size: 12, color: AppColors.primaryBlue),
            ),
          ),
        ],
      ),
    );
  }
}

/// Segmented selector — used for Gender (Male / Female / Others).
class SegmentedSelector extends StatelessWidget {
  const SegmentedSelector({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < options.length; i++) ...[
          _SegmentButton(
            label: options[i],
            selected: i == selectedIndex,
            onTap: () => onChanged(i),
          ),
          if (i != options.length - 1) const SizedBox(width: 10),
        ],
      ],
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primaryBlue : AppColors.inputBg,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

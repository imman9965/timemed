import 'package:flutter/material.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';
import 'package:timesmed_project/core/widgets/radio_selection_dialog.dart';

/// A tappable dropdown field that opens a [RadioSelectionDialog].
///
/// Looks exactly like the app's standard dropdown fields (rounded border,
/// hint text, trailing arrow icon) and pops the full-screen radio dialog
/// on tap.
///
/// Usage:
/// ```dart
/// RadioDropdownField<String>(
///   hint: 'Department',
///   dialogTitle: 'PLEASE SELECT DEPARTMENT FIRST',
///   items: ['Hematology', 'Biochemistry', 'Microbiology'],
///   labelBuilder: (item) => item,
///   value: selectedDepartment,
///   onChanged: (val) => setState(() => selectedDepartment = val),
/// )
/// ```
class RadioDropdownField<T> extends StatelessWidget {
  /// Hint text shown when nothing is selected
  final String hint;

  /// Title shown in the dialog header
  final String dialogTitle;

  /// All selectable items
  final List<T> items;

  /// Converts an item to display text
  final String Function(T item) labelBuilder;

  /// Currently selected value
  final T? value;

  /// Called when user selects and submits
  final ValueChanged<T?> onChanged;

  /// Submit button label in the dialog
  final String submitText;

  /// Whether the dialog shows a search bar
  final bool searchable;

  /// Search bar hint text
  final String searchHint;

  /// Optional group-by function for sectioned lists
  final String Function(T item)? groupBy;

  /// Field border radius
  final double borderRadius;

  /// Field background color
  final Color? fillColor;

  /// Whether the field is enabled
  final bool enabled;

  /// Optional validator for form integration
  final String? Function(T?)? validator;

  const RadioDropdownField({
    super.key,
    required this.hint,
    required this.dialogTitle,
    required this.items,
    required this.labelBuilder,
    required this.onChanged,
    this.value,
    this.submitText = 'Submit',
    this.searchable = false,
    this.searchHint = 'Search...',
    this.groupBy,
    this.borderRadius = 10,
    this.fillColor,
    this.enabled = true,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null;
    final displayText = hasValue ? labelBuilder(value as T) : hint;

    return GestureDetector(
      onTap: enabled ? () => _openDialog(context) : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: fillColor ?? Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: AppColors.border,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                displayText,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: hasValue ? FontWeight.w500 : FontWeight.w400,
                  color: hasValue
                      ? AppColors.textDark
                      : AppColors.textHint,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: enabled
                  ? AppColors.textSecondary
                  : AppColors.disabled,
              size: 26,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openDialog(BuildContext context) async {
    final result = await RadioSelectionDialog.show<T>(
      context: context,
      title: dialogTitle,
      items: items,
      labelBuilder: labelBuilder,
      initialValue: value,
      submitText: submitText,
      groupBy: groupBy,
      searchable: searchable,
      searchHint: searchHint,
    );

    if (result != null) {
      onChanged(result);
    }
  }
}

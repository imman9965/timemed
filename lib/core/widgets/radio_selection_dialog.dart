import 'package:flutter/material.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';

/// A reusable full-screen radio-selection dialog that matches the app's design.
///
/// Usage:
/// ```dart
/// final result = await RadioSelectionDialog.show<String>(
///   context: context,
///   title: 'PLEASE SELECT DEPARTMENT FIRST',
///   items: ['Hematology', 'Biochemistry', 'Microbiology'],
///   labelBuilder: (item) => item,
///   initialValue: selectedDepartment,
/// );
/// if (result != null) {
///   setState(() => selectedDepartment = result);
/// }
/// ```
class RadioSelectionDialog<T> extends StatefulWidget {
  /// Dialog header title
  final String title;

  /// List of selectable items
  final List<T> items;

  /// Converts an item to its display label
  final String Function(T item) labelBuilder;

  /// Currently selected value (if any)
  final T? initialValue;

  /// Submit button text
  final String submitText;

  /// Optional: group items by a key (renders section headers)
  final String Function(T item)? groupBy;

  /// Whether to allow search/filter
  final bool searchable;

  /// Search hint text
  final String searchHint;

  const RadioSelectionDialog({
    super.key,
    required this.title,
    required this.items,
    required this.labelBuilder,
    this.initialValue,
    this.submitText = 'Submit',
    this.groupBy,
    this.searchable = false,
    this.searchHint = 'Search...',
  });

  /// Convenience static method to show the dialog and return the selected value.
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required List<T> items,
    required String Function(T item) labelBuilder,
    T? initialValue,
    String submitText = 'Submit',
    String Function(T item)? groupBy,
    bool searchable = false,
    String searchHint = 'Search...',
  }) {
    return showDialog<T>(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => RadioSelectionDialog<T>(
        title: title,
        items: items,
        labelBuilder: labelBuilder,
        initialValue: initialValue,
        submitText: submitText,
        groupBy: groupBy,
        searchable: searchable,
        searchHint: searchHint,
      ),
    );
  }

  @override
  State<RadioSelectionDialog<T>> createState() =>
      _RadioSelectionDialogState<T>();
}

class _RadioSelectionDialogState<T> extends State<RadioSelectionDialog<T>> {
  T? _selected;
  late List<T> _filteredItems;
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selected = widget.initialValue;
    _filteredItems = widget.items;
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.items;
      } else {
        _filteredItems = widget.items
            .where((item) => widget
                .labelBuilder(item)
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.06,
        vertical: screenHeight * 0.06,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: screenHeight * 0.85),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Header ──
            _buildHeader(),

            // ── Search bar (optional) ──
            if (widget.searchable) _buildSearchBar(),

            // ── Radio list ──
            Flexible(child: _buildRadioList()),

            // ── Submit button ──
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2ECC71), Color(0xFF27AE60)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: TextField(
        controller: _searchCtrl,
        onChanged: _onSearch,
        decoration: InputDecoration(
          hintText: widget.searchHint,
          hintStyle: TextStyle(color: AppColors.textHint, fontSize: 14),
          prefixIcon:
              Icon(Icons.search, color: AppColors.textSecondary, size: 20),
          filled: true,
          fillColor: AppColors.background,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                BorderSide(color: AppColors.primary.withOpacity(0.4), width: 1),
          ),
        ),
      ),
    );
  }

  Widget _buildRadioList() {
    if (_filteredItems.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Text(
            'No items found',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 15,
            ),
          ),
        ),
      );
    }

    // If groupBy is provided, render grouped sections
    if (widget.groupBy != null) {
      return _buildGroupedList();
    }

    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 4),
      itemCount: _filteredItems.length,
      separatorBuilder: (_, __) => const Divider(height: 1, thickness: 0.5),
      itemBuilder: (context, index) {
        final item = _filteredItems[index];
        final isSelected = _selected == item;
        return _buildRadioTile(item, isSelected);
      },
    );
  }

  Widget _buildGroupedList() {
    final Map<String, List<T>> groups = {};
    for (final item in _filteredItems) {
      final key = widget.groupBy!(item);
      groups.putIfAbsent(key, () => []).add(item);
    }

    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 4),
      children: groups.entries.expand((entry) {
        return [
          // Section header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
            child: Text(
              entry.key,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
                letterSpacing: 0.8,
              ),
            ),
          ),
          // Items in this group
          ...entry.value.map((item) {
            final isSelected = _selected == item;
            return Column(
              children: [
                _buildRadioTile(item, isSelected),
                const Divider(height: 1, thickness: 0.5),
              ],
            );
          }),
        ];
      }).toList(),
    );
  }

  Widget _buildRadioTile(T item, bool isSelected) {
    final label = widget.labelBuilder(item);

    return InkWell(
      onTap: () => setState(() => _selected = item),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Custom radio circle
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.disabled,
                  width: isSelected ? 2.0 : 1.5,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  : null,
            ),

            const SizedBox(width: 16),

            // Label
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? AppColors.textDark
                      : AppColors.textDark.withOpacity(0.85),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: _selected != null
              ? () => Navigator.of(context).pop(_selected)
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF5C518),
            disabledBackgroundColor: const Color(0xFFF5C518).withOpacity(0.5),
            foregroundColor: AppColors.textDark,
            disabledForegroundColor: AppColors.textDark.withOpacity(0.4),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            widget.submitText,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}

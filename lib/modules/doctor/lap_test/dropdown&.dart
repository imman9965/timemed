import 'package:flutter/material.dart';

/// A modal dialog that lists tests with multi-select circles.
/// Returns the selected list via Navigator.pop, or null if cancelled.
class TestSelectionDialog extends StatefulWidget {
  final List<String> availableTests;
  final List<String> initiallySelected;

  const TestSelectionDialog({
    super.key,
    required this.availableTests,
    this.initiallySelected = const [],
  });

  @override
  State<TestSelectionDialog> createState() => _TestSelectionDialogState();
}

class _TestSelectionDialogState extends State<TestSelectionDialog> {
  // ---------- Theme ----------
  static const Color _primaryDark = Color(0xFF1E5FBF);
  static const Color _primary = Color(0xFF2F7BE0);
  static const Color _primaryLight = Color(0xFF5EA1F0);
  static const Color _cardWhite = Colors.white;
  static const Color _divider = Color(0xFFE5EAF2);
  static const Color _textPrimary = Color(0xFF1A2236);
  static const Color _circleBorder = Color(0xFFB0BFD4);

  late final Set<String> _selected;
  late final TextEditingController _searchController;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _selected = widget.initiallySelected.toSet();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> get _filteredTests {
    if (_query.trim().isEmpty) return widget.availableTests;
    final q = _query.toLowerCase();
    return widget.availableTests
        .where((t) => t.toLowerCase().contains(q))
        .toList();
  }

  void _toggle(String test) {
    setState(() {
      if (_selected.contains(test)) {
        _selected.remove(test);
      } else {
        _selected.add(test);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: size.height * 0.82,
          maxWidth: 480,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: _cardWhite,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              _buildSearchBar(),
              Flexible(child: _buildList()),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- Header ----------
  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [_primaryDark, _primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'PLEASE SELECT TEST',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  // ---------- Search ----------
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
      child: TextField(
        controller: _searchController,
        onChanged: (v) => setState(() => _query = v),
        style: const TextStyle(fontSize: 15, color: _textPrimary),
        decoration: InputDecoration(
          hintText: 'Search tests...',
          hintStyle: const TextStyle(color: _circleBorder, fontSize: 15),
          prefixIcon: const Icon(Icons.search, color: _circleBorder, size: 20),
          isDense: true,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _divider),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _divider),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _primary, width: 1.5),
          ),
        ),
      ),
    );
  }

  // ---------- List ----------
  Widget _buildList() {
    final tests = _filteredTests;
    if (tests.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Text(
            'No matching tests',
            style: TextStyle(color: _circleBorder, fontSize: 14),
          ),
        ),
      );
    }
    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 4),
      itemCount: tests.length,
      separatorBuilder: (_, __) => const Divider(
        color: _divider,
        height: 1,
        indent: 16,
        endIndent: 16,
      ),
      itemBuilder: (_, i) {
        final test = tests[i];
        final isSelected = _selected.contains(test);
        return InkWell(
          onTap: () => _toggle(test),
          child: Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                _circleCheck(isSelected),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    test,
                    style: TextStyle(
                      fontSize: 15,
                      color: _textPrimary,
                      fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _circleCheck(bool selected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? _primary : Colors.transparent,
        border: Border.all(
          color: selected ? _primary : _circleBorder,
          width: 1.5,
        ),
      ),
      child: selected
          ? const Icon(Icons.check, size: 14, color: Colors.white)
          : null,
    );
  }

  // ---------- Submit ----------
  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).pop(_selected.toList()),
          style: ElevatedButton.styleFrom(
            backgroundColor: _primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
          ),
          child: Text(
            _selected.isEmpty ? 'Submit' : 'Submit (${_selected.length})',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

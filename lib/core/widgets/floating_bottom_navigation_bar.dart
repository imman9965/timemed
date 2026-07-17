import 'package:flutter/material.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';

/// Pill-style floating bottom navigation bar.
///
/// Horizontally scrollable (like the doctor module's `CalendarBottomNav`):
/// labels keep a single, uniform font size and the bar scrolls instead of
/// overflowing when the items don't all fit on screen. The active item sits
/// inside a white pill; inactive items show a white icon + label.
class FloatingBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final List<String> label;
  final List<IconData> icons;

  /// Optional PNG icon asset paths (doctor-module approach). When an entry is
  /// a non-empty path, that image is rendered; otherwise the matching
  /// [icons] entry is used as a fallback.
  final List<String> iconPaths;
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
    this.iconPaths = const [],
    this.borderRadius = 50,
    this.height = 74,
    this.backgroundColor = AppColors.primary,
    this.selectedColor = AppColors.white,
    this.unselectedColor = AppColors.white,
  });

  @override
  State<FloatingBottomNavigationBar> createState() =>
      _FloatingBottomNavigationBarState();
}

class _FloatingBottomNavigationBarState
    extends State<FloatingBottomNavigationBar> {
  late final ScrollController _scrollController;

  // Approximate width of one item, used only to bring the active tab
  // into view — the layout itself is content-sized, not fixed.
  static const double _itemWidth = 92.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToActive());
  }

  @override
  void didUpdateWidget(covariant FloatingBottomNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _scrollToActive();
    }
  }

  void _scrollToActive() {
    if (!_scrollController.hasClients) return;
    final screenWidth = MediaQuery.of(context).size.width - 32;
    final target =
        (widget.currentIndex * _itemWidth) - (screenWidth / 2) + (_itemWidth / 2);
    _scrollController.animateTo(
      target.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(13, 0, 13, 28),
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        boxShadow: [
          BoxShadow(
            color: widget.backgroundColor.withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: ScrollConfiguration(
          behavior: _NoGlowScrollBehavior(),
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: List.generate(widget.icons.length, (index) {
                final active = index == widget.currentIndex;
                final iconPath = index < widget.iconPaths.length
                    ? widget.iconPaths[index]
                    : '';
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => widget.onTap(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.bounceInOut,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    padding: active
                        ? const EdgeInsets.symmetric(horizontal: 14, vertical: 6)
                        : const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: active ? widget.selectedColor : Colors.transparent,
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (iconPath.isNotEmpty)
                          Image.asset(
                            iconPath,
                            width: 22,
                            height: 22,
                            color: active
                                ? widget.backgroundColor
                                : widget.unselectedColor,
                          )
                        else
                          Icon(
                            widget.icons[index],
                            size: 22,
                            color: active
                                ? widget.backgroundColor
                                : widget.unselectedColor,
                          ),
                        const SizedBox(height: 2),
                        Text(
                          widget.label[index],
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.visible,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight:
                                active ? FontWeight.w600 : FontWeight.w500,
                            color: active
                                ? widget.backgroundColor
                                : widget.unselectedColor,
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
      ),
    );
  }
}

/// Removes the overscroll glow so the horizontal scroll looks clean.
class _NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

import 'package:flutter/material.dart';

class ThemeSwitcher extends StatelessWidget {
  final bool isDarkMode;
  final Function(bool) onToggle;

  const ThemeSwitcher({
    super.key,
    required this.isDarkMode,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onToggle(!isDarkMode),
      child: Container(
        width: 70,
        height: 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        child: Stack(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Icon(Icons.wb_sunny_rounded,
                    color: Colors.orange, size: 18),
              ),
            ),
            const Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Icon(Icons.nightlight_round,
                    color: Colors.yellow, size: 18),
              ),
            ),
            // Hareket eden daire
            AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment:
                  isDarkMode ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).cardColor,
                    border: Border.all(
                        color: Theme.of(context).dividerColor, width: 2)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

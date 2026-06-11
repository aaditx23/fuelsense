import 'package:flutter/material.dart';

class EntryTypeCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool selected;
  final bool disabled;
  final VoidCallback onTap;

  const EntryTypeCard({
    Key? key,
    required this.label,
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
    this.disabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // Selected+disabled: show muted colour. Unselected+disabled: greyed out.
    final effectiveColor = (disabled && selected)
        ? color.withValues(alpha: 0.5)
        : disabled
        ? colorScheme.onSurface.withValues(alpha: 0.3)
        : color;

    return Expanded(
      child: GestureDetector(
        onTap: disabled ? null : onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            color: selected
                ? color.withValues(alpha: disabled ? 0.06 : 0.12)
                : colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected
                  ? color.withValues(alpha: disabled ? 0.4 : 1.0)
                  : colorScheme.outlineVariant.withValues(
                      alpha: disabled ? 0.4 : 1.0,
                    ),
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: effectiveColor, size: 26),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: effectiveColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 2),
            ],
          ),
        ),
      ),
    );
  }
}

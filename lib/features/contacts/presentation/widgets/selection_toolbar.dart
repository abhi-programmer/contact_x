import 'package:flutter/material.dart';

class SelectionToolbar extends StatelessWidget {
  final int selectedCount;
  final int totalCount;

  final VoidCallback onClose;
  final VoidCallback onSelectAll;
  final VoidCallback onAction;

  final IconData actionIcon;
  final String actionTooltip;

  const SelectionToolbar({
    super.key,
    required this.selectedCount,
    required this.totalCount,
    required this.onClose,
    required this.onSelectAll,
    required this.onAction,
    required this.actionIcon,
    required this.actionTooltip,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      elevation: 3,
      color: colorScheme.surface,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              IconButton(onPressed: onClose, icon: const Icon(Icons.close)),

              Text(
                "$selectedCount/$totalCount selected",
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),

              const Spacer(),

              IconButton.filledTonal(
                onPressed: onSelectAll,
                icon: const Icon(Icons.select_all),
                tooltip: "Select All",
              ),

              const SizedBox(width: 8),

              IconButton.filledTonal(
                onPressed: onAction,
                icon: Icon(actionIcon),
                tooltip: actionTooltip,
              ),

              const SizedBox(width: 16),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:contact_x/features/contacts/domain/entities/contact.dart';
import 'package:flutter/material.dart';

class ContactCard extends StatelessWidget {
  final Contact contact;
  final bool isSelected;
  final bool selectionMode;

  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const ContactCard({
    super.key,
    required this.contact,
    required this.isSelected,
    required this.selectionMode,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutBack,
        scale: isSelected ? 0.97 : 1,
        child: Card(
          elevation: isSelected ? 2 : 0,
          margin: EdgeInsets.zero,
          color: Color.lerp(
            colorScheme.surfaceContainer,
            colorScheme.primaryContainer,
            isSelected ? 1 : 0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isSelected ? colorScheme.primary : Colors.transparent,
              width: 2,
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),

            /// Avatar
            leading: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              switchInCurve: Curves.easeOutBack,
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: animation,
                  child: FadeTransition(opacity: animation, child: child),
                );
              },

              child: isSelected
                  ? CircleAvatar(
                      key: ValueKey("selected_${contact.id}"),
                      backgroundColor: colorScheme.primary,
                      child: const Icon(Icons.check, color: Colors.white),
                    )
                  : CircleAvatar(
                      key: ValueKey(contact.id),
                      radius: 26,
                      child: Text(
                        contact.fullName.isNotEmpty
                            ? contact.fullName[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
            ),

            /// Name
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    contact.fullName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),

                if (contact.isFavourite)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.favorite, size: 14, color: Colors.red),
                        SizedBox(width: 4),
                        Text(
                          "Favourite",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            /// Phone
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                contact.phone,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            /// Checkbox
            trailing: selectionMode
                ? Checkbox(value: isSelected, onChanged: (_) {})
                : const Icon(Icons.chevron_right_rounded),
          ),
        ),
      ),
    );
  }
}

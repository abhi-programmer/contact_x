import 'package:contact_x/screens/contacts/contact_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import 'package:contact_x/controllers/contact_controller.dart';
import 'package:contact_x/screens/contacts/add_edit_contacts.dart';

class FavouriteContactsScreen extends StatefulWidget {
  const FavouriteContactsScreen({super.key});

  @override
  State<FavouriteContactsScreen> createState() =>
      _FavouriteContactsScreenState();
}

class _FavouriteContactsScreenState extends State<FavouriteContactsScreen> {
  final ContactController contactController = Get.find<ContactController>();

  bool _selectionMode = false;
  final Set<int> _selectedIndexes = {};

  void _toggleSelection(int index) {
    setState(() {
      if (_selectedIndexes.contains(index)) {
        _selectedIndexes.remove(index);
      } else {
        _selectedIndexes.add(index);
      }

      _selectionMode = _selectedIndexes.isNotEmpty;
    });
  }

  void _startSelection(int index) {
    setState(() {
      _selectionMode = true;
      _selectedIndexes.add(index);
    });
  }

  void _clearSelection() {
    setState(() {
      _selectionMode = false;
      _selectedIndexes.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final colorScheme = Theme.of(context).colorScheme;

      final contacts = [...contactController.favouriteContacts];

      if (contacts.isEmpty) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.favorite_border,
                size: 64,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              const Text(
                "No Favourite Contacts",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                "Add contacts to favourites to see them here.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        );
      }

      return Stack(
        children: [
          AnimatedPadding(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            padding: EdgeInsets.only(top: _selectionMode ? 76 : 0),
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                final isSelected = _selectedIndexes.contains(index);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Slidable(
                    enabled: !_selectionMode,
                    key: ValueKey(contact.id),

                    startActionPane: ActionPane(
                      motion: const StretchMotion(),
                      dismissible: DismissiblePane(
                        onDismissed: () async {
                          await FlutterPhoneDirectCaller.callNumber(
                            contact.phone,
                          );
                        },
                      ),
                      children: [
                        SlidableAction(
                          onPressed: (_) async {
                            await FlutterPhoneDirectCaller.callNumber(
                              contact.phone,
                            );
                          },
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          icon: Icons.call,
                          label: 'Call',
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ],
                    ),

                    endActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      extentRatio: 0.5,

                      children: [
                        SlidableAction(
                          onPressed: (_) async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddEditContactScreen(
                                  isEdit: true,
                                  contactId: contact.id,
                                  firstName: contact.firstName,
                                  lastName: contact.lastName,
                                  company: contact.company,
                                  jobTitle: contact.jobTitle,
                                  email: contact.email,
                                  phone: contact.phone,
                                  notes: contact.notes,
                                  isFavourite: contact.isFavourite,
                                ),
                              ),
                            );
                          },
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: 'Edit',
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                        ),
                        SlidableAction(
                          onPressed: (_) async {
                            await contactController.toggleFavourite(contact);
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.favorite_border,
                          label: 'Remove',
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                      ],
                    ),

                    child: GestureDetector(
                      onLongPress: () => _startSelection(index),
                      onTap: () {
                        if (_selectionMode) {
                          _toggleSelection(index);
                          return;
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ContactDetailsScreen(contact: contact),
                          ),
                        );
                      },
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
                              color: isSelected
                                  ? colorScheme.primary
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            leading: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 350),
                              switchInCurve: Curves.easeOutBack,
                              transitionBuilder: (child, animation) {
                                return ScaleTransition(
                                  scale: animation,
                                  child: FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  ),
                                );
                              },
                              child: isSelected
                                  ? CircleAvatar(
                                      key: ValueKey("selected_$index"),
                                      backgroundColor: colorScheme.primary,
                                      child: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                      ),
                                    )
                                  : CircleAvatar(
                                      key: ValueKey(contact.id),
                                      radius: 26,
                                      child: Text(
                                        contact.fullName[0].toUpperCase(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                            ),

                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    contact.fullName,
                                    maxLines: 1,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.favorite,
                                        size: 14,
                                        color: Colors.red,
                                      ),
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

                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(contact.phone),
                            ),

                            trailing: _selectionMode
                                ? Checkbox(
                                    value: isSelected,
                                    onChanged: (_) => _toggleSelection(index),
                                  )
                                : const Icon(Icons.chevron_right_rounded),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            top: _selectionMode ? 0 : -80,
            left: 0,
            right: 0,
            child: Material(
              elevation: 3,
              color: colorScheme.surface,
              child: SafeArea(
                bottom: false,
                child: SizedBox(
                  height: 64,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: _clearSelection,
                        icon: const Icon(Icons.close),
                      ),
                      Text(
                        "${_selectedIndexes.length}/${contacts.length} selected",
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),

                      IconButton.filledTonal(
                        onPressed: () {
                          setState(() {
                            _selectedIndexes.clear();

                            for (int i = 0; i < contacts.length; i++) {
                              _selectedIndexes.add(i);
                            }
                          });
                        },
                        icon: const Icon(Icons.select_all),
                        tooltip: "Select All",
                      ),

                      const SizedBox(width: 8),

                      IconButton.filledTonal(
                        onPressed: () async {
                          final selectedContacts = _selectedIndexes
                              .map((index) => contacts[index])
                              .toList();

                          for (final contact in selectedContacts) {
                            await contactController.toggleFavourite(contact);
                          }

                          _clearSelection();
                        },
                        icon: const Icon(Icons.heart_broken_outlined),
                        tooltip: "Remove from Favourite",
                      ),

                      const SizedBox(width: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}

import 'package:contact_x/features/contacts/presentation/controllers/contact_controller.dart';
import 'package:contact_x/features/contacts/presentation/pages/add_edit_contact/add_edit_contact_page.dart';
import 'package:contact_x/features/contacts/presentation/pages/contact_detail/contact_detail_page.dart';
import 'package:contact_x/features/contacts/presentation/widgets/contact_card.dart';
import 'package:contact_x/features/contacts/presentation/widgets/empty_contact_widget.dart';
import 'package:contact_x/features/contacts/presentation/widgets/selection_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

class AllContactsPage extends StatefulWidget {
  const AllContactsPage({super.key});

  @override
  State<AllContactsPage> createState() => _AllContactsPageState();
}

class _AllContactsPageState extends State<AllContactsPage> {
  final ContactController contactController = Get.find<ContactController>();

  final TextEditingController searchController = TextEditingController();

  bool selectionMode = false;

  final Set<int> selectedIndexes = {};

  void toggleSelection(int index) {
    setState(() {
      if (selectedIndexes.contains(index)) {
        selectedIndexes.remove(index);
      } else {
        selectedIndexes.add(index);
      }

      selectionMode = selectedIndexes.isNotEmpty;
    });
  }

  void startSelection(int index) {
    setState(() {
      selectionMode = true;
      selectedIndexes.add(index);
    });
  }

  void clearSelection() {
    setState(() {
      selectionMode = false;
      selectedIndexes.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final contacts = contactController.filteredContacts;

      contacts.sort((a, b) => a.fullName.compareTo(b.fullName));

      if (contacts.isEmpty) {
        return const EmptyContactWidget(
          icon: Icons.contacts_outlined,
          title: "No Contacts",
          subtitle: "Add your first contact",
        );
      }

      return Stack(
        children: [
          ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
              final isSelected = selectedIndexes.contains(index);

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),

                child: Slidable(
                  key: ValueKey(contact.id),

                  /// LEFT ACTIONS
                  startActionPane: ActionPane(
                    motion: const StretchMotion(),

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
                      ),
                    ],
                  ),

                  /// RIGHT ACTIONS
                  endActionPane: ActionPane(
                    motion: const DrawerMotion(),

                    extentRatio: 0.75,

                    children: [
                      /// Favourite
                      SlidableAction(
                        onPressed: (_) async {
                          await contactController.toggleFavourite(contact);
                        },

                        backgroundColor: contact.isFavourite
                            ? Colors.grey
                            : Colors.amber,

                        foregroundColor: Colors.white,

                        icon: contact.isFavourite
                            ? Icons.favorite_border
                            : Icons.favorite,

                        label: contact.isFavourite ? 'Remove' : 'Favourite',
                      ),

                      /// Edit
                      SlidableAction(
                        onPressed: (_) {
                          Get.to(
                            () => AddEditContactPage(
                              isEdit: true,
                              contact: contact,
                            ),
                          );
                        },

                        backgroundColor: Colors.blue,

                        foregroundColor: Colors.white,

                        icon: Icons.edit,

                        label: 'Edit',
                      ),

                      /// Delete
                      SlidableAction(
                        onPressed: (_) async {
                          final shouldDelete = await Get.dialog<bool>(
                            AlertDialog(
                              title: const Text("Delete Contact"),

                              content: Text("Delete ${contact.fullName} ?"),

                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Get.back(result: false);
                                  },

                                  child: const Text("Cancel"),
                                ),

                                FilledButton(
                                  onPressed: () {
                                    Get.back(result: true);
                                  },

                                  child: const Text("Delete"),
                                ),
                              ],
                            ),
                          );

                          if (shouldDelete != true) {
                            return;
                          }

                          await contactController.deleteContact(contact.id);
                        },

                        backgroundColor: Colors.red,

                        foregroundColor: Colors.white,

                        icon: Icons.delete,

                        label: 'Delete',
                      ),
                    ],
                  ),

                  /// CARD
                  child: ContactCard(
                    contact: contact,

                    isSelected: isSelected,

                    selectionMode: selectionMode,

                    onTap: () {
                      if (selectionMode) {
                        toggleSelection(index);
                        return;
                      }

                      Get.to(() => ContactDetailPage(contact: contact));
                    },

                    onLongPress: () {
                      startSelection(index);
                    },
                  ),
                ),
              );
            },
          ),

          /// SELECTION TOOLBAR
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),

            top: selectionMode ? 0 : -80,

            left: 0,
            right: 0,

            child: SelectionToolbar(
              selectedCount: selectedIndexes.length,

              totalCount: contacts.length,

              onClose: clearSelection,

              onSelectAll: () {
                setState(() {
                  selectedIndexes.clear();

                  for (int i = 0; i < contacts.length; i++) {
                    selectedIndexes.add(i);
                  }
                });
              },

              onAction: () async {
                final selectedContacts = selectedIndexes
                    .map((e) => contacts[e])
                    .toList();

                for (final contact in selectedContacts) {
                  await contactController.deleteContact(contact.id);
                }

                clearSelection();
              },

              actionIcon: Icons.delete_outline,

              actionTooltip: "Delete Selected",
            ),
          ),
        ],
      );
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}

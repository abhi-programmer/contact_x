import 'package:contact_x/features/contacts/domain/entities/contact.dart';
import 'package:contact_x/features/contacts/presentation/controllers/contact_controller.dart';
import 'package:contact_x/features/contacts/presentation/pages/all_contacts/permission_page.dart';
import 'package:contact_x/features/contacts/presentation/pages/contact_detail/contact_detail_page.dart';
import 'package:contact_x/features/contacts/presentation/widgets/contact_card.dart';
import 'package:contact_x/features/contacts/presentation/widgets/contact_search_bar.dart';
import 'package:contact_x/features/contacts/presentation/widgets/empty_contact_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';


class AllContactsPage extends StatefulWidget {
  const AllContactsPage({super.key});

  @override
  State<AllContactsPage> createState() => _AllContactsPageState();
}

class _AllContactsPageState extends State<AllContactsPage> {
  final ContactController contactController =
      Get.find<ContactController>();

  final TextEditingController searchController =
      TextEditingController();

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
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      /// loading
      if (contactController.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      /// permission denied
      if (!contactController.hasPermission.value) {
        return const ContactPermissionPage();
      }

      final List<Contact> contacts =
          [...contactController.filteredContacts];

      if (contacts.isEmpty) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: ContactSearchBar(
                controller: searchController,
                onChanged: (value) {
                  contactController.searchQuery.value = value;
                },
                onClear: () {
                  searchController.clear();
                  contactController.searchQuery.value = '';
                },
              ),
            ),
            const Expanded(
              child: EmptyContactWidget(
                icon: Icons.contacts_outlined,
                title: "No Contacts",
                subtitle: "No device contacts found.",
              ),
            ),
          ],
        );
      }

      return Stack(
        children: [
          AnimatedPadding(
            duration: const Duration(milliseconds: 300),
            padding: EdgeInsets.only(
              top: selectionMode ? 76 : 0,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: ContactSearchBar(
                    controller: searchController,
                    onChanged: (value) {
                      contactController.searchQuery.value = value;
                    },
                    onClear: () {
                      searchController.clear();
                      contactController.searchQuery.value = '';
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      12,
                      16,
                      100,
                    ),
                    itemCount: contacts.length,
                    itemBuilder: (context, index) {
                      final contact = contacts[index];
                      final isSelected =
                          selectedIndexes.contains(index);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Slidable(
                          enabled: !selectionMode,
                          key: ValueKey(contact.id),

                        
                          child: ContactCard(
                            contact: contact,
                            isSelected: isSelected,
                            selectionMode: selectionMode,
                            onTap: () {
                              if (selectionMode) {
                                toggleSelection(index);
                                return;
                              }

                              Get.to(
                                () => ContactDetailPage(
                                  contact: contact,
                                ),
                              );
                            },
                            onLongPress: () {
                              startSelection(index);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          /// top selection toolbar
          // AnimatedPositioned(
          //   duration: const Duration(milliseconds: 300),
          //   top: selectionMode ? 0 : -80,
          //   left: 0,
          //   right: 0,
          //   child: SelectionToolbar(
          //     selectedCount: selectedIndexes.length,
          //     totalCount: contacts.length,
          //     onClose: clearSelection,
          //     onSelectAll: () {
          //       setState(() {
          //         selectedIndexes.clear();
          //         for (int i = 0; i < contacts.length; i++) {
          //           selectedIndexes.add(i);
          //         }
          //       });
          //     },
          //     onAction: () async {
          //       final selectedContacts = selectedIndexes
          //           .map((e) => contacts[e])
          //           .toList();

          //       for (final contact in selectedContacts) {
          //         await contactController.deleteContact(contact.id);
          //       }

          //       clearSelection();
          //     },
          //     actionIcon: Icons.delete_outline,
          //     actionTooltip: "Delete Selected",
          //   ),
          // ),
        ],
      );
    });
  }
}
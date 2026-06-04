import 'package:contact_x/controllers/contact_controller.dart';
import 'package:contact_x/screens/contacts/add_edit_contacts.dart';
import 'package:contact_x/screens/contacts/contact_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

class AllContactsScreen extends StatefulWidget {
  const AllContactsScreen({super.key});

  @override
  State<AllContactsScreen> createState() => _AllContactsScreenState();
}

class _AllContactsScreenState extends State<AllContactsScreen> {
  final ContactController contactController = Get.find<ContactController>();
  final TextEditingController searchController = TextEditingController();

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

      final sortedContacts = contactController.contacts.where((contact) {
        final query = contactController.searchQuery.value.toLowerCase().trim();

        if (query.isEmpty) return true;

        return contact.fullName.toLowerCase().contains(query) ||
            contact.phone.toLowerCase().contains(query);
      }).toList();

      sortedContacts.sort((a, b) => a.fullName.compareTo(b.fullName));

      return Stack(
        children: [
          AnimatedPadding(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            padding: EdgeInsets.only(top: _selectionMode ? 76 : 0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Obx(
                    () => TextField(
                      controller: searchController,
                      onChanged: (value) {
                        contactController.searchQuery.value = value;
                      },
                      decoration: InputDecoration(
                        hintText: "Search contacts...",
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon:
                            contactController.searchQuery.value.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  searchController.clear();
                                  contactController.searchQuery.value = '';
                                },
                                icon: const Icon(Icons.close),
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: sortedContacts.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.contacts_outlined,
                                size: 64,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                "No Contacts",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Add your first contact",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                          itemCount: sortedContacts.length,
                          itemBuilder: (context, index) {
                            final contact = sortedContacts[index];
                            final isSelected = _selectedIndexes.contains(index);

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Slidable(
                                enabled: !_selectionMode,
                                key: ValueKey(contact.id),

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
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ],
                                ),

                                endActionPane: ActionPane(
                                  motion: const DrawerMotion(),
                                  extentRatio: 0.75,
                                  dismissible: DismissiblePane(
                                    confirmDismiss: () async {
                                      final shouldDelete =
                                          await showDialog<bool>(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text(
                                                  "Delete Contact",
                                                ),
                                                content: Text(
                                                  "Delete ${contact.fullName}?",
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(
                                                        context,
                                                        false,
                                                      );
                                                    },
                                                    child: const Text("Cancel"),
                                                  ),
                                                  FilledButton(
                                                    onPressed: () {
                                                      Navigator.pop(
                                                        context,
                                                        true,
                                                      );
                                                    },
                                                    child: const Text("Delete"),
                                                  ),
                                                ],
                                              );
                                            },
                                          );

                                      return shouldDelete ?? false;
                                    },
                                    onDismissed: () async {
                                      await contactController.deleteContact(
                                        contact.id,
                                      );
                                    },
                                  ),
                                  children: [
                                    SlidableAction(
                                      onPressed: (_) async {
                                        await contactController.toggleFavourite(
                                          contact,
                                        );
                                      },
                                      backgroundColor: contact.isFavourite
                                          ? Colors.grey
                                          : Colors.amber,
                                      foregroundColor: Colors.white,
                                      icon: contact.isFavourite
                                          ? Icons.favorite_border
                                          : Icons.favorite,
                                      label: contact.isFavourite
                                          ? 'Remove'
                                          : 'Favourite',
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        bottomLeft: Radius.circular(20),
                                      ),
                                    ),
                                    SlidableAction(
                                      onPressed: (_) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AddEditContactScreen(
                                                  isEdit: true,
                                                  contactId: contact.id,
                                                  firstName: contact.firstName,
                                                  lastName: contact.lastName,
                                                  company: contact.company,
                                                  jobTitle: contact.jobTitle,
                                                  email: contact.email,
                                                  phone: contact.phone,
                                                  notes: contact.notes,
                                                  isFavourite:
                                                      contact.isFavourite,
                                                ),
                                          ),
                                        );
                                      },
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      icon: Icons.edit,
                                      label: 'Edit',
                                    ),
                                    SlidableAction(
                                      onPressed: (_) async {
                                        final shouldDelete =
                                            await showDialog<bool>(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                    "Delete Contact",
                                                  ),
                                                  content: Text(
                                                    "Delete ${contact.fullName}?",
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(
                                                          context,
                                                          false,
                                                        );
                                                      },
                                                      child: const Text(
                                                        "Cancel",
                                                      ),
                                                    ),
                                                    FilledButton(
                                                      onPressed: () {
                                                        Navigator.pop(
                                                          context,
                                                          true,
                                                        );
                                                      },
                                                      child: const Text(
                                                        "Delete",
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );

                                        if (shouldDelete != true) {
                                          return;
                                        }

                                        await contactController.deleteContact(
                                          contact.id,
                                        );
                                      },
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                      label: 'Delete',
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
                                        builder: (_) => ContactDetailsScreen(
                                          contact: contact,
                                        ),
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
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                        leading: AnimatedSwitcher(
                                          duration: const Duration(
                                            milliseconds: 350,
                                          ),
                                          switchInCurve: Curves.easeOutBack,
                                          switchOutCurve: Curves.easeIn,
                                          transitionBuilder:
                                              (child, animation) {
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
                                                  key: ValueKey(
                                                    "selected_$index",
                                                  ),
                                                  backgroundColor:
                                                      colorScheme.primary,
                                                  child: const Icon(
                                                    Icons.check,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              : CircleAvatar(
                                                  key: ValueKey(contact.id),
                                                  radius: 26,
                                                  child: Text(
                                                    contact.fullName.isNotEmpty
                                                        ? contact.fullName[0]
                                                              .toUpperCase()
                                                        : '?',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
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

                                            if (contact.isFavourite)
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.red.withValues(
                                                    alpha: 0.15,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: const Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
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
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        ),

                                        subtitle: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 4,
                                          ),
                                          child: Text(
                                            maxLines: 1,
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                            contact.phone,
                                          ),
                                        ),

                                        trailing: _selectionMode
                                            ? AnimatedSwitcher(
                                                duration: const Duration(
                                                  milliseconds: 250,
                                                ),
                                                child: Checkbox(
                                                  key: ValueKey(isSelected),
                                                  value: isSelected,
                                                  onChanged: (_) =>
                                                      _toggleSelection(index),
                                                ),
                                              )
                                            : const Icon(
                                                Icons.chevron_right_rounded,
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
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
                        "${_selectedIndexes.length}/${sortedContacts.length} selected",
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),

                      const Spacer(),

                      IconButton.filledTonal(
                        onPressed: () {
                          setState(() {
                            _selectedIndexes.clear();

                            for (int i = 0; i < sortedContacts.length; i++) {
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
                          final shouldDelete = await showDialog<bool>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Delete Contacts"),
                                content: Text(
                                  "Delete ${_selectedIndexes.length} selected contacts?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text("Cancel"),
                                  ),
                                  FilledButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text("Delete"),
                                  ),
                                ],
                              );
                            },
                          );

                          if (shouldDelete != true) return;

                          final selectedContacts = _selectedIndexes
                              .map((index) => sortedContacts[index])
                              .toList();

                          for (final contact in selectedContacts) {
                            await contactController.deleteContact(contact.id);
                          }

                          _clearSelection();
                        },
                        icon: const Icon(Icons.delete_outline),
                        tooltip: "Delete Selected",
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

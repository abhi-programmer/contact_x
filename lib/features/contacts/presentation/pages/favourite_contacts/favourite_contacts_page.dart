// import 'package:contact_x/features/contacts/presentation/controllers/contact_controller.dart';
// import 'package:contact_x/features/contacts/presentation/pages/contact_detail/contact_detail_page.dart';
// import 'package:contact_x/features/contacts/presentation/widgets/contact_card.dart';
// import 'package:contact_x/features/contacts/presentation/widgets/empty_contact_widget.dart';
// import 'package:contact_x/features/contacts/presentation/widgets/selection_toolbar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:get/get.dart';

// class FavouriteContactsPage extends StatefulWidget {
//   const FavouriteContactsPage({super.key});

//   @override
//   State<FavouriteContactsPage> createState() => _FavouriteContactsPageState();
// }

// class _FavouriteContactsPageState extends State<FavouriteContactsPage> {
//   final ContactController contactController = Get.find<ContactController>();

//   bool selectionMode = false;

//   final Set<int> selectedIndexes = {};

//   void toggleSelection(int index) {
//     setState(() {
//       if (selectedIndexes.contains(index)) {
//         selectedIndexes.remove(index);
//       } else {
//         selectedIndexes.add(index);
//       }

//       selectionMode = selectedIndexes.isNotEmpty;
//     });
//   }

//   void startSelection(int index) {
//     setState(() {
//       selectionMode = true;
//       selectedIndexes.add(index);
//     });
//   }

//   void clearSelection() {
//     setState(() {
//       selectionMode = false;
//       selectedIndexes.clear();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final contacts = [...contactController.favouriteContacts];

//       if (contacts.isEmpty) {
//         return const EmptyContactWidget(
//           icon: Icons.favorite_border,
//           title: "No Favourite Contacts",
//           subtitle: "Add contacts to favourites to see them here.",
//         );
//       }

//       return Stack(
//         children: [
//           AnimatedPadding(
//             duration: const Duration(milliseconds: 300),

//             padding: EdgeInsets.only(top: selectionMode ? 76 : 0),

//             child: ListView.builder(
//               padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),

//               itemCount: contacts.length,

//               itemBuilder: (context, index) {
//                 final contact = contacts[index];

//                 final isSelected = selectedIndexes.contains(index);

//                 return Padding(
//                   padding: const EdgeInsets.only(bottom: 12),

//                   child: Slidable(
//                     enabled: !selectionMode,

//                     key: ValueKey(contact.id),

//                     startActionPane: ActionPane(
//                       motion: const StretchMotion(),

//                       children: [
//                         SlidableAction(
//                           onPressed: (_) async {
//                             await FlutterPhoneDirectCaller.callNumber(
//                               contact.phone,
//                             );
//                           },

//                           backgroundColor: Colors.green,

//                           foregroundColor: Colors.white,

//                           icon: Icons.call,

//                           label: "Call",
//                         ),
//                       ],
//                     ),

//                     endActionPane: ActionPane(
//                       motion: const DrawerMotion(),

//                       extentRatio: 0.25,

//                       children: [
//                         SlidableAction(
//                           onPressed: (_) async {
//                             await contactController.toggleFavourite(contact);
//                           },

//                           backgroundColor: Colors.red,

//                           foregroundColor: Colors.white,

//                           icon: Icons.favorite_border,

//                           label: "Remove",
//                         ),
//                       ],
//                     ),

//                     child: ContactCard(
//                       contact: contact,

//                       isSelected: isSelected,

//                       selectionMode: selectionMode,

//                       onTap: () {
//                         if (selectionMode) {
//                           toggleSelection(index);

//                           return;
//                         }

//                         Get.to(() => ContactDetailPage(contact: contact));
//                       },

//                       onLongPress: () {
//                         startSelection(index);
//                       },
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),

//           AnimatedPositioned(
//             duration: const Duration(milliseconds: 300),

//             top: selectionMode ? 0 : -80,

//             left: 0,
//             right: 0,

//             child: SelectionToolbar(
//               selectedCount: selectedIndexes.length,

//               totalCount: contacts.length,

//               onClose: clearSelection,

//               onSelectAll: () {
//                 setState(() {
//                   selectedIndexes.clear();

//                   for (int i = 0; i < contacts.length; i++) {
//                     selectedIndexes.add(i);
//                   }
//                 });
//               },

//               onAction: () async {
//                 final selectedContacts = selectedIndexes
//                     .map((index) => contacts[index])
//                     .toList();

//                 for (final contact in selectedContacts) {
//                   await contactController.toggleFavourite(contact);
//                 }

//                 clearSelection();
//               },

//               actionIcon: Icons.heart_broken_outlined,

//               actionTooltip: "Remove Favourite",
//             ),
//           ),
//         ],
//       );
//     });
//   }
// }

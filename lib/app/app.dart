import 'package:contact_x/app/theme/theme_controller.dart';
import 'package:contact_x/core/constants/app_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../features/contacts/presentation/pages/all_contacts/all_contacts_page.dart';
import '../features/contacts/presentation/pages/favourite_contacts/favourite_contacts_page.dart';
import '../features/contacts/presentation/pages/add_edit_contact/add_edit_contact_page.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final ThemeController themeController = Get.find<ThemeController>();

  int selectedIndex = 0;

  final List<Widget> pages = const [AllContactsPage(), FavouriteContactsPage()];

  final List<String> titles = const ['Contacts', 'Favourites'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,

        title: Text(
          titles[selectedIndex],
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),

        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.palette_outlined),

            onSelected: (value) {
              themeController.changeTheme(value);

              setState(() {});
            },

            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'light',
                child: Row(
                  children: [
                    const Icon(Icons.sunny),
                    const SizedBox(width: 12),

                    const Expanded(child: Text('Light Mode')),

                    if (themeController.selectedTheme == 'light')
                      const Icon(Icons.check, size: 18),
                  ],
                ),
              ),

              PopupMenuItem(
                value: 'dark',
                child: Row(
                  children: [
                    const Icon(Icons.nightlight),

                    const SizedBox(width: 12),

                    const Expanded(child: Text('Dark Mode')),

                    if (themeController.selectedTheme == 'dark')
                      const Icon(Icons.check, size: 18),
                  ],
                ),
              ),

              PopupMenuItem(
                value: 'auto',
                child: Row(
                  children: [
                    const Icon(Icons.brightness_auto),

                    const SizedBox(width: 12),

                    const Expanded(child: Text('Auto')),

                    if (themeController.selectedTheme == 'auto')
                      const Icon(Icons.check, size: 18),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(width: 8),
        ],
      ),

      body: pages[selectedIndex],

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(() => const AddEditContactPage());
        },

        icon: const Icon(Icons.person_add_alt_1),

        label: const Text("New Contact"),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,

        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },

        indicatorColor: AppColors.primaryBlue.withOpacity(0.4),

        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.contacts_outlined),

            selectedIcon: Icon(Icons.contacts),

            label: 'Contacts',
          ),

          NavigationDestination(
            icon: Icon(Icons.favorite_border),

            selectedIcon: Icon(Icons.favorite),

            label: 'Favourites',
          ),
        ],
      ),
    );
  }
}

import 'package:contact_x/controllers/theme_controller.dart';
import 'package:contact_x/screens/contacts/add_edit_contacts.dart';
import 'package:contact_x/screens/dashboard/all_contacts.dart';
import 'package:contact_x/screens/dashboard/favourite_contacts.dart';
import 'package:contact_x/theme/app_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final ThemeController themeController = Get.find<ThemeController>();

  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    AllContactsScreen(),
    FavouriteContactsScreen(),
  ];

  final List<String> _titles = const ['Contacts', 'Favourites'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 60,
        // leading: Padding(
        //   padding: const EdgeInsets.only(left: 12),
        //   child: GestureDetector(
        //     onTap: () => Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => MyProfileScreen()),
        //     ),
        //     child: CircleAvatar(radius: 18, child: Icon(Icons.person)),
        //   ),
        // ),
        centerTitle: true,
        title: Text(
          _titles[_selectedIndex],
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: PopupMenuButton<String>(
              onSelected: (value) {
                themeController.changeTheme(value);
              },
              icon: const Icon(Icons.palette_outlined),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
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
          ),
        ],
      ),
      body: _pages[_selectedIndex],

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEditContactScreen()),
          );
        },
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('New Contact'),
        elevation: 8,
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        indicatorColor: AppColors.primaryBlue.withValues(alpha: 0.4),
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

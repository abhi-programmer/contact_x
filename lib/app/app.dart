import 'package:contact_x/app/theme/theme_controller.dart';
import 'package:contact_x/core/constants/app_color_theme.dart';
import 'package:contact_x/features/contacts/presentation/pages/all_contacts/all_contacts_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  // final ThemeController themeController = Get.find<ThemeController>();

  int selectedIndex = 0;

  final List<Widget> pages = const [AllContactsPage(), Text('Favourites Page')];

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

          ),

      body: pages[selectedIndex],

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

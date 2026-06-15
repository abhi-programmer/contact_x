import 'package:flutter/material.dart';

class ContactSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const ContactSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  State<ContactSearchBar> createState() => _ContactSearchBarState();
}

class _ContactSearchBarState extends State<ContactSearchBar> {
  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,

      onChanged: widget.onChanged,

      decoration: InputDecoration(
        hintText: "Search contacts",

        prefixIcon: const Icon(Icons.search),

        suffixIcon: widget.controller.text.isNotEmpty
            ? IconButton(
                onPressed: widget.onClear,
                icon: const Icon(Icons.close),
              )
            : null,

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}

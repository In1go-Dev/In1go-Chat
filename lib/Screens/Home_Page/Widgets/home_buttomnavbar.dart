import 'package:app_1gochat/Providers/homepagesettings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key, required this.onTap});

  final void Function(int)? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomNavigationBar(
      landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
      backgroundColor: Colors.white,
      fixedColor: const Color(0xFFfc3113),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_rounded),
          label: 'Chat',
          tooltip: 'Chat'
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Contacts',
          tooltip: 'Contacts'
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
          tooltip: 'Settings'
        )
      ],

      //"ref.watch(value) automatically updates when the corresponding value is changed regardless if where"
      currentIndex: ref.watch(pageindex),
      onTap: onTap
    );
  }
}
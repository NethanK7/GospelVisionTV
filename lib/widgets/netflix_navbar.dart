import 'package:flutter/material.dart';

/// # Globablly Hidden Navbar
/// The user requested the top navbar to be removed everywhere "in the app only".
/// Returning a SizedBox.shrink() with Size.zero securely and entirely hides it
/// without requiring scaffold refactoring across 6 different screens.
class NetflixNavbar extends StatefulWidget implements PreferredSizeWidget {
  final ScrollController scrollController;

  const NetflixNavbar({super.key, required this.scrollController});

  @override
  Size get preferredSize => Size.zero;

  @override
  State<NetflixNavbar> createState() => _NetflixNavbarState();
}

class _NetflixNavbarState extends State<NetflixNavbar> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

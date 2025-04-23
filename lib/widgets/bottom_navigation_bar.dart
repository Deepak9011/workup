import 'package:flutter/material.dart';
import 'package:workup/utils/strings.dart';
import 'package:workup/utils/colors.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int? currentIndex;

  const CustomBottomNavigationBar({super.key, this.currentIndex});

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  static int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index; // Update the current index
    });
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/homepageScreen');
        break;
      case 1:
        Navigator.pushReplacementNamed(
            context, '/customerBidScreen');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/customerCartScreen');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/homepageScreen');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/customerProfileScreen');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: AppStrings.home,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.groups_rounded),
          label: AppStrings.bidding,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search_rounded),
          label: AppStrings.home,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment_rounded),
          label: AppStrings.home,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle_rounded),
          label: AppStrings.home,
        ),
      ],
      currentIndex: _currentIndex,
      onTap: _onItemTapped, // Use the method for tap handling
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: AppColors.white,
      unselectedItemColor: AppColors.tertiary,
      backgroundColor: AppColors.primary,
      type: BottomNavigationBarType.fixed,
    );
  }
}
import 'package:flutter/material.dart';
import 'package:toletadminpanel/settingScreen.dart';
import 'NewInvitesTab.dart';  // Make sure these imports are correct
import 'PropertiesTab.dart';  // Make sure these imports are correct

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  final List<Widget> _tabs = [
    NewInvitesTab(),
    PropertiesTab(),
    Settingscreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF192747), // Action bar background color
        title: Text(
          "Dashboard",
          style: TextStyle(color: Colors.white), // Title text color
        ),
      ),
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF192747), // Bottom nav bar background color
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.mail_outline,
              color: _currentIndex == 0 ? Colors.white : Color(0xFF8E8E93), // Icon color change
            ),
            label: "New Invites",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
              color: _currentIndex == 1 ? Colors.white : Color(0xFF8E8E93), // Icon color change
            ),
            label: "Properties",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              color: _currentIndex == 2 ? Colors.white : Color(0xFF8E8E93), // Icon color change
            ),
            label: "Settings",
          ),
        ],
        selectedItemColor: Colors.white, // Selected item text and icon color
        unselectedItemColor: Color(0xFF8E8E93), // Unselected item icon color
        showUnselectedLabels: true,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matrimony_app/screens/about_us.dart';
import 'package:matrimony_app/screens/add_user.dart';
import 'package:matrimony_app/screens/favourite_user.dart';
import 'package:matrimony_app/screens/user_list.dart';

class Navbar extends StatefulWidget {
  final int initialIndex;
  Navbar({this.initialIndex = 1});

  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late int _currentIndex;

  final List<Widget> _pages = [
    AddUserPage(),
    UserListPage(),
    FavoriteUsersPage(),
    AboutUsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _tabController = TabController(length: _pages.length, vsync: this, initialIndex: _currentIndex);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _tabController.animateTo(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        physics: NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: Container(
        height: 75,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFD81B60),
              Color(0xFFE91E63),
              Color(0xFFEC407A),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFD81B60).withOpacity(0.3),
              blurRadius: 15,
              offset: Offset(0, -5),
              spreadRadius: 2,
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.person_add, "Add", 0),
                _buildNavItem(Icons.list, "Users", 1),
                _buildNavItem(Icons.favorite, "Favs", 2),
                _buildNavItem(Icons.info, "About", 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _currentIndex == index;
    
    return GestureDetector(
      onTap: () => _onTabTapped(index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: EdgeInsets.all(isSelected ? 8 : 6),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? Color(0xFFD81B60) : Colors.white70,
                size: isSelected ? 24 : 20,
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              width: isSelected ? 50 : 0,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(width: 8),
                    Text(
                      label,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

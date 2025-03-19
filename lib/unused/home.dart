import 'package:flutter/material.dart';
import 'package:matrimony_app/screens/login_screen.dart';
import 'package:matrimony_app/screens/navbar.dart';
import 'package:matrimony_app/screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/about_us.dart';
import '../screens/add_user.dart';
import '../screens/favourite_user.dart';
import '../screens/user_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  MyApp({required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SoulMate Connect',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/dashboard': (context) => isLoggedIn ? Navbar() : LoginScreen(),
        '/userList': (context) => isLoggedIn ? UserListPage() : LoginScreen(),
        '/addUser': (context) => isLoggedIn ? AddUserPage() : LoginScreen(),
        '/favourites': (context) => isLoggedIn ? FavoriteUsersPage() : LoginScreen(),
        '/aboutUs': (context) => AboutUsScreen(),
      },
    );
  }
}

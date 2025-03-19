import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matrimony_app/screens/navbar.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    String input = _emailController.text.trim();
    String password = _passwordController.text.trim();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedEmail = prefs.getString('registeredEmail');
    String? storedUsername = prefs.getString('username');
    String? storedPassword = prefs.getString('registeredPassword');

    if ((input == storedEmail || input == storedUsername) && password == storedPassword) {
      await prefs.setBool('isLoggedIn', true);
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Navbar()));
    } else {
      _showMessage("Invalid email/username or password");
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFAD1457), Color(0xFFF06292)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              color: Colors.white.withOpacity(0.95),
              child: Padding(
                padding: EdgeInsets.all(25),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Login",
                        style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFAD1457)),
                      ),
                      SizedBox(height: 20),
                      _buildTextField(_emailController, "Email or Username", Icons.email, isEmail: true),
                      SizedBox(height: 15),
                      _buildPasswordField(),
                      SizedBox(height: 25),
                      _buildLoginButton(),
                      SizedBox(height: 15),
                      _buildRegisterOption(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, {bool isEmail = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      decoration: InputDecoration(
        labelText: hint,
        labelStyle: TextStyle(color: Colors.black87),
        prefixIcon: Icon(icon, color: Color(0xFFAD1457)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: Color(0xFFAD1457), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: Color(0xFFAD1457), width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Please enter your $hint";
        }

        if (isEmail) {
          final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
          if (!emailRegex.hasMatch(value.trim())) {
            return "Enter a valid email address (e.g., example@domain.com)";
          }
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: "Password",
        labelStyle: TextStyle(color: Colors.black87),
        prefixIcon: Icon(Icons.lock, color: Color(0xFFAD1457)),
        suffixIcon: IconButton(
          icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Color(0xFFAD1457)),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: Color(0xFFAD1457), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: Color(0xFFAD1457), width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return "Please enter your password";
        if (value.trim().length < 6) return "Password must be at least 6 characters";
        return null;
      },
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFAD1457), // 🔥 Updated Button Color
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        ),
        child: Text("Login", style: GoogleFonts.poppins(fontSize: 18, color: Colors.white)),
      ),
    );
  }

  Widget _buildRegisterOption() {
    return TextButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
      },
      child: Text(
        "Don't have an account? Register",
        style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFFAD1457)),
      ),
    );
  }
}

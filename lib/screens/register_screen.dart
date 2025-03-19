import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    String username = _usernameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Prevent duplicate registrations
    String? existingEmail = prefs.getString('registeredEmail');
    if (existingEmail != null && existingEmail == email) {
      _showMessage("Email is already registered!", Colors.red);
      return;
    }

    await prefs.setString('username', username);
    await prefs.setString('registeredEmail', email);
    await prefs.setString('registeredPassword', password);

    _showMessage("Registration successful! Redirecting to login...", Colors.green);

    Future.delayed(Duration(seconds: 1), () {
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    });
  }

  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFAD1457), Color(0xFFF06292)], // 🔥 Updated Gradient
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
                          _buildTitle("Register"),
                          SizedBox(height: 20),
                          _buildTextField(_usernameController, "Username", Icons.person),
                          SizedBox(height: 15),
                          _buildTextField(_emailController, "Email", Icons.email, isEmail: true),
                          SizedBox(height: 15),
                          _buildPasswordField(_passwordController, "Password", _obscurePassword, () {
                            setState(() => _obscurePassword = !_obscurePassword);
                          }),
                          SizedBox(height: 15),
                          _buildPasswordField(_confirmPasswordController, "Confirm Password", _obscureConfirmPassword, () {
                            setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                          }, mustMatchController: _passwordController),
                          SizedBox(height: 25),
                          _buildRegisterButton(),
                          SizedBox(height: 15),
                          _buildLoginOption(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Register Title
  Widget _buildTitle(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFAD1457)),
    );
  }

  // Input Field for Username & Email
  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isEmail = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      textCapitalization: !isEmail ? TextCapitalization.words : TextCapitalization.none,
      inputFormatters: !isEmail ? [
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
      ] : null,
      decoration: InputDecoration(
        labelText: label,
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
        errorMaxLines: 2, // Allow error text to wrap
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return "$label is required";
        if (!isEmail && value.trim().length < 3) return "Username must be at least 3 characters";
        if (isEmail) {
          // Comprehensive email validation regex
          final emailRegex = RegExp(
            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
            caseSensitive: false,
          );
          if (!emailRegex.hasMatch(value.trim())) {
            return "Please enter a valid email address\n(e.g., example@domain.com)";
          }
        }
        return null;
      },
      // Auto capitalization for username
      onChanged: (value) {
        if (!isEmail && value.isNotEmpty) {
          final words = value.split(' ');
          final capitalizedWords = words.map((word) {
            if (word.isEmpty) return '';
            return word[0].toUpperCase() + word.substring(1).toLowerCase();
          }).join(' ');
          
          if (capitalizedWords != value) {
            controller.value = controller.value.copyWith(
              text: capitalizedWords,
              selection: TextSelection.collapsed(offset: capitalizedWords.length),
            );
          }
        }
      },
    );
  }

  // Password & Confirm Password Field with Visibility Toggle
  Widget _buildPasswordField(
      TextEditingController controller, String label, bool obscureText, VoidCallback toggleVisibility,
      {TextEditingController? mustMatchController}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.black87),
        prefixIcon: Icon(Icons.lock, color: Color(0xFFAD1457)),
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility, color: Color(0xFFAD1457)),
          onPressed: toggleVisibility,
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
        if (value == null || value.trim().isEmpty) return "$label cannot be empty";
        if (value.length < 6) return "Password must be at least 6 characters";
        if (mustMatchController != null && value.trim() != mustMatchController.text.trim()) return "Passwords do not match";
        return null;
      },
    );
  }

  // Register Button
  Widget _buildRegisterButton() {
    return ElevatedButton(
      onPressed: _register,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFAD1457), // 🔥 Updated Button Color
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
      ),
      child: Text("Register", style: GoogleFonts.poppins(fontSize: 18, color: Colors.white)),
    );
  }

  // Already Have an Account?
  Widget _buildLoginOption() {
    return TextButton(
      onPressed: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
      },
      child: Text(
        "Already registered? Login",
        style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFFAD1457)),
      ),
    );
  }
}

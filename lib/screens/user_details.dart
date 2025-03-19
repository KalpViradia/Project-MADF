import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../helpers/api_service.dart';
import 'edit_user.dart';
import '../helpers/user_class.dart';

class UserDetailsPage extends StatefulWidget {
  final User user;
  final Function(User) onUpdate;
  final Function(User) onDelete;

  UserDetailsPage({
    required this.user,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  final ApiService _apiService = ApiService();
  late User currentUser;
  bool isFavorite = false;

  final Color primaryColor = Color(0xFFD81B60); // 🌸 Deep Pink
  final Color secondaryColor = Color(0xFFE91E63); // 💖 Lighter Pink Accent
  final Color bgStartColor = Color(0xFFF8BBD0); // 🌷 Soft Lavender Pink
  final Color bgEndColor = Color(0xFFFFEBEE); // 🌤 Light Blush Pink

  @override
  void initState() {
    super.initState();
    currentUser = widget.user;
    isFavorite = currentUser.isFavorite;
  }

  void _updateUser(User updatedUser) async {
    try {
      final result = await _apiService.updateUser(updatedUser.id!, updatedUser);
      if (result != null) {
        setState(() {
          currentUser = result;
        });
        widget.onUpdate(result);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update user: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 10,
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.warning_amber_rounded, size: 50, color: Colors.redAccent),
                SizedBox(height: 10),
                Text(
                  'Delete User?',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Are you sure you want to delete this user? This action cannot be undone.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          await _apiService.deleteUser(widget.user.id!);
                          widget.onDelete(widget.user);
                          Navigator.pop(dialogContext);
                          Navigator.pop(context);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to delete user: ${e.toString()}'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      child: Text(
                        'Delete',
                        style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _toggleFavorite() async {
    try {
      setState(() {
        currentUser.isFavorite = !currentUser.isFavorite;
      });

      final result = await _apiService.updateUser(currentUser.id!, currentUser);
      if (result != null) {
        widget.onUpdate(result);
      }
    } catch (e) {
      // Revert the state if API call fails
      setState(() {
        currentUser.isFavorite = !currentUser.isFavorite;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update favorite status: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  int _calculateAge(String dob) {
    DateTime birthDate = DateFormat("dd-MM-yyyy").parse(dob);
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;

    if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          currentUser.name!,
          style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: primaryColor,
        elevation: 5,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.pink.shade100, Colors.redAccent.shade400], // ✅ Consistent gradient
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.topRight,
                    child: _buildFavoriteButton(),
                  ),
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: secondaryColor, // ✅ Matches theme
                      child: Text(
                        currentUser.name!.isNotEmpty ? currentUser.name![0].toUpperCase() : '?',
                        style: GoogleFonts.poppins(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white.withOpacity(0.1),
                    ),
                    child: Text(
                      currentUser.name!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildInfoCard("About", [
                    _buildDetailRow("Name", currentUser.name!),
                    _buildDetailRow("Gender", currentUser.gender ?? 'Not specified'),
                    _buildDetailRow("Date of Birth", currentUser.dob ?? 'Not specified'),
                    _buildDetailRow("Age", currentUser.dob != null ? _calculateAge(currentUser.dob!).toString() : 'Not specified'),
                    _buildDetailRow("Marital Status", currentUser.maritalStatus ?? 'Not specified'),
                  ]),
                  _buildInfoCard("Religious Background", [
                    _buildDetailRow("Country", currentUser.country ?? 'Not specified'),
                    _buildDetailRow("State", currentUser.state ?? 'Not specified'),
                    _buildDetailRow("City", currentUser.city ?? 'Not specified'),
                    _buildDetailRow("Religion", currentUser.religion ?? 'Not specified'),
                    _buildDetailRow("Caste", currentUser.caste ?? 'Not specified'),
                    _buildDetailRow("Sub Caste", currentUser.subCaste ?? 'Not specified'),
                  ]),
                  _buildInfoCard("Professional Details", [
                    _buildDetailRow("Higher Education", currentUser.education ?? 'Not specified'),
                    _buildDetailRow("Occupation", currentUser.occupation ?? 'Not specified'),
                  ]),
                  _buildInfoCard("Contact Details", [
                    _buildDetailRow("Email", currentUser.email ?? 'Not specified'),
                    _buildDetailRow("Phone", currentUser.phone ?? 'Not specified'),
                  ]),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomActionBar(),
    );
  }

  Widget _buildFavoriteButton() {
    return GestureDetector(
      onTap: _toggleFavorite,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: currentUser.isFavorite
              ? Colors.red.withOpacity(0.15)  // Soft background when favorite
              : Colors.grey.withOpacity(0.15),  // Soft background when not favorite
        ),
        child: Icon(
          currentUser.isFavorite ? Icons.favorite : Icons.favorite_border,
          color: currentUser.isFavorite ? Colors.red : Colors.white,  // Adjusted for better contrast
          size: 28,
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> details) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color: Colors.white.withOpacity(0.15), // Soft translucent effect
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Adjusted text color for better contrast
              ),
            ),
            Divider(color: Colors.white.withOpacity(0.5)), // Softer divider line
            ...details,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "$title:",
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.grey[700]),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: GoogleFonts.poppins(fontSize: 16.0, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.pink.shade100, Colors.redAccent.shade400], // Consistent with other pages
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, -3),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(Icons.edit, "Edit", Colors.blue, () async {
            User? updatedUser = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditUserPage(user: currentUser)),
            );
            if (updatedUser != null) _updateUser(updatedUser);
          }),
          _buildActionButton(Icons.delete, "Delete", Colors.red, _showDeleteConfirmationDialog),
          _buildActionButton(Icons.arrow_back, "Back", Colors.green, () => Navigator.pop(context)),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color, VoidCallback onPressed) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: color),
      label: Text(
        label,
        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: color),
      ),
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

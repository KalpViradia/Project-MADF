import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutUsScreen extends StatefulWidget {
  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> with TickerProviderStateMixin {
  // Update color constants
  final Color primaryColor = Color(0xFFD81B60); // 🌸 Deep Pink
  final Color secondaryColor = Color(0xFFE91E63); // 💖 Lighter Pink Accent
  final Color bgStartColor = Color(0xFFF8BBD0); // 🌷 Soft Lavender Pink
  final Color bgEndColor = Color(0xFFFFEBEE); // 🌤 Light Blush Pink

  late AnimationController _gradientController;

  @override
  void initState() {
    super.initState();

    // Add gradient animation controller
    _gradientController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4), // Slower rotation
    )..repeat();
  }

  @override
  void dispose() {
    _gradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgStartColor,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'About Us',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [bgStartColor, bgEndColor],
          ),
        ),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: _buildShiningAppTitle(),
              ),
              
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildInfoCard(
                      title: 'Meet Our Team',
                      icon: Icons.people,
                      children: _buildTeamInfo(),
                    ),
                    SizedBox(height: 16),
                    _buildInfoCard(
                      title: 'About ASWDC',
                      icon: Icons.school,
                      children: _buildAswdcInfo(),
                    ),
                    SizedBox(height: 16),
                    _buildInfoCard(
                      title: 'Contact Us',
                      icon: Icons.contact_mail,
                      children: _buildContactInfo(),
                    ),
                    SizedBox(height: 16),
                    _buildInfoCard(
                      title: 'Quick Links',
                      icon: Icons.link,
                      children: _buildOtherLinks(),
                    ),
                    SizedBox(height: 24),
                    _buildFooter(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShiningAppTitle() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            'assets/images/matrimony_app_logo.jpeg',
            width: 120,
            height: 120,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 24),
        AnimatedBuilder(
          animation: _gradientController,
          builder: (context, child) {
            return ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  Colors.pink.shade200,
                  primaryColor,
                  Colors.purple.shade300,
                  Colors.pink.shade300,
                  primaryColor,
                ],
                stops: [0.0, 0.25, 0.5, 0.75, 1.0],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                transform: GradientRotation(_gradientController.value * 6.283185),
              ).createShader(bounds),
              child: Text(
                'SoulMate Connect',
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: primaryColor.withOpacity(0.5),
                      offset: Offset(0, 2),
                      blurRadius: 5,
                    ),
                    Shadow(
                      color: Colors.purple.withOpacity(0.3),
                      offset: Offset(2, 2),
                      blurRadius: 7,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: primaryColor),
                SizedBox(width: 12),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  // Update the styling of these helper methods
  Widget _buildKeyValueRow(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$key:',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748B),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: GoogleFonts.poppins(color: Color(0xFF64748B)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String info) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: primaryColor, size: 20),
          SizedBox(width: 12),
          Text(
            info,
            style: GoogleFonts.poppins(color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkRow(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: primaryColor, size: 20),
          SizedBox(width: 12),
          Text(
            title,
            style: GoogleFonts.poppins(color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: Color(0xFF64748B),
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Text(
        '© 2025 Darshan University\nAll Rights Reserved - Privacy Policy',
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: Color(0xFF64748B),
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  List<Widget> _buildTeamInfo() {
    return [
      _buildKeyValueRow('Developed by', 'Kalp Viradia (23010101299)'),
      _buildKeyValueRow('Mentored by', 'Prof. Mehul Bhundiya'),
      _buildKeyValueRow('Explored by', 'ASWDC, School Of Computer Science'),
      _buildKeyValueRow('Eulogized by', 'Darshan University'),
    ];
  }

  List<Widget> _buildAswdcInfo() {
    return [
      _buildParagraph('ASWDC is an Application, Software, and Website Development Center at Darshan University.'),
      _buildParagraph('It bridges the gap between academics and industry with real-world projects.'),
    ];
  }

  List<Widget> _buildContactInfo() {
    return [
      _buildContactRow(Icons.email, 'aswdc@darshan.ac.in'),
      _buildContactRow(Icons.phone, '+91-9727747317'),
      _buildContactRow(Icons.language, 'www.darshan.ac.in'),
    ];
  }

  List<Widget> _buildOtherLinks() {
    return [
      _buildLinkRow(Icons.share, 'Share App'),
      _buildLinkRow(Icons.apps, 'More Apps'),
      _buildLinkRow(Icons.star, 'Rate Us'),
      _buildLinkRow(Icons.thumb_up, 'Like us on Facebook'),
      _buildLinkRow(Icons.update, 'Check For Update'),
    ];
  }
}

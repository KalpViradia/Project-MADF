import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:matrimony_app/screens/navbar.dart';
import '../helpers/dropdown_data.dart';
import '../helpers/user_class.dart';
import '../helpers/api_service.dart';

class AddUserPage extends StatefulWidget {
  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  TextEditingController nameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController religionController = TextEditingController();
  TextEditingController casteController = TextEditingController();
  TextEditingController subCasteController = TextEditingController();
  TextEditingController educationController = TextEditingController();
  TextEditingController occupationController = TextEditingController();

  String? gender;
  String? maritalStatus;
  String? selectedCountry;
  String? selectedState;
  String? selectedCity;
  DateTime? selectedDate;
  bool isFavorite = false;

  Future<void> _selectDate(BuildContext context) async {
    DateTime today = DateTime.now();
    DateTime minDate = DateTime(today.year - 80, today.month, today.day);
    DateTime maxDate = DateTime(today.year - 18, today.month, today.day);
    DateTime tempPickedDate = selectedDate ?? maxDate;

    if (!mounted) return;

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.65,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    height: 4,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  
                  // Header
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_month,
                          color: Color(0xFF2563EB),
                          size: 30,
                        ),
                        SizedBox(width: 15),
                        Text(
                          "Select Date of Birth",
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2563EB),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Date Picker
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Theme(
                        data: ThemeData.light().copyWith(
                          colorScheme: ColorScheme.light(
                            primary: Color(0xFF2563EB),
                            onPrimary: Colors.white,
                            surface: Colors.white,
                            onSurface: Colors.black,
                          ),
                          dialogBackgroundColor: Colors.white,
                        ),
                        child: CalendarDatePicker(
                          initialDate: tempPickedDate,
                          firstDate: minDate,
                          lastDate: maxDate,
                          onDateChanged: (DateTime picked) {
                            setModalState(() => tempPickedDate = picked);
                          },
                        ),
                      ),
                    ),
                  ),

                  // Action Buttons
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: Color(0xFF2563EB)),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF2563EB),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedDate = tempPickedDate;
                                dobController.text = DateFormat('dd-MM-yyyy').format(tempPickedDate);
                              });
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF2563EB),
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'Confirm',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text(
          'Add User',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF2563EB),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF0F5FF), Colors.white],
          ),
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                // Form Sections Container
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 15,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildFormSection(
                        "Personal Information",
                        Icons.person,
                        [
                          _buildInputField(
                            controller: nameController,
                            label: "Full Name",
                            icon: Icons.person_outline,
                            validator: (value) => value!.isEmpty ? 'Please enter name' : null,
                            maxLength: 50,
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]'))],
                          ),
                          _buildDropdownField(
                            value: gender,
                            items: DropdownData.genders,
                            onChanged: (value) => setState(() => gender = value),
                            label: "Gender",
                            icon: Icons.wc,
                          ),
                          _buildDateField(
                            controller: dobController,
                            label: "Date of Birth",
                            onTap: () => _selectDate(context),
                          ),
                          _buildDropdownField(
                            value: maritalStatus,
                            items: DropdownData.maritalStatus,
                            onChanged: (value) => setState(() => maritalStatus = value),
                            label: "Marital Status",
                            icon: Icons.favorite,
                          ),
                        ],
                      ),
                      Divider(height: 1, color: Colors.grey.shade200),
                      _buildFormSection(
                        "Contact Information",
                        Icons.contact_mail,
                        [
                          _buildLocationDropdowns(),
                          _buildInputField(
                            controller: emailController,
                            label: "Email Address",
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  !RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}")
                                      .hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          _buildInputField(
                            controller: phoneController,
                            label: "Phone Number",
                            icon: Icons.phone_outlined,
                            keyboardType: TextInputType.number,
                            maxLength: 10,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10)
                            ],
                            validator: (value) {
                              if (value == null ||
                                  value.length != 10 ||
                                  !RegExp(r"^[0-9]{10}").hasMatch(value)) {
                                return 'Please enter a valid 10-digit phone number';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      Divider(height: 1, color: Colors.grey.shade200),
                      _buildFormSection(
                        "Other Details",
                        Icons.more_horiz,
                        [
                          _buildDropdownField(
                            value: religionController.text.isEmpty
                                ? null
                                : religionController.text,
                            items: DropdownData.religions.toSet().toList(),
                            onChanged: (value) {
                              setState(() {
                                religionController.text = value!;
                                casteController.clear();
                                subCasteController.clear();
                              });
                            },
                            label: "Religion",
                            icon: Icons.church,
                          ),

                          _buildDropdownField(
                            value: casteController.text.isEmpty ? null : casteController.text,
                            items: DropdownData.casteMap[religionController.text]?.toSet().toList() ?? [],
                            onChanged: (value) {
                              setState(() {
                                casteController.text = value!;
                                subCasteController.clear();
                              });
                            },
                            label: "Caste",
                            icon: Icons.group,
                          ),

                          _buildDropdownField(
                            value: subCasteController.text.isEmpty ? null : subCasteController.text,
                            items: DropdownData.subCasteMap[casteController.text] ?? [],
                            onChanged: (value) => setState(() => subCasteController.text = value!),
                            label: "Sub-Caste",
                            icon: Icons.people,
                          ),

                          _buildDropdownField(
                            value: educationController.text.isEmpty ? null : educationController.text,
                            items: DropdownData.higherEducation,
                            onChanged: (value) => setState(() => educationController.text = value!),
                            label: "Higher Education",
                            icon: Icons.school,
                          ),

                          _buildDropdownField(
                            value: occupationController.text.isEmpty ? null : occupationController.text,
                            items: DropdownData.occupations,
                            onChanged: (value) => setState(() => occupationController.text = value!),
                            label: "Occupation",
                            icon: Icons.work,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: _buildSubmitButton(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormSection(String title, IconData icon, List<Widget> children) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF2563EB).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Color(0xFF2563EB), size: 20),
              ),
              SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2563EB),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    int? maxLength,
    VoidCallback? onTap,
    bool readOnly = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
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
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(color: Color(0xFF64748B)),
          prefixIcon: Icon(icon, color: Color(0xFF2563EB)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Color(0xFFE2E8F0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Color(0xFFE2E8F0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Color(0xFF2563EB), width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        style: GoogleFonts.poppins(fontSize: 16),
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: validator,
        maxLength: maxLength,
        onTap: onTap,
        readOnly: readOnly,
      ),
    );
  }

  Widget _buildDropdownField({
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required String label,
    required IconData icon,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
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
      child: DropdownButtonFormField<String>(
        value: value,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(color: Color(0xFF64748B)),
          prefixIcon: Icon(icon, color: Color(0xFF2563EB)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Color(0xFFE2E8F0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Color(0xFFE2E8F0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Color(0xFF2563EB), width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        icon: Icon(Icons.arrow_drop_down, color: Color(0xFF2563EB)),
        dropdownColor: Colors.white,
        elevation: 8, // Adds a shadow to the dropdown
        style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
        items: items
            .map((String value) => DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: GoogleFonts.poppins(fontSize: 16),
          ),
        ))
            .toList(),
      ),
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GestureDetector(
        onTap: onTap,
        child: AbsorbPointer(
          child: _buildInputField(
            controller: controller,
            label: label,
            icon: Icons.calendar_today_outlined,
            readOnly: true,
          ),
        ),
      ),
    );
  }

  Widget _buildLocationDropdowns() {
    return Column(
      children: [
        _buildDropdownField(
          value: selectedCountry,
          items: DropdownData.countries,
          onChanged: (value) => setState(() {
            selectedCountry = value;
            selectedState = null;
            selectedCity = null;
          }),
          label: "Country",
          icon: Icons.flag,
        ),
        _buildDropdownField(
          value: selectedState,
          items: DropdownData.countryStateMap[selectedCountry ?? ''] ?? [],
          onChanged: (value) => setState(() {
            selectedState = value;
            selectedCity = null;
          }),
          label: "State",
          icon: Icons.location_on,
        ),
        _buildDropdownField(
          value: selectedCity,
          items: DropdownData.stateCityMap[selectedState ?? ''] ?? [],
          onChanged: (value) => setState(() => selectedCity = value),
          label: "City",
          icon: Icons.location_city,
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 24),
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            try {
              final newUser = User(
                name: nameController.text,
                gender: gender,
                dob: selectedDate != null ? DateFormat('dd-MM-yyyy').format(selectedDate!) : null,
                maritalStatus: maritalStatus,
                country: selectedCountry,
                state: selectedState,
                city: selectedCity,
                email: emailController.text,
                phone: phoneController.text,
                religion: religionController.text,
                caste: casteController.text,
                subCaste: subCasteController.text,
                education: educationController.text,
                occupation: occupationController.text,
                isFavorite: isFavorite,
              );

              final addedUser = await _apiService.addUser(newUser);
              
              if (addedUser != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('User added successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
                
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Navbar(initialIndex: 1),
                  ),
                );
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to add user: ${e.toString()}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF2563EB),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
        ),
        child: Text(
          'Add User',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

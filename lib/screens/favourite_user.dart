import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../helpers/api_service.dart';
import 'edit_user.dart';
import '../helpers/user_class.dart';
import 'user_details.dart';

class FavoriteUsersPage extends StatefulWidget {
  @override
  _FavoriteUsersPageState createState() => _FavoriteUsersPageState();
}

class _FavoriteUsersPageState extends State<FavoriteUsersPage> {
  final ApiService _apiService = ApiService();
  TextEditingController searchController = TextEditingController();
  List<User> allFavoriteUsers = [];
  List<User> filteredFavoriteUsers = [];
  Timer? _debounce;
  String _sortField = 'name';
  bool _isAscending = true;

  final Color primaryColor = Color(0xFFD81B60); // 🌸 Deep Pink
  final Color secondaryColor = Color(0xFFE91E63); // 💖 Lighter Pink Accent
  final Color bgStartColor = Color(0xFFF8BBD0); // 🌷 Soft Lavender Pink
  final Color bgEndColor = Color(0xFFFFEBEE); // 🌤 Light Blush Pink

  RangeValues _ageRange = RangeValues(18, 60);
  bool _isAgeRangeActive = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteUsers();
  }

  void _loadFavoriteUsers() async {
    try {
      List<User> users = await _apiService.getUsers();
      setState(() {
        // Sort users by ID in descending order (newest first)
        users.sort((a, b) {
          // Parse IDs and handle potential null values
          int idA = int.tryParse(a.id ?? '0') ?? 0;
          int idB = int.tryParse(b.id ?? '0') ?? 0;
          return idB.compareTo(idA); // Descending order
        });

        allFavoriteUsers = users.where((user) => user.isFavorite).toList();

        // Preserve search results if there's an active query
        if (searchController.text.isNotEmpty) {
          _filterFavoriteUsers(searchController.text);
        } else {
          filteredFavoriteUsers = List.from(allFavoriteUsers);
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load favorite users: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(Duration(milliseconds: 300), () {
      _filterFavoriteUsers(query);
    });
  }

  void _filterFavoriteUsers(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        filteredFavoriteUsers = List.from(allFavoriteUsers);
      } else {
        query = query.toLowerCase().trim();
        filteredFavoriteUsers = allFavoriteUsers.where((user) {
          return (user.name?.toLowerCase().contains(query) ?? false) ||
              (user.email?.toLowerCase().contains(query) ?? false) ||
              (user.phone?.toLowerCase().contains(query) ?? false) ||
              (user.city?.toLowerCase().contains(query) ?? false) ||
              (user.age.toString().contains(query));
        }).toList();
        // Maintain the same order as allFavoriteUsers for search results
        filteredFavoriteUsers.sort((a, b) {
          int idA = int.tryParse(a.id ?? '0') ?? 0;
          int idB = int.tryParse(b.id ?? '0') ?? 0;
          return idB.compareTo(idA);
        });
      }
    });
  }

  void _toggleFavorite(User user) async {
    try {
      user.isFavorite = !user.isFavorite;
      final updatedUser = await _apiService.updateUser(user.id!, user);
      if (updatedUser != null) {
        _loadFavoriteUsers();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update favorite status: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _editUser(User user) async {
    User? updatedUser = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditUserPage(user: user)),
    );

    if (updatedUser != null) {
      try {
        await _apiService.updateUser(updatedUser.id!, updatedUser);
        _loadFavoriteUsers();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update user: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                    fontSize: 20,
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
                      onPressed: () => Navigator.of(context).pop(),
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
                          await _apiService.deleteUser(filteredFavoriteUsers[index].id!);
                          _loadFavoriteUsers();
                          Navigator.of(context).pop();
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

  void _applySorting() {
    setState(() {
      filteredFavoriteUsers = List.from(allFavoriteUsers);

      // Apply age range filter if age sorting is active
      if (_isAgeRangeActive) {
        filteredFavoriteUsers = filteredFavoriteUsers.where((user) {
          return user.age >= _ageRange.start && user.age <= _ageRange.end;
        }).toList();
      }

      // Apply sorting
      filteredFavoriteUsers.sort((a, b) {
        dynamic aValue = _getFieldValue(a, _sortField);
        dynamic bValue = _getFieldValue(b, _sortField);
        if (aValue is String && bValue is String) {
          return _isAscending
              ? aValue.compareTo(bValue)
              : bValue.compareTo(aValue);
        } else if (aValue is num && bValue is num) {
          return _isAscending
              ? aValue.compareTo(bValue)
              : bValue.compareTo(aValue);
        }
        return 0;
      });
    });
  }

  dynamic _getFieldValue(User user, String field) {
    switch (field) {
      case 'name':
        return user.name ?? '';
      case 'email':
        return user.email ?? '';
      case 'phone':
        return user.phone ?? '';
      case 'city':
        return user.city ?? '';
      case 'age':
        return user.age;
      default:
        return '';
    }
  }

  void _showSortingDialog() {
    String tempSortField = _sortField;
    bool tempIsAscending = _isAscending;
    RangeValues tempAgeRange = _ageRange;
    bool tempIsAgeRangeActive = _isAgeRangeActive;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 8,
              backgroundColor: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header section remains the same
                    Row(
                      children: [
                        Icon(Icons.sort, color: Colors.redAccent, size: 28),
                        SizedBox(width: 10),
                        Text(
                          'Sort Users',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    Divider(thickness: 1, color: Colors.redAccent.withOpacity(0.3)),
                    SizedBox(height: 10),

                    // Sort field dropdown
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: DropdownButtonFormField<String>(
                        value: tempSortField,
                        style: GoogleFonts.poppins(color: Colors.black87),
                        icon: Icon(Icons.arrow_drop_down, color: Colors.redAccent),
                        decoration: InputDecoration(
                          labelText: 'Sort By',
                          labelStyle: GoogleFonts.poppins(color: Colors.redAccent),
                          border: InputBorder.none,
                        ),
                        items: ['name', 'email', 'phone', 'city', 'age'].map((field) {
                          return DropdownMenuItem(
                            value: field,
                            child: Text(field.toUpperCase(),
                                style: GoogleFonts.poppins(fontSize: 16)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            if (value != null) {
                              tempSortField = value;
                              tempIsAgeRangeActive = value == 'age';
                            }
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 12),

                    // Show age range selector when age is selected
                    if (tempSortField == 'age') ...[
                      Text(
                        'Age Range: ${tempAgeRange.start.round()} - ${tempAgeRange.end.round()}',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      RangeSlider(
                        values: tempAgeRange,
                        min: 18,
                        max: 60,
                        divisions: 42,
                        labels: RangeLabels(
                          tempAgeRange.start.round().toString(),
                          tempAgeRange.end.round().toString(),
                        ),
                        onChanged: (RangeValues values) {
                          setState(() {
                            tempAgeRange = values;
                          });
                        },
                        activeColor: Colors.redAccent,
                        inactiveColor: Colors.red.shade100,
                      ),
                      SizedBox(height: 12),
                    ],

                    // Order dropdown (show for all fields)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: DropdownButtonFormField<bool>(
                        value: tempIsAscending,
                        style: GoogleFonts.poppins(color: Colors.black87),
                        icon: Icon(Icons.arrow_drop_down, color: Colors.redAccent),
                        decoration: InputDecoration(
                          labelText: 'Order',
                          labelStyle: GoogleFonts.poppins(color: Colors.redAccent),
                          border: InputBorder.none,
                        ),
                        items: [
                          DropdownMenuItem(
                            value: true,
                            child: Text('Ascending',
                                style: GoogleFonts.poppins(fontSize: 16)),
                          ),
                          DropdownMenuItem(
                            value: false,
                            child: Text('Descending',
                                style: GoogleFonts.poppins(fontSize: 16)),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) tempIsAscending = value;
                        },
                      ),
                    ),
                    SizedBox(height: 20),

                    // Action buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade300,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text('Cancel',
                              style: GoogleFonts.poppins(color: Colors.black87)),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _sortField = tempSortField;
                              _isAscending = tempIsAscending;
                              _ageRange = tempAgeRange;
                              _isAgeRangeActive = tempIsAgeRangeActive;
                              _applySorting();
                            });
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text('Apply',
                              style: GoogleFonts.poppins(color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Users',
            style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white)),
        backgroundColor: primaryColor,
        elevation: 5,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pinkAccent.shade100, Colors.redAccent.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      onChanged: _onSearchChanged,
                      decoration: InputDecoration(
                        labelText: 'Search User',
                        labelStyle: GoogleFonts.poppins(color: Colors.white),
                        prefixIcon: Icon(Icons.search, color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.sort, color: Colors.white),
                    onPressed: _showSortingDialog,
                  ),
                ],
              ),
            ),
            Expanded(
              child: filteredFavoriteUsers.isEmpty
                  ? Center(
                child: Text(
                  "No data found",
                  style: GoogleFonts.poppins(
                      fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white70),
                ),
              )
                  : ListView.builder(
                itemCount: filteredFavoriteUsers.length,
                itemBuilder: (context, index) {
                  User user = filteredFavoriteUsers[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 6,
                    shadowColor: Colors.black.withOpacity(0.15),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [bgStartColor, bgEndColor],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            leading: CircleAvatar(
                              backgroundColor: secondaryColor,
                              radius: 28,
                              child: Text(
                                user.name != null && user.name!.isNotEmpty
                                    ? user.name![0].toUpperCase()
                                    : '?',
                                style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            title: Text(
                              user.name!,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildIconText(Icons.wc, user.gender, fontSize: 14),
                                  _buildIconText(Icons.cake, user.age.toString(), fontSize: 14),
                                  _buildIconText(Icons.location_city, user.city, fontSize: 14),
                                ],
                              ),
                            ),
                            onTap: () async {
                              User? updatedUser = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserDetailsPage(
                                    user: user,
                                    onUpdate: (_) => _loadFavoriteUsers(),
                                    onDelete: (_) => _loadFavoriteUsers(),
                                  ),
                                ),
                              );
                              if (updatedUser != null) {
                                _loadFavoriteUsers();
                              }
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildActionButton(
                                  icon: user.isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: user.isFavorite ? Colors.red : Colors.white,
                                  onTap: () => _toggleFavorite(user),
                                ),
                                _buildActionButton(
                                  icon: Icons.edit,
                                  color: Colors.blue,
                                  onTap: () => _editUser(user),
                                ),
                                _buildActionButton(
                                  icon: Icons.delete,
                                  color: Colors.red,
                                  onTap: () => _confirmDelete(index),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconText(IconData icon, String? value, {double fontSize = 14}) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.redAccent),
        SizedBox(width: 8),
        Text(
          value ?? 'N/A', // Show 'N/A' if value is null
          overflow: TextOverflow.ellipsis, // Prevents overflow
          maxLines: 1, // Restrict to a single line
          style: GoogleFonts.poppins(fontSize: fontSize, color: Colors.black54),
        ),
      ],
    );
  }

// Reusable Action Button with Background
  Widget _buildActionButton(
      {required IconData icon,
        required Color color,
        required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(0.15), // Soft background color
        ),
        child: Icon(icon, color: color, size: 26),
      ),
    );
  }
}

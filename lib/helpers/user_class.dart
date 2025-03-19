import 'package:intl/intl.dart';

class User {
  String? id;
  String? name;
  String? gender;
  String? dob;
  String? maritalStatus;
  String? country;
  String? state;
  String? city;
  String? religion;
  String? caste;
  String? subCaste;
  String? education;
  String? occupation;
  String? email;
  String? phone;
  bool isFavorite;

  User({
    this.id,
    this.name,
    this.gender,
    this.dob,
    this.maritalStatus,
    this.country,
    this.state,
    this.city,
    this.religion,
    this.caste,
    this.subCaste,
    this.education,
    this.occupation,
    this.email,
    this.phone,
    this.isFavorite = false,
  });

  // Method to calculate age based on dob
  int get age {
    if (dob == null || dob!.isEmpty) return 0;
    DateTime birthDate = DateFormat("dd-MM-yyyy").parse(dob!);
    DateTime now = DateTime.now();
    int calculatedAge = now.year - birthDate.year;

    if (now.month < birthDate.month || (now.month == birthDate.month && now.day < birthDate.day)) {
      calculatedAge--;
    }
    return calculatedAge;
  }

  // Convert user data to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'gender': gender,
      'dob': dob,
      'maritalStatus': maritalStatus,
      'country': country,
      'state': state,
      'city': city,
      'religion': religion,
      'caste': caste,
      'subCaste': subCaste,
      'education': education,
      'occupation': occupation,
      'email': email,
      'phone': phone,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  // Convert from a map to a User instance
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      gender: map['gender'],
      dob: map['dob'],
      maritalStatus: map['maritalStatus'],
      country: map['country'],
      state: map['state'],
      city: map['city'],
      religion: map['religion'],
      caste: map['caste'],
      subCaste: map['subCaste'],
      education: map['education'],
      occupation: map['occupation'],
      email: map['email'],
      phone: map['phone'],
      isFavorite: map['isFavorite'] == 1,
    );
  }
}

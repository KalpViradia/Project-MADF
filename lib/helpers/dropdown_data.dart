class DropdownData {
  static const List<String> genders = [
    'Male',
    'Female',
    'Other'
  ];

  static const List<String> maritalStatus = [
    'Single', 'Married', 'Divorced', 'Widowed', 'Separated'
  ];

  static const List<String> religions = [
    'Hindu', 'Muslim', 'Christian', 'Sikh', 'Buddhist', 'Jain', 'Other'
  ];

  static const Map<String, List<String>> casteMap = {
    'Hindu': ['Brahmin', 'Kshatriya', 'Vaishya', 'Shudra', 'Dalit'],
    'Muslim': ['Sunni', 'Shia'],
    'Christian': ['Roman Catholic', 'Protestant', 'Orthodox'],
    'Sikh': ['Jat', 'Khatri', 'Arora'],
    'Buddhist': ['Theravada', 'Mahayana'],
    'Jain': ['Digambara', 'Shwetambara'],
    'Other': ['Other']
  };

  static const Map<String, List<String>> subCasteMap = {
    'Brahmin': ['Iyengar', 'Iyer', 'Gaur', 'Kanyakubja', 'Other'],
    'Kshatriya': ['Rajput', 'Maratha', 'Thakur', 'Other'],
    'Vaishya': ['Agarwal', 'Gupta', 'Maheshwari', 'Other'],
    'Shudra': ['Yadav', 'Koli', 'Nai', 'Other'],
    'Dalit': ['Chamar', 'Valmiki', 'Mahar', 'Other'],
    'Sunni': ['Hanafi', 'Maliki', 'Shafi', 'Hanbali'],
    'Shia': ['Ithna Ashari', 'Ismaili', 'Dawoodi Bohra'],
    'Roman Catholic': ['Latin Catholic', 'Syro Malabar', 'Other'],
    'Protestant': ['Baptist', 'Pentecostal', 'Methodist', 'Other'],
    'Orthodox': ['Greek Orthodox', 'Syrian Orthodox', 'Other'],
    'Jat': ['Sidhu', 'Sandhu', 'Dhillon', 'Other'],
    'Khatri': ['Ahluwalia', 'Kapoor', 'Khanna', 'Other'],
    'Arora': ['Bajaj', 'Chawla', 'Sethi', 'Other'],
    'Theravada': ['Thai', 'Burmese', 'Sri Lankan', 'Other'],
    'Mahayana': ['Tibetan', 'Zen', 'Pure Land', 'Other'],
    'Digambara': ['Bisapanthi', 'Terapanthi', 'Gumanapanthi', 'Other'],
    'Shwetambara': ['Murtipujaka', 'Sthanakvasi', 'Terapanthi', 'Other'],
    'Other': ['Other']
  };

  static const List<String> higherEducation = [
    'High School', 'Diploma', "Bachelor's Degree", "Master's Degree", 'PhD'
  ];

  static const List<String> occupations = [
    'Engineer', 'Doctor', 'Teacher', 'Business', 'Government Employee', 'Freelancer', 'Other'
  ];

  static const Map<String, List<String>> countryStateMap = {
    'USA': ['California', 'Texas', 'New York', 'Florida', 'Illinois'],
    'India': ['Maharashtra', 'Karnataka', 'Tamil Nadu', 'Delhi', 'Gujarat'],
    'Canada': ['Ontario', 'Quebec', 'British Columbia', 'Alberta', 'Manitoba'],
    'UK': ['England', 'Scotland', 'Wales', 'Northern Ireland', 'Northern England'],
    'Australia': ['New South Wales', 'Victoria', 'Queensland', 'Western Australia', 'South Australia'],
  };

  static const List<String> countries = [
    'USA', 'India', 'Canada', 'UK', 'Australia'
  ];

  static const Map<String, List<String>> stateCityMap = {
    // USA
    'California': ['Los Angeles', 'San Francisco', 'San Diego', 'Sacramento', 'San Jose'],
    'Texas': ['Houston', 'Dallas', 'Austin', 'San Antonio', 'Fort Worth'],
    'New York': ['New York City', 'Buffalo', 'Rochester', 'Albany', 'Syracuse'],
    'Florida': ['Miami', 'Orlando', 'Tampa', 'Jacksonville', 'Fort Lauderdale'],
    'Illinois': ['Chicago', 'Springfield', 'Peoria', 'Naperville', 'Rockford'],

    // India
    'Maharashtra': ['Mumbai', 'Pune', 'Nagpur', 'Nashik', 'Aurangabad'],
    'Karnataka': ['Bangalore', 'Mysore', 'Mangalore', 'Hubli', 'Belgaum'],
    'Tamil Nadu': ['Chennai', 'Coimbatore', 'Madurai', 'Tiruchirappalli', 'Salem'],
    'Delhi': ['New Delhi', 'Rohini', 'Dwarka', 'Karol Bagh', 'Pitampura'],
    'Gujarat': ['Ahmedabad', 'Surat', 'Rajkot', 'Porbandar', 'Junagadh'],

    // Canada
    'Ontario': ['Toronto', 'Ottawa', 'Mississauga', 'Brampton', 'Hamilton'],
    'Quebec': ['Montreal', 'Quebec City', 'Laval', 'Gatineau', 'Sherbrooke'],
    'British Columbia': ['Vancouver', 'Victoria', 'Surrey', 'Burnaby', 'Richmond'],
    'Alberta': ['Calgary', 'Edmonton', 'Red Deer', 'Lethbridge', 'Medicine Hat'],
    'Manitoba': ['Winnipeg', 'Brandon', 'Steinbach', 'Thompson', 'Portage la Prairie'],

    // UK
    'England': ['London', 'Manchester', 'Birmingham', 'Liverpool', 'Bristol'],
    'Scotland': ['Edinburgh', 'Glasgow', 'Aberdeen', 'Dundee', 'Inverness'],
    'Wales': ['Cardiff', 'Swansea', 'Newport', 'Wrexham', 'Bangor'],
    'Northern Ireland': ['Belfast', 'Derry', 'Lisburn', 'Newtownabbey', 'Bangor'],
    'Northern England': ['Leeds', 'Sheffield', 'Newcastle', 'York', 'Durham'],

    // Australia
    'New South Wales': ['Sydney', 'Newcastle', 'Wollongong', 'Tamworth', 'Gosford'],
    'Victoria': ['Melbourne', 'Geelong', 'Ballarat', 'Bendigo', 'Shepparton'],
    'Queensland': ['Brisbane', 'Gold Coast', 'Cairns', 'Townsville', 'Rockhampton'],
    'Western Australia': ['Perth', 'Mandurah', 'Bunbury', 'Geraldton', 'Albany'],
    'South Australia': ['Adelaide', 'Mount Gambier', 'Whyalla', 'Murray Bridge', 'Port Augusta'],
  };
}

class User {
  final String imagePath;
  final String name;
  final String email;
  final String phone;
  final String department;
  final String degree;
  final String year_of_entry;
  final bool isDarkMode;

  const User({
    required this.imagePath,
    required this.name,
    required this.email,
    required this.phone,
    required this.department,
    required this.degree,
    required this.year_of_entry,
    required this.isDarkMode,
  });
}

class GuardUser{
  final String imagePath;
  final String name;
  final String email;
  final String location;
  final bool isDarkMode;

  const GuardUser({
    required this.imagePath,
    required this.name,
    required this.email,
    required this.location,
    required this.isDarkMode,
  });
}
class AuthorityUser{
  final String imagePath;
  final String name;
  final String email;
  final String designation;
  final bool isDarkMode;

  const AuthorityUser({
    required this.imagePath,
    required this.name,
    required this.email,
    required this.designation,
    required this.isDarkMode,
  });
}
class AdminUser{
  final String imagePath;
  final String name;
  final String email;
  final bool isDarkMode;

  const AdminUser({
    required this.imagePath,
    required this.name,
    required this.email,
    required this.isDarkMode,
  });
}
enum UserRole {
  user,
  vendor;

  String toMap() => name;

  static UserRole fromMap(String role) {
    return UserRole.values.firstWhere(
      (e) => e.name == role,
      orElse: () => UserRole.user,
    );
  }

  @override
  String toString() {
    switch (this) {
      case UserRole.user:
        return 'User';
      case UserRole.vendor:
        return 'Vendor';
    }
  }
}

/// Enum representing form fields used throughout the application
///
/// Using an enum instead of string literals provides compile-time safety,
/// easier refactoring, and IDE auto-completion support.
enum FormFieldEnum {
  /// Email field
  email,

  /// Password field
  password,

  /// Password confirmation field
  confirmPassword,

  /// Age field
  age,

  /// First name field
  firstName,

  /// Last name field
  lastName,

  /// Date of birth field
  dob,

  /// Phone number field
  phone,

  /// Address field
  address,

  /// Notification preferences field
  notificationChannel,

  /// Terms acceptance field
  termsAccepted,
}

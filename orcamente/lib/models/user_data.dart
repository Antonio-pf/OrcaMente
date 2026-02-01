import 'package:cloud_firestore/cloud_firestore.dart';

/// Complete user data model for Firestore operations
class UserData {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? profileImageUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic>? quizAnswers;
  final Map<String, dynamic>? additionalData;

  const UserData({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.profileImageUrl,
    required this.createdAt,
    this.updatedAt,
    this.quizAnswers,
    this.additionalData,
  });

  /// Create UserData from Firestore DocumentSnapshot
  factory UserData.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception('Document data is null');
    }

    return UserData(
      id: doc.id,
      name: data['name'] as String? ?? '',
      email: data['email'] as String? ?? '',
      phone: data['phone'] as String?,
      profileImageUrl: data['profileImageUrl'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      quizAnswers: data['quizAnswers'] as Map<String, dynamic>?,
      additionalData: data['additionalData'] as Map<String, dynamic>?,
    );
  }

  /// Create UserData from Map
  factory UserData.fromMap(String id, Map<String, dynamic> data) {
    return UserData(
      id: id,
      name: data['name'] as String? ?? '',
      email: data['email'] as String? ?? '',
      phone: data['phone'] as String?,
      profileImageUrl: data['profileImageUrl'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      quizAnswers: data['quizAnswers'] as Map<String, dynamic>?,
      additionalData: data['additionalData'] as Map<String, dynamic>?,
    );
  }

  /// Convert UserData to Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      if (phone != null) 'phone': phone,
      if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      if (updatedAt != null) 'updatedAt': Timestamp.fromDate(updatedAt!),
      if (quizAnswers != null) 'quizAnswers': quizAnswers,
      if (additionalData != null) 'additionalData': additionalData,
    };
  }

  /// Convert to Map (for local storage or other uses)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      if (phone != null) 'phone': phone,
      if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
      'createdAt': createdAt.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      if (quizAnswers != null) 'quizAnswers': quizAnswers,
      if (additionalData != null) 'additionalData': additionalData,
    };
  }

  /// Validate user data
  bool isValid() {
    return name.isNotEmpty &&
        email.isNotEmpty &&
        _isValidEmail(email) &&
        (phone == null || phone!.isEmpty || _isValidPhone(phone!));
  }

  /// Get validation errors
  List<String> getValidationErrors() {
    final errors = <String>[];

    if (name.isEmpty) {
      errors.add('Nome é obrigatório');
    }

    if (email.isEmpty) {
      errors.add('E-mail é obrigatório');
    } else if (!_isValidEmail(email)) {
      errors.add('E-mail inválido');
    }

    if (phone != null && phone!.isNotEmpty && !_isValidPhone(phone!)) {
      errors.add('Telefone inválido');
    }

    return errors;
  }

  /// Copy with method for immutability
  UserData copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? profileImageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? quizAnswers,
    Map<String, dynamic>? additionalData,
  }) {
    return UserData(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      quizAnswers: quizAnswers ?? this.quizAnswers,
      additionalData: additionalData ?? this.additionalData,
    );
  }

  /// Private validation helpers
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isValidPhone(String phone) {
    // Brazilian phone validation (basic)
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    return cleanPhone.length >= 10 && cleanPhone.length <= 11;
  }

  @override
  String toString() {
    return 'UserData(id: $id, name: $name, email: $email, phone: $phone)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserData &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.phone == phone &&
        other.profileImageUrl == profileImageUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        profileImageUrl.hashCode;
  }
}

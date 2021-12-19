import 'dart:convert';

class UserModel {
  final String id;
  final String name;
  final String firstName;
  final String lastName;
  final String name_store;
  final String student_id;
  final String email;
  final String phone;
  final String sex;
  final String type;
  final String username;
  final String password;
  final String avater;
  final String profile_store;
  UserModel({
    required this.id,
    required this.name,
    required this.firstName,
    required this.lastName,
    required this.name_store,
    required this.student_id,
    required this.email,
    required this.phone,
    required this.sex,
    required this.type,
    required this.username,
    required this.password,
    required this.avater,
    required this.profile_store,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? firstName,
    String? lastName,
    String? name_store,
    String? student_id,
    String? email,
    String? phone,
    String? sex,
    String? type,
    String? username,
    String? password,
    String? avater,
    String? profile_store,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      name_store: name_store ?? this.name_store,
      student_id: student_id ?? this.student_id,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      sex: sex ?? this.sex,
      type: type ?? this.type,
      username: username ?? this.username,
      password: password ?? this.password,
      avater: avater ?? this.avater,
      profile_store: profile_store ?? this.profile_store,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'firstName': firstName,
      'lastName': lastName,
      'name_store': name_store,
      'student_id': student_id,
      'email': email,
      'phone': phone,
      'sex': sex,
      'type': type,
      'username': username,
      'password': password,
      'avater': avater,
      'profile_store': profile_store,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      name_store: map['name_store'] ?? '',
      student_id: map['student_id'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      sex: map['sex'] ?? '',
      type: map['type'] ?? '',
      username: map['username'] ?? '',
      password: map['password'] ?? '',
      avater: map['avater'] ?? '',
      profile_store: map['profile_store'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, firstName: $firstName, lastName: $lastName, name_store: $name_store, student_id: $student_id, email: $email, phone: $phone, sex: $sex, type: $type, username: $username, password: $password, avater: $avater, profile_store: $profile_store)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.id == id &&
        other.name == name &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.name_store == name_store &&
        other.student_id == student_id &&
        other.email == email &&
        other.phone == phone &&
        other.sex == sex &&
        other.type == type &&
        other.username == username &&
        other.password == password &&
        other.avater == avater &&
        other.profile_store == profile_store;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        name_store.hashCode ^
        student_id.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        sex.hashCode ^
        type.hashCode ^
        username.hashCode ^
        password.hashCode ^
        avater.hashCode ^
        profile_store.hashCode;
  }
}

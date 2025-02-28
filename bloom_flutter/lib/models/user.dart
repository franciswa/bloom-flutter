import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

/// User model
@JsonSerializable()
class User extends Equatable {
  /// User ID
  final String id;

  /// User email
  final String email;

  /// User phone
  final String? phone;

  /// User created at
  final DateTime createdAt;

  /// User updated at
  final DateTime updatedAt;

  /// User last sign in
  final DateTime? lastSignIn;

  /// User email confirmed
  final bool emailConfirmed;

  /// User phone confirmed
  final bool phoneConfirmed;

  /// User banned
  final bool banned;

  /// User deleted
  final bool deleted;

  /// Creates a new [User] instance
  const User({
    required this.id,
    required this.email,
    this.phone,
    required this.createdAt,
    required this.updatedAt,
    this.lastSignIn,
    required this.emailConfirmed,
    required this.phoneConfirmed,
    required this.banned,
    required this.deleted,
  });

  /// Creates a new [User] instance from JSON
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// Converts this [User] instance to JSON
  Map<String, dynamic> toJson() => _$UserToJson(this);

  /// Creates a copy of this [User] instance with the given fields replaced
  User copyWith({
    String? id,
    String? email,
    String? Function()? phone,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? Function()? lastSignIn,
    bool? emailConfirmed,
    bool? phoneConfirmed,
    bool? banned,
    bool? deleted,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      phone: phone != null ? phone() : this.phone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastSignIn: lastSignIn != null ? lastSignIn() : this.lastSignIn,
      emailConfirmed: emailConfirmed ?? this.emailConfirmed,
      phoneConfirmed: phoneConfirmed ?? this.phoneConfirmed,
      banned: banned ?? this.banned,
      deleted: deleted ?? this.deleted,
    );
  }

  /// Empty date time
  static final _emptyDateTime = DateTime.utc(1970);

  /// Empty user
  static final empty = User(
    id: '',
    email: '',
    phone: null,
    createdAt: _emptyDateTime,
    updatedAt: _emptyDateTime,
    lastSignIn: null,
    emailConfirmed: false,
    phoneConfirmed: false,
    banned: false,
    deleted: false,
  );

  /// Is empty
  bool get isEmpty => this == User.empty;

  /// Is not empty
  bool get isNotEmpty => this != User.empty;

  @override
  List<Object?> get props => [
        id,
        email,
        phone,
        createdAt,
        updatedAt,
        lastSignIn,
        emailConfirmed,
        phoneConfirmed,
        banned,
        deleted,
      ];
}

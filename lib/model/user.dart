import 'dart:convert';

import 'package:baustaka/config/env.dart';
import 'package:baustaka/db/type_id.dart';
import 'package:baustaka/helper/base_object.dart';
import 'package:baustaka/helper/extension.dart';
import 'package:baustaka/helper/session.dart';
import 'package:baustaka/model/balance.dart';
import 'package:baustaka/model/file.dart';
import 'package:hive/hive.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@HiveType(typeId: TypeId.kUser)
@JsonSerializable()
class User extends BaseObject {
  @HiveField(BaseObject.kBaseHiveIndex)
  String? uid;
  String? displayName;
  String? username;
  String? email;
  String? phoneNumber;
  String? countryIso2;
  String? countryCode;
  File? avatar;
  List<UserRole>? roles;
  UserStatus? status;
  int? notifications;

  String? gender;
  DateTime? dob;
  List<String>? preferences;
  Balance? balance;
  String? referralCode;
  int? withdrawalRate;
  int? points;
  // int? badges;
  // int? points;
  int? orders, storys, storysViewed;
  int? neighbourhoodPosts;
  bool? limitWithinRadius;
  double? radius;
  List<double>? lngLat;
  bool? verified;
  UserPrivacy? privacy;
  String? description;

  User({
    this.uid,
    this.displayName,
    this.username,
    this.email,
    this.phoneNumber,
    // ... include all fields you want to initialize
  });

  bool get isAdmin => roles?.contains(UserRole.admin) == true;

  bool get hasStorys => (storys ?? 0) > 0;

  bool get hasNotViewedStorys => (storys ?? 0) > (storysViewed ?? 0);

  String get summary => '$displayName · ${orders?.wrap()} Orders';

  String get firstName => displayName!.split(' ').first;

  bool get isSelf => Session.user != null && uid == Session.user!.uid;

  Country get country => countries.firstWhere(
        (element) => element.code == countryIso2,
        orElse: () => Country(
          name: 'Unknown',
          flag: 'No flag',
          code: countryIso2 ?? '',
          dialCode: countryCode?.substring(1) ?? '',
          minLength: (phoneNumber?.length ?? 1) - (countryCode?.length ?? 1),
          maxLength: (phoneNumber?.length ?? 1) - (countryCode?.length ?? 1),
          nameTranslations: {},
        ),
      );

  static User fromJson(dynamic json) => _$UserFromJson(json);

  static User fromString(String json) => _$UserFromJson(jsonDecode(json));
}

enum UserRole {
  @JsonValue('admin')
  admin,
  @JsonValue('support')
  support,
}

enum UserStatus {
  @JsonValue('active')
  active,
  @JsonValue('blocked')
  blocked,
}

enum UserPrivacy {
  @JsonValue('public')
  public,
  @JsonValue('private')
  private,
}

extension UserPrivacyExtension on UserPrivacy {
  String get description {
    switch (this) {
      case UserPrivacy.public:
        return 'When your account is public, your profile and posts can be seen by anyone, on or off $kAppName, even if they don`t have a $kAppName account.';
      case UserPrivacy.private:
        return 'When your account is private, only the followers that you approve can see what you share, including your posts.';
    }
  }
}

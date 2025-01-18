// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 1;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User()..uid = fields[3] as String?;
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(1)
      ..writeByte(3)
      ..write(obj.uid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User()
  ..id = json['_id'] as String?
  ..reference = json['reference'] as String?
  ..createdAt = json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String)
  ..updatedAt = json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String)
  ..deleted = json['deleted'] as bool?
  ..uid = json['uid'] as String?
  ..displayName = json['displayName'] as String?
  ..username = json['username'] as String?
  ..email = json['email'] as String?
  ..phoneNumber = json['phoneNumber'] as String?
  ..countryIso2 = json['countryIso2'] as String?
  ..countryCode = json['countryCode'] as String?
  ..avatar = json['avatar'] == null
      ? null
      : File.fromJson(json['avatar'] as Map<String, dynamic>)
  ..roles = (json['roles'] as List<dynamic>?)
      ?.map((e) => $enumDecode(_$UserRoleEnumMap, e))
      .toList()
  ..status = $enumDecodeNullable(_$UserStatusEnumMap, json['status'])
  ..notifications = (json['notifications'] as num?)?.toInt()
  ..gender = json['gender'] as String?
  ..dob = json['dob'] == null ? null : DateTime.parse(json['dob'] as String)
  ..preferences =
      (json['preferences'] as List<dynamic>?)?.map((e) => e as String).toList()
  ..balance = json['balance'] == null
      ? null
      : Balance.fromJson(json['balance'] as Map<String, dynamic>)
  ..referralCode = json['referralCode'] as String?
  ..withdrawalRate = (json['withdrawalRate'] as num?)?.toInt()
  ..points = (json['points'] as num?)?.toInt()
  ..orders = (json['orders'] as num?)?.toInt()
  ..storys = (json['storys'] as num?)?.toInt()
  ..storysViewed = (json['storysViewed'] as num?)?.toInt()
  ..neighbourhoodPosts = (json['neighbourhoodPosts'] as num?)?.toInt()
  ..limitWithinRadius = json['limitWithinRadius'] as bool?
  ..radius = (json['radius'] as num?)?.toDouble()
  ..lngLat = (json['lngLat'] as List<dynamic>?)
      ?.map((e) => (e as num).toDouble())
      .toList()
  ..verified = json['verified'] as bool?
  ..privacy = $enumDecodeNullable(_$UserPrivacyEnumMap, json['privacy'])
  ..description = json['description'] as String?;

const _$UserRoleEnumMap = {
  UserRole.admin: 'admin',
  UserRole.support: 'support',
};

const _$UserStatusEnumMap = {
  UserStatus.active: 'active',
  UserStatus.blocked: 'blocked',
};

const _$UserPrivacyEnumMap = {
  UserPrivacy.public: 'public',
  UserPrivacy.private: 'private',
};

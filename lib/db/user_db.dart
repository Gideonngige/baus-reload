import 'package:baustaka/config/key.dart';
import 'package:baustaka/db/type_id.dart';
import 'package:baustaka/model/user.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserDb {
  static Future<Box<User>> users() async {
    return await Hive.openBox<User>(TypeId.kUser.toString());
  }

  /// Save user data to local storage
  static Future<void> saveUser(User user) async {
    try {
      var box = await UserDb.users();
      await box.put('current_user', user);
      print('User data saved to cache: ${user.displayName}');
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  /// Get cached user data
  static Future<User?> getCachedUser() async {
    try {
      var box = await UserDb.users();
      var cachedUser = box.get('current_user');
      if (cachedUser != null) {
        print('User data loaded from cache: ${cachedUser.displayName}');
      }
      return cachedUser;
    } catch (e) {
      print('Error loading cached user data: $e');
      return null;
    }
  }

  /// Clear cached user data (for logout)
  static Future<void> clearUser() async {
    try {
      var box = await UserDb.users();
      await box.delete('current_user');
      print('User data cleared from cache');
    } catch (e) {
      print('Error clearing user data: $e');
    }
  }

  /// Update specific user fields
  static Future<void> updateUserField(String field, dynamic value) async {
    try {
      var box = await UserDb.users();
      var currentUser = box.get('current_user');
      if (currentUser != null) {
        // Create a copy of the current user with the updated field
        var updatedUser = User(
          uid: currentUser.uid,
          displayName: field == 'displayName' ? value : currentUser.displayName,
          username: field == 'username' ? value : currentUser.username,
          email: field == 'email' ? value : currentUser.email,
          phoneNumber: field == 'phoneNumber' ? value : currentUser.phoneNumber,
        );
        
        // Copy over other fields that aren't in the constructor
        updatedUser.countryIso2 = currentUser.countryIso2;
        updatedUser.countryCode = currentUser.countryCode;
        updatedUser.avatar = currentUser.avatar;
        updatedUser.roles = currentUser.roles;
        updatedUser.status = currentUser.status;
        updatedUser.notifications = currentUser.notifications;
        updatedUser.gender = currentUser.gender;
        updatedUser.dob = currentUser.dob;
        updatedUser.preferences = currentUser.preferences;
        updatedUser.balance = currentUser.balance;
        updatedUser.referralCode = currentUser.referralCode;
        updatedUser.withdrawalRate = currentUser.withdrawalRate;
        updatedUser.points = currentUser.points;
        updatedUser.orders = currentUser.orders;
        updatedUser.storys = currentUser.storys;
        updatedUser.storysViewed = currentUser.storysViewed;
        updatedUser.neighbourhoodPosts = currentUser.neighbourhoodPosts;
        updatedUser.limitWithinRadius = currentUser.limitWithinRadius;
        updatedUser.radius = currentUser.radius;
        updatedUser.lngLat = currentUser.lngLat;
        updatedUser.verified = currentUser.verified;
        updatedUser.privacy = currentUser.privacy;
        updatedUser.description = currentUser.description;
        
        await box.put('current_user', updatedUser);
        print('User field $field updated in cache');
      }
    } catch (e) {
      print('Error updating user field: $e');
    }
  }

  /// Check if user data exists in cache
  static Future<bool> hasUserData() async {
    try {
      var box = await UserDb.users();
      return box.containsKey('current_user');
    } catch (e) {
      print('Error checking user data: $e');
      return false;
    }
  }
} 
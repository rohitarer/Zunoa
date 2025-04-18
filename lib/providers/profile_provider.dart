// 📄 profile_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zunoa/services/firebase_service.dart';

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((
  ref,
) {
  return ProfileNotifier();
});

class ProfileState {
  final String? fullName;
  final String? nickName;
  final String? email;
  final String? gender;
  final String? dob;
  final String? phone;
  final String? profileImageUrl;
  final bool isProfileComplete;
  final bool isLoading;
  final String? error;

  ProfileState({
    this.fullName,
    this.nickName,
    this.email,
    this.gender,
    this.dob,
    this.phone,
    this.profileImageUrl,
    this.isProfileComplete = false,
    this.isLoading = false,
    this.error,
  });

  ProfileState copyWith({
    String? fullName,
    String? nickName,
    String? email,
    String? gender,
    String? dob,
    String? phone,
    String? profileImageUrl,
    bool? isProfileComplete,
    bool? isLoading,
    String? error,
  }) {
    return ProfileState(
      fullName: fullName ?? this.fullName,
      nickName: nickName ?? this.nickName,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      phone: phone ?? this.phone,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier() : super(ProfileState());

  Future<void> fetchProfileData() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw Exception("User not logged in");

      final userData = await firebaseService.fetchUserData(uid);
      state = state.copyWith(
        fullName: userData['fullName'],
        nickName: userData['nickName'],
        email: userData['email'],
        gender: userData['gender'],
        dob: userData['dob'],
        phone: userData['phone'],
        profileImageUrl: userData['profileImageUrl'],
        isProfileComplete: userData['isProfileComplete'] ?? false,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updateProfileData({
    required String fullName,
    required String nickName,
    required String gender,
    required String dob,
    required String email,
    required String phone,
    String? profileImageUrl,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw Exception("User not logged in");

      await firebaseService.updateUserProfile(
        uid: uid,
        fullName: fullName,
        nickName: nickName,
        gender: gender,
        dob: dob,
        email: email,
        phone: phone,
        profileImageUrl: profileImageUrl,
      );

      await firebaseService.markProfileComplete(uid);

      state = state.copyWith(
        fullName: fullName,
        nickName: nickName,
        gender: gender,
        dob: dob,
        email: email,
        phone: phone,
        profileImageUrl: profileImageUrl,
        isProfileComplete: true,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void updateProfileImage(String base64Image) {
    state = state.copyWith(profileImageUrl: base64Image);
  }
}

// 📄 auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zunoa/services/firebase_service.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthState {
  final bool isLoading;
  final String? errorMessage;
  final User? user;
  final bool isInitialized;

  AuthState({
    this.isLoading = false,
    this.errorMessage,
    this.user,
    this.isInitialized = false,
  });

  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    User? user,
    bool? isInitialized,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      user: user ?? this.user,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthNotifier() : super(AuthState()) {
    _auth.authStateChanges().listen((user) {
      state = state.copyWith(user: user, isInitialized: true);
    });
  }

  Future<void> signUp(String email, String password, String fullName) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      UserCredential result = await firebaseService.signUpWithEmail(
        email: email,
        password: password,
        fullName: fullName,
      );
      state = state.copyWith(user: result.user);
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(errorMessage: e.message);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      UserCredential result = await firebaseService.loginWithEmail(
        email: email,
        password: password,
      );
      state = state.copyWith(user: result.user);
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(errorMessage: e.message);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    state = state.copyWith(user: null);
  }

  User? get currentUser => _auth.currentUser;
}

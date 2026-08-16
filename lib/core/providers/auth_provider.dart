import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final bool isSignUp;
  final bool isLoading;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final bool rememberMe;
  final String? errorMessage;
  final String? userEmail;

  AuthState({
    this.isSignUp = false,
    this.isLoading = false,
    this.isPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
    this.rememberMe = true,
    this.errorMessage,
    this.userEmail,
  });

  AuthState copyWith({
    bool? isSignUp,
    bool? isLoading,
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
    bool? rememberMe,
    String? errorMessage,
    String? userEmail,
  }) {
    return AuthState(
      isSignUp: isSignUp ?? this.isSignUp,
      isLoading: isLoading ?? this.isLoading,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isConfirmPasswordVisible: isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      rememberMe: rememberMe ?? this.rememberMe,
      errorMessage: errorMessage,
      userEmail: userEmail ?? this.userEmail,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  void toggleAuthMode() {
    state = state.copyWith(isSignUp: !state.isSignUp, errorMessage: null);
  }

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  void toggleConfirmPasswordVisibility() {
    state = state.copyWith(isConfirmPasswordVisible: !state.isConfirmPasswordVisible);
  }

  void toggleRememberMe(bool? val) {
    state = state.copyWith(rememberMe: val ?? false);
  }

  Future<bool> submitAuth({
    required String email,
    required String password,
    String? fullName,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1500));

    if (email.isEmpty || !email.contains('@')) {
      state = state.copyWith(isLoading: false, errorMessage: 'Please enter a valid email address.');
      return false;
    }

    if (password.length < 6) {
      state = state.copyWith(isLoading: false, errorMessage: 'Password must be at least 6 characters.');
      return false;
    }

    state = state.copyWith(isLoading: false, userEmail: email);
    return true;
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

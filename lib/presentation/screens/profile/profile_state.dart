
import 'package:fuelsense/domain/entities/auth/user.dart';

class ProfileState {
  final bool isLoading;
  final String? message;
  final User? user;

  ProfileState({this.isLoading = false, this.message, this.user});

  ProfileState copyWith({bool? isLoading, String? message, User? user}) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
      user: user ?? this.user,
    );
  }
}

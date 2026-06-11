import 'package:flutter/material.dart';
import 'package:fuelsense/data/datasources/local/entity/user_entity.dart';

class ProfileState {
  final bool isLoading;
  final String? message;
  final UserEntity? user;

  ProfileState({
    this.isLoading = false,
    this.message,
    this.user,
  });

  ProfileState copyWith({
    bool? isLoading,
    String? message,
    UserEntity? user,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
      user: user ?? this.user,
    );
  }
}

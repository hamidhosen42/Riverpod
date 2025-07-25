import 'package:client/features/auth/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_user_notifier.g.dart';

@Riverpod(keepAlive: true)
class CurrentUserNotifier extends _$CurrentUserNotifier {
  @override
  UserModel? build() {
    debugPrint("CurrentUserNotifier initialized");
    return null;
  }

  void addUser(UserModel user) {
    state = user;
  }
}
import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/features/auth/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/auth_local_repository.dart';
import '../repositories/auth_remote_repository.dart';
part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewmodel extends _$AuthViewmodel {
  late AuthRemoteRepository _authRemoteRepository;
  late AuthLocalRepository _authLocalRepository;
  late CurrentUserNotifier _currentUserNotifier;

  @override
  AsyncValue<UserModel>? build() {
    _authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
    _currentUserNotifier = ref.watch(currentUserNotifierProvider.notifier);
    return null;
  }

  Future<void> initSharedPreference() async {
    await _authLocalRepository.init();
  }

  Future<void> signUpUser({
    required String name,
    required String email,
    required String password,
  }) async {
    state = AsyncValue.loading();

    final res = await _authRemoteRepository.signup(
      name: name,
      email: email,
      password: password,
    );

    switch (res) {
      case Left(value: final l):
        state = AsyncValue.error(l.message, StackTrace.current);
        break;
      case Right(value: final r):
        state = AsyncValue.data(r);
        break;
    }
  }

  Future<void> signInUser({
    required String email,
    required String password,
  }) async {
    state = AsyncValue.loading();

    final res = await _authRemoteRepository.login(
      email: email,
      password: password,
    );

    switch (res) {
      case Left(value: final l):
        state = AsyncValue.error(l.message, StackTrace.current);
        break;
      case Right(value: final r):
        _loginSucess(r);
        break;
    }
  }

  AsyncValue<UserModel>? _loginSucess(UserModel user) {
    debugPrint("------------------------");
    debugPrint(user.token);
    _authLocalRepository.setToken(user.token);
    _currentUserNotifier.addUser(user);
    return state = AsyncValue.data(user);
  }

  Future<UserModel?> getData() async {
    state = AsyncValue.loading();

    final token = _authLocalRepository.getToken();

    if (token != null) {
      debugPrint("Token found: $token");
      final res = await _authRemoteRepository.getCurrentUserData(token);

      switch (res) {
        case Left(value: final l):
          state = AsyncValue.error(l.message, StackTrace.current);
          return null;
        case Right(value: final r):
          _getDataSuccess(r);
          return r;
      }
    }

    state = AsyncValue.error("No token found", StackTrace.current);
    return null;
  }

  AsyncValue<UserModel> _getDataSuccess(UserModel user) {
    _currentUserNotifier.addUser(user);
    return state = AsyncValue.data(user);
  }
}

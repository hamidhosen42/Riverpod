import 'package:client/features/auth/model/user_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/auth_local_repository.dart';
import '../repositories/auth_remote_repository.dart';
part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewmodel extends _$AuthViewmodel {
  late AuthRemoteRepository _authRemoteRepository;
  late AuthLocalRepository _authLocalRepository;

  @override
  AsyncValue<UserModel>? build() {
    _authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
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

    final val = switch (res) {
      Left(value: final l) => state = AsyncValue.error(
        l.message,
        StackTrace.current,
      ),
      Right(value: final r) => state = AsyncValue.data(r),
    };

    print(val);
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

    final val = switch (res) {
      Left(value: final l) => state = AsyncValue.error(
        l.message,
        StackTrace.current,
      ),
      Right(value: final r) => _loginSucess(r),
    };

    print(val);
  }

  AsyncValue<UserModel>? _loginSucess(UserModel user) {
    _authLocalRepository.setToken(user.token);
    return state = AsyncValue.data(user);
  }

  Future<UserModel?> getData() async {
    state = const AsyncValue.loading();

    final token = _authLocalRepository.getToken();

    if (token != null) {
      final res = await _authRemoteRepository.getCurrentUserData(token);

      final val = switch (res) {
        Left(value: final l) => state = AsyncValue.error(
          l.message,
          StackTrace.current,
        ),
        Right(value: final r) => _loginSucess(r),
      };

      return val!.value;
    }
    return null;
  }
}

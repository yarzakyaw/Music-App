import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mingalar_music_app/core/models/user_model.dart';
import 'package:mingalar_music_app/core/providers/current_user_notifier.dart';
import 'package:mingalar_music_app/features/auth/repositories/auth_local_repository.dart';
import 'package:mingalar_music_app/features/auth/repositories/auth_remote_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

part 'auth_view_model.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  late AuthRemoteRepository _authRemoteRepository;
  late CurrentUserNotifier _currentUserNotifier;
  late AuthLocalRepository _authLocalRepository;

  @override
  AsyncValue<UserModel>? build() {
    _authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
    _currentUserNotifier = ref.watch(currentUserNotifierProvider.notifier);
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
    return null;
  }

  Future<bool> isOffline() async {
    final List<ConnectivityResult> connectivityResult =
        await Connectivity().checkConnectivity();
    return connectivityResult.contains(ConnectivityResult.none);
  }

  /// Setting initial screen
  Future<void> setInitialScreen() async {
    if (await isOffline()) {
      final String? name = await _authLocalRepository.getName();
      final String? email = await _authLocalRepository.getEmail();
      final String? password = await _authLocalRepository.getPassWord();

      UserModel? currentUser = UserModel(username: name!);

      if (email != null && password != null) {
        _currentUserNotifier.addUser(currentUser);
      }
    } else {
      if (FirebaseAuth.instance.currentUser != null) {
        final String? name = await _authLocalRepository.getName();
        UserModel? currentUser = UserModel(
          username: name!,
          userDetails: FirebaseAuth.instance.currentUser,
        );
        final docRef = FirebaseFirestore.instance
            .collection("users")
            .doc(currentUser.userDetails!.uid)
            .get();
        bool isExist = await docRef.then((value) => value.exists);
        debugPrint(isExist.toString());
        if (isExist) _currentUserNotifier.addUser(currentUser);
      }
    }
  }

  Future<void> signupUser({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final res = await _authRemoteRepository.signupWithEmailAndPassword(
      name: name,
      email: email,
      password: password,
    );
    await _authLocalRepository.setName(name);
    await _authLocalRepository.setEmail(email);
    await _authLocalRepository.setPassWord(password);
    debugPrint('Set Credentials to Local Storage.............');

    final val = switch (res) {
      Left(value: final l) => state = AsyncValue.error(
          l.message,
          StackTrace.current,
        ),
      //Right(value: final r) => state = AsyncValue.data(r),
      Right(value: final r) => createUserWithEmail(r, name),
    };
    debugPrint(val.toString());
  }

  Future<void> createUserWithEmail(UserModel user, String name) async {
    final res = await _authRemoteRepository.createUserDB(user, name);
    final val = switch (res) {
      Left(value: final l) => state = AsyncValue.error(
          l.message,
          StackTrace.current,
        ),
      Right(value: final r) => state = AsyncValue.data(r),
    };
    debugPrint(val.toString());
  }

  Future<void> signinUser({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    if (await isOffline()) {
      final res = await _authLocalRepository.offlineSignInWithEmailAndPassword(
        name: name,
        email: email,
        password: password,
      );
      final val = switch (res) {
        Left(value: final l) => state = AsyncValue.error(
            l.message,
            StackTrace.current,
          ),
        Right(value: final r) => _loginSuccess(r),
      };
      debugPrint(val.toString());
    } else {
      final res = await _authRemoteRepository.signingInWithEmailAndPassword(
        name: name,
        email: email,
        password: password,
      );
      await _authLocalRepository.setName(name);
      await _authLocalRepository.setEmail(email);
      await _authLocalRepository.setPassWord(password);
      debugPrint('Set Credentials to Local Storage.............');
      final val = switch (res) {
        Left(value: final l) => state = AsyncValue.error(
            l.message,
            StackTrace.current,
          ),
        Right(value: final r) => _loginSuccess(r),
      };
      debugPrint(val.toString());
    }
  }

  AsyncValue<UserModel>? _loginSuccess(UserModel user) {
    //_authLocalRepository.setToken(user.token);
    _currentUserNotifier.addUser(user);
    return state = AsyncValue.data(user);
  }

  Future<void> signoutUser() async {
    await _authRemoteRepository.signingOut();
  }
}

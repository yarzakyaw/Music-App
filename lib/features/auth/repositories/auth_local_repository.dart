import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mingalar_music_app/core/constants/firebase_exceptions.dart';
import 'package:mingalar_music_app/core/failure/app_failure.dart';
import 'package:mingalar_music_app/core/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_local_repository.g.dart';

@riverpod
AuthLocalRepository authLocalRepository(Ref ref) {
  return AuthLocalRepository();
}

class AuthLocalRepository {
  final storage = const FlutterSecureStorage();

  final String _keyName = 'name';
  final String _keyEmail = 'email';
  final String _keyPassWord = 'password';

  Future setName(String name) async {
    await storage.write(key: _keyName, value: name);
  }

  Future<String?> getName() async {
    return await storage.read(key: _keyName);
  }

  Future setEmail(String email) async {
    await storage.write(key: _keyEmail, value: email);
  }

  Future<String?> getEmail() async {
    return await storage.read(key: _keyEmail);
  }

  Future setPassWord(String password) async {
    await storage.write(key: _keyPassWord, value: password);
  }

  Future<String?> getPassWord() async {
    return await storage.read(key: _keyPassWord);
  }

  /// [OfflineAuthentication] - SIGNIN
  Future<Either<AppFailure, UserModel>> offlineSignInWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    final String? securedName = await getName();
    final String? securedPassword = await getPassWord();
    final String? securedEmail = await getEmail();

    UserModel currentUser;

    try {
      if (securedName == name &&
          securedPassword == password &&
          securedEmail == email) {
        currentUser = UserModel(username: name);
        return Right(currentUser);
      }
      return Left(AppFailure(const FirebaseExceptions().message));
    } on FirebaseAuthException catch (e) {
      return Left(AppFailure(FirebaseExceptions.fromCode(e.code).message));
    } catch (_) {
      return Left(AppFailure(const FirebaseExceptions().message));
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mingalar_music_app/core/constants/firebase_exceptions.dart';
import 'package:mingalar_music_app/core/failure/app_failure.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mingalar_music_app/core/models/user_info_model.dart';
import 'package:mingalar_music_app/core/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_remote_repository.g.dart';

@riverpod
AuthRemoteRepository authRemoteRepository(Ref ref) {
  return AuthRemoteRepository();
}

class AuthRemoteRepository {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  //late User _firebaseUser;

  /// [EmailAuthentication] - REGISTER
  Future<Either<AppFailure, UserModel>> signupWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    //User registeredUser;
    UserModel registeredUser;
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      //registeredUser = userCredential.user!;
      registeredUser =
          UserModel(username: name, userDetails: userCredential.user);
      //await sendEmailVerification();
      return Right(registeredUser);
    } on FirebaseAuthException catch (e) {
      return Left(AppFailure(FirebaseExceptions.fromCode(e.code).message));
    } catch (_) {
      return Left(AppFailure(const FirebaseExceptions().message));
    }
  }

  /// [EmailVerification] - EMAIL VERIFICATION
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser!.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      Left(AppFailure(FirebaseExceptions.fromCode(e.code).message));
    } catch (_) {
      Left(AppFailure(const FirebaseExceptions().message));
    }
  }

  Future<Either<AppFailure, UserModel>> createUserDB(
      UserModel user, String name) async {
    try {
      await _db.collection("users").doc(user.userDetails!.uid).set(
        {
          'userId': user.userDetails!.uid,
          'name': name,
          'email': user.userDetails!.email,
          'ownedAccountId': "",
          'ownedAccountIsIn': "",
          'totalFollowing': 0,
          'vault': 0,
          'createdAt': DateTime.now(),
          'accountType': "user"
        },
      );
      return Right(user);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  /// [EmailAuthentication] - SIGNIN
  Future<Either<AppFailure, UserModel>> signingInWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    // User currentUser;
    UserModel currentUser;
    try {
      UserCredential currentUserCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // currentUser = currentUserCredential.user!;
      currentUser =
          UserModel(username: name, userDetails: currentUserCredential.user);
      return Right(currentUser);
    } on FirebaseAuthException catch (e) {
      return Left(AppFailure(FirebaseExceptions.fromCode(e.code).message));
    } catch (_) {
      return Left(AppFailure(const FirebaseExceptions().message));
    }
  }

  // [LogoutUser] - Valid for any authentication.
  Future<void> signingOut() async {
    try {
      //await GoogleSignIn().signOut();
      //await FacebookAuth.instance.logOut();
      _auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw Left(AppFailure(FirebaseExceptions.fromCode(e.code).message));
    } catch (_) {
      throw Left(AppFailure(const FirebaseExceptions().message));
    }
  }

  Future<Either<AppFailure, UserInfoModel>> getUserInfo({
    required String userId,
  }) async {
    // User currentUser;
    UserInfoModel currentUser;
    try {
      DocumentSnapshot userDoc =
          await _db.collection('users').doc(userId).get();
      currentUser =
          UserInfoModel.fromMap(userDoc.data() as Map<String, dynamic>);
      return Right(currentUser);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}

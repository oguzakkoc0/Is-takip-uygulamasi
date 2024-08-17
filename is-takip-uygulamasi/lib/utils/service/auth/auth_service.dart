import 'package:firebase_auth/firebase_auth.dart';
import 'package:staj_proje_1/utils/service/auth/i_auth_service.dart';

class AuthService implements IAuthService {
  @override
  Future<User?> signIn(String email, String password) {
    throw UnimplementedError();
  }

  @override
  Future<User?> signUp(String email, String password) {
    throw UnimplementedError();
  }

  @override
  Future<void> logOut() {
    throw UnimplementedError();
  }
}

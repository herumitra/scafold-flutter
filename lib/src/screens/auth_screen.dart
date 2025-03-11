import 'package:flutter/material.dart';
import 'package:animated_login/animated_login.dart';
import 'package:vimedika/src/utils/constants.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedLogin(
        onLogin: _loginUser,
        onSignup: _registerUser,
        showForgotPassword: false,
        // signUpMode: SignUpModes.disabled,
        validateEmail: false,
        loginTexts: LoginTexts(
          loginFormTitle: 'VIMEDIKA Login',
          signUpFormTitle: 'Buat Akun Baru',
          forgotPassword: '',
          loginEmailHint: 'Username',
        ), // Supaya tombol lupa password tidak muncul
        logo: Image.asset('assets/images/ziida.png', width: 100, height: 100),
        emailValidator: ValidatorModel(
          validatorCallback: (value) {
            if (value == null || value.isEmpty) return 'Username wajib diisi';
            return '';
          },
        ),
        passwordValidator: ValidatorModel(
          validatorCallback: (value) {
            if (value == null || value.length < 6) return 'Minimal 6 karakter';
            return '';
          },
        ),
        loginDesktopTheme: LoginViewTheme(
          emailIcon: Icon(Icons.person, color: ViColors.mainDefault),
          passwordIcon: Icon(Icons.lock, color: ViColors.mainDefault),
          backgroundColor: ViColors.mainDefault,
          formFieldBackgroundColor: Colors.white,
          formTitleStyle: TextStyle(
            color: ViColors.mainDefault,
            fontWeight: FontWeight.bold,
          ),
          actionButtonStyle: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(ViColors.mainDefault),
            foregroundColor: MaterialStateProperty.all(ViColors.whiteColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35.0),
                side: BorderSide(color: ViColors.mainDefault),
              ),
            ),
          ),
        ),
        loginMobileTheme: LoginViewTheme(
          emailIcon: Icon(Icons.person, color: ViColors.mainDefault),
          passwordIcon: Icon(Icons.lock, color: ViColors.mainDefault),
          backgroundColor: ViColors.mainDefault,
          formFieldBackgroundColor: Colors.white,
          formTitleStyle: TextStyle(
            color: ViColors.mainDefault,
            fontWeight: FontWeight.bold,
          ),
          actionButtonStyle: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(ViColors.whiteColor),
            foregroundColor: MaterialStateProperty.all(ViColors.mainDefault),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35.0),
                side: BorderSide(color: ViColors.whiteColor),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> _loginUser(LoginData data) async {
    debugPrint('Username: ${data.email}, Password: ${data.password}');
    return null; // Return null jika sukses, atau string error jika gagal
  }

  Future<String?> _registerUser(SignUpData data) async {
    debugPrint('Username: ${data.email}, Password: ${data.password}');
    return null; // Return null jika sukses, atau string error jika gagal
  }
}

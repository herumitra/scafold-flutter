import 'package:flutter/material.dart';
import 'package:animated_login/animated_login.dart';
import '../utils/constants.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedLogin(
        onLogin: _loginUser,
        onSignup: _registerUser,
        showForgotPassword: false,
        validateEmail: false,
        loginTexts: LoginTexts(
          loginFormTitle: 'VIMEDIKA Login',
          forgotPassword: '',
          loginEmailHint: 'Username',
          nameHint: 'Nama Lengkap',
          signupEmailHint: 'Username',
          welcomeBackDescription: 'Please contact us if you encounter any issues at support@vimedika.com',
          privacyPolicyLink: 'http://vimedika.com',
          termsConditionsLink: 'http://vimedika.com'
        ), 
        logo: Image.asset(
            'assets/images/ziida.png',
          ),
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
          logoSize: Size(200, 200),
          nameIcon: Icon(Icons.perm_contact_cal_outlined, color: ViColors.mainDefault),
          emailIcon: Icon(Icons.perm_identity, color: ViColors.mainDefault),
          passwordIcon: Icon(Icons.lock_outline, color: ViColors.mainDefault),          
          backgroundColor: ViColors.mainDefault,
          formFieldBackgroundColor: Colors.white,
          formTitleStyle: TextStyle(
            color: ViColors.mainDefault,
            fontWeight: FontWeight.bold,
            fontSize: 35
          ),
          changeActionButtonStyle: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(ViColors.whiteColor),
            foregroundColor: MaterialStateProperty.all(ViColors.mainDefault),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35.0),
                side: BorderSide(color: ViColors.mainDefault),
              ),
            ),
          
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
          logoSize: Size(125, 125),          
          nameIcon: Icon(Icons.perm_contact_cal_outlined, color: ViColors.mainDefault),
          emailIcon: Icon(Icons.perm_identity, color: ViColors.mainDefault),
          passwordIcon: Icon(Icons.lock_outline, color: ViColors.mainDefault),          
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

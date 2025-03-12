import 'package:flutter/material.dart';
import 'package:animated_login/animated_login.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:secure_application/secure_application.dart';
import 'package:page_transition/page_transition.dart';
import '../utils/constants.dart';
import '../screens/branches_list.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SecureApplication(
      child: Scaffold(
        body: AnimatedLogin(
          onLogin: (data) => _loginUser(context, data),
          onSignup: _registerUser,
          showForgotPassword: false,
          validateEmail: false,
          loginTexts: LoginTexts(
            loginFormTitle: 'VIMEDIKA Login',
            forgotPassword: '',
            loginEmailHint: 'Username',
            nameHint: 'Nama Lengkap',
            signupEmailHint: 'Username',
            welcomeBackDescription:
                'Please contact us if you encounter any issues at support@vimedika.com',
            privacyPolicyLink: 'http://vimedika.com',
            termsConditionsLink: 'http://vimedika.com',
          ),
          logo: Image.asset('assets/images/ziida.png'),
          emailValidator: ValidatorModel(
            validatorCallback: (value) {
              if (value == null || value.isEmpty) {
                return 'Username wajib diisi';
              }
              return '';
            },
          ),
          passwordValidator: ValidatorModel(
            validatorCallback: (value) {
              if (value == null || value.length < 6) {
                return 'Minimal 6 karakter';
              }
              return '';
            },
          ),
          loginDesktopTheme: LoginViewTheme(
            logoSize: const Size(200, 200),
            nameIcon: Icon(
              Icons.perm_contact_cal_outlined,
              color: ViColors.mainDefault,
            ),
            emailIcon: Icon(Icons.perm_identity, color: ViColors.mainDefault),
            passwordIcon: Icon(Icons.lock_outline, color: ViColors.mainDefault),
            backgroundColor: ViColors.mainDefault,
            formFieldBackgroundColor: Colors.white,
            formTitleStyle: TextStyle(
              color: ViColors.mainDefault,
              fontWeight: FontWeight.bold,
              fontSize: 35,
            ),
            changeActionButtonStyle: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(ViColors.whiteColor),
              foregroundColor: WidgetStateProperty.all(ViColors.mainDefault),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35.0),
                  side: BorderSide(color: ViColors.mainDefault),
                ),
              ),
            ),
            actionButtonStyle: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(ViColors.mainDefault),
              foregroundColor: WidgetStateProperty.all(ViColors.whiteColor),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35.0),
                  side: BorderSide(color: ViColors.mainDefault),
                ),
              ),
            ),
          ),
          loginMobileTheme: LoginViewTheme(
            logoSize: const Size(125, 125),
            nameIcon: Icon(
              Icons.perm_contact_cal_outlined,
              color: ViColors.mainDefault,
            ),
            emailIcon: Icon(Icons.perm_identity, color: ViColors.mainDefault),
            passwordIcon: Icon(Icons.lock_outline, color: ViColors.mainDefault),
            backgroundColor: ViColors.mainDefault,
            formFieldBackgroundColor: Colors.white,
            formTitleStyle: TextStyle(
              color: ViColors.mainDefault,
              fontWeight: FontWeight.bold,
            ),
            actionButtonStyle: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(ViColors.whiteColor),
              foregroundColor: WidgetStateProperty.all(ViColors.mainDefault),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35.0),
                  side: BorderSide(color: ViColors.whiteColor),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> _loginUser(BuildContext context, LoginData data) async {
    try {
      final dio = Dio();
      final response = await dio.post(
        'http://vimedika.com:4001/login',
        data: {"username": data.email, "password": data.password},
        options: Options(headers: {"Content-Type": "application/json"}),
      );

      if (response.data['status'] == 'success') {
        final token = response.data['data'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('tokenJWT', token);
        debugPrint('Login sukses, token disimpan: $token');
        _fetchBranches(context, token);
        return null;
      } else {
        _showErrorDialog(context, response.data['message']);
        return 'Login gagal: ${response.data['message']}';
      }
    } catch (e) {
      _showErrorDialog(context, 'Terjadi kesalahan, coba lagi.');
      return 'Terjadi kesalahan, coba lagi';
    }
  }

  Future<void> _fetchBranches(BuildContext context, String token) async {
    try {
      final dio = Dio();
      final response = await dio.get(
        'http://vimedika.com:4001/list_branches',
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      if (response.statusCode == 200) {
        final branches = response.data['data'];
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            duration: const Duration(milliseconds: 500),
            child: BranchesScreen(branches: branches),
          ),
        );
      } else {
        _showErrorDialog(context, 'Gagal mengambil data cabang.');
      }
    } catch (e) {
      _showErrorDialog(
        context,
        'Terjadi kesalahan saat mengambil data cabang.',
      );
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Gagal'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<String?> _registerUser(SignUpData data) async {
    debugPrint('Username: ${data.email}, Password: ${data.password}');
    return null;
  }
}

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:staj_proje_1/modules/auth/register/register_view.dart';
import 'package:staj_proje_1/utils/ui/button/bg_button.dart';
import 'package:staj_proje_1/utils/ui/input/bg_textfield.dart';
import 'package:staj_proje_1/utils/ui/sized/bg_sized_box.dart';

import '../home/home_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  bool isShowError = false;
  String? errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: _boxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _logo(),
            _emailTextField(),
            const BgSizedBox(),
            _passwordTextField(),
            const BgSizedBox(),
            _loginButton(),
            const BgSizedBox(),
            if (isShowError) _errorMessage() else const SizedBox.shrink(),
            const BgSizedBox(),
            _textButton(),
          ],
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.blue.shade900,
          Colors.red,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }

  FlutterLogo _logo() {
    return const FlutterLogo(
      size: 100,
    );
  }

  BgTextField _emailTextField() {
    return BgTextField(
      textEditingController: emailController,
      hintText: "Email",
      keyboardType: TextInputType.emailAddress,
    );
  }

  BgTextField _passwordTextField() {
    return BgTextField(
      textEditingController: passwordController,
      obscureText: true,
      hintText: "Şifre",
    );
  }

  BgButton _loginButton() => BgButton(
        buttonTitle: "Giriş Yap",
        onPressed: () async {
          validateInputs();
          if (!isShowError) {
            try {
              await firebaseAuth.signInWithEmailAndPassword(
                email: emailController.text.trim(),
                password: passwordController.text.trim(),
              );

              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Giriş başarılı!"),
                  backgroundColor: Colors.green,
                ),
              );

              Navigator.pushReplacement(
                // ignore: use_build_context_synchronously
                context,
                MaterialPageRoute(builder: (context) => const HomeView()),
              );
            } catch (e) {
              showError("Giriş işlemi sırasında bir hata oluştu: $e");
            }
          }
        },
      );

  TextButton _textButton() {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RegisterView()),
        );
      },
      child: const Text(
        "Hesabın Yok Mu?",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Text _errorMessage() {
    return Text(
      errorMessage!,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 17,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  void validateInputs() {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      showError("Lütfen boş alanları doldurunuz!");
    } else if (!EmailValidator.validate(emailController.text)) {
      showError("Email formatı hatalı");
    } else {
      hideError();
    }
  }

  void showError(String message) {
    setState(() {
      isShowError = true;
      errorMessage = message;
    });
  }

  void hideError() {
    setState(() {
      isShowError = false;
    });
  }
}

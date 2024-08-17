import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:staj_proje_1/modules/auth/login/login_view.dart';
import 'package:staj_proje_1/utils/ui/button/bg_button.dart';
import 'package:staj_proje_1/utils/ui/input/bg_textfield.dart';
import 'package:staj_proje_1/utils/ui/sized/bg_sized_box.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final firebaseAuth = FirebaseAuth.instance;
  bool isShowError = false;
  String? errorMessage = "";
  bool isSuccess = false;

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
            _nameTextField(),
            _surnameTextField(),
            _emailTextField(),
            const SizedBox(),
            _passwordTextField(),
            const BgSizedBox(),
            _registerButton(),
            const BgSizedBox(),
            if (isShowError) _errorMessage() else const SizedBox.shrink(),
            if (isSuccess) _successMessage() else const SizedBox.shrink(),
            const BgSizedBox(),
            _textButton(context)
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
      ),
    );
  }

  FlutterLogo _logo() {
    return const FlutterLogo(
      size: 100,
    );
  }

  BgTextField _nameTextField() {
    return BgTextField(
      textEditingController: nameController,
      hintText: "Ad",
    );
  }

  BgTextField _surnameTextField() {
    return BgTextField(
      textEditingController: surnameController,
      hintText: "Soyad",
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

  BgButton _registerButton() => BgButton(
        buttonTitle: "Kaydol",
        onPressed: () async {
          await _register();
        },
      );

  TextButton _textButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginView()),
        );
      },
      child: const Text(
        "Zaten Hesabın Var mı?",
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

  Text _successMessage() {
    return const Text(
      "Kayıt başarılı! Giriş yapabilirsiniz.",
      style: TextStyle(
        color: Colors.white,
        fontSize: 17,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Future<void> _register() async {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        nameController.text.isEmpty ||
        surnameController.text.isEmpty) {
      showError("Lütfen tüm alanları doldurunuz!");
      return;
    }

    if (!EmailValidator.validate(emailController.text)) {
      showError("Geçersiz email formatı.");
      return;
    }

    try {
      UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      User? user = userCredential.user;
      await user?.updateProfile(
          displayName: "${nameController.text} ${surnameController.text}");

      setState(() {
        isSuccess = true;
        isShowError = false;
        errorMessage = "";
      });
    } on FirebaseAuthException catch (e) {
      showError(e.message ?? "Kayıt işlemi başarısız.");
    }
  }

  void showError(String message) {
    setState(() {
      isShowError = true;
      errorMessage = message;
    });
  }
}

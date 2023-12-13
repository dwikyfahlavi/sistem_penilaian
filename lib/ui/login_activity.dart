import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:sistem_penilaian/bloc/user_bloc.dart';
import 'package:sistem_penilaian/ui/home_page_panitia.dart';
import 'package:sistem_penilaian/ui/home_page_peserta.dart';
import 'package:sistem_penilaian/ui/register_activity.dart';

class LoginActivity extends StatefulWidget {
  const LoginActivity({super.key});

  @override
  State<LoginActivity> createState() => _LoginActivityState();
}

class _LoginActivityState extends State<LoginActivity> {
  UserBloc bloc = UserBloc();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Halaman Login",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email address';
                  }
                  // Use your email validation logic here
                  if (!isValidEmail(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
                controller: email,
                decoration:
                    const InputDecoration(hintText: "Masukkan Email Anda"),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                controller: password,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Password';
                  }
                  return null;
                },
                decoration:
                    const InputDecoration(hintText: "Masukkan Password Anda"),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  onSubmit();
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  alignment: Alignment.center,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.green,
                  ),
                  child: const Text('Login',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Belum Punya Akun ?',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) =>
                          const RegisterActivity(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  alignment: Alignment.center,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      border: Border.all(color: Colors.grey)),
                  child: Text('Daftar Sekarang',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black.withOpacity(0.8),
                          fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }

  onSubmit() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      await bloc.loginUser(email.text, password.text).then((value) {
        if (value?.error == null) {
          showToast(
            'Berhasil Login!',
            context: context,
            animation: StyledToastAnimation.slideFromTopFade,
            reverseAnimation: StyledToastAnimation.fade,
            position: StyledToastPosition.center,
            animDuration: const Duration(seconds: 1),
            duration: const Duration(seconds: 4),
            curve: Curves.elasticOut,
            reverseCurve: Curves.linear,
          );
          if (value?.role != null) {
            if (value?.role!.first == 'Peserta') {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute<void>(
                    builder: (BuildContext context) => HomePagePeserta(
                          user: value,
                        )),
                ModalRoute.withName('homePagePeserta'),
              );
            } else {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute<void>(
                    builder: (BuildContext context) => HomePagePanitia(
                          user: value,
                        )),
                ModalRoute.withName('homePagePanitia'),
              );
            }
          }
          // Navigator.of(context).pop();
        } else {
          // hideLoading();
          showToast(
            value?.error,
            context: context,
            animation: StyledToastAnimation.slideFromTopFade,
            reverseAnimation: StyledToastAnimation.fade,
            position: StyledToastPosition.center,
            animDuration: const Duration(seconds: 1),
            duration: const Duration(seconds: 4),
            curve: Curves.elasticOut,
            reverseCurve: Curves.linear,
          );
        }
      });
    }
  }

  bool isValidEmail(String email) {
    // Implement your email validation logic here
    // You can use the same email validation function from the previous example
    final RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegex.hasMatch(email);
  }

  showLoading() {
    return const CircularProgressIndicator();
  }

  hideLoading() => Navigator.pop(context);
}

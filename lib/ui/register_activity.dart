import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:sistem_penilaian/bloc/user_bloc.dart';

class RegisterActivity extends StatefulWidget {
  const RegisterActivity({super.key});

  @override
  State<RegisterActivity> createState() => _RegisterActivityState();
}

class _RegisterActivityState extends State<RegisterActivity> {
  UserBloc bloc = UserBloc();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Halaman Register",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                keyboardType: TextInputType.number,
                controller: bloc.nim,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your NIM';
                  }
                  return null;
                },
                decoration:
                    const InputDecoration(hintText: "Masukkan Nim Anda"),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: bloc.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Name';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    hintText: "Masukkan Nama Lengkap Anda"),
              ),
              const SizedBox(
                height: 15,
              ),
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
                controller: bloc.email,
                decoration:
                    const InputDecoration(hintText: "Masukkan Email Anda"),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                controller: bloc.password,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Password';
                  }
                  return null;
                },
                decoration:
                    const InputDecoration(hintText: "Masukkan Password Anda"),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 30,
                  ),
                  Radio(
                    value: 'Panitia',
                    groupValue: bloc.role,
                    onChanged: (value) {
                      setState(() {
                        bloc.setRole(value!);
                      });
                    },
                  ),
                  const Text('Panitia'),
                  const Spacer(),
                  Radio(
                    value: 'Peserta',
                    groupValue: bloc.role,
                    onChanged: (value) {
                      setState(() {
                        bloc.setRole(value!);
                      });
                    },
                  ),
                  const Text('Peserta'),
                  const SizedBox(
                    width: 60,
                  )
                ],
              ),
              StreamBuilder(
                  stream: bloc.roleStream,
                  builder: (context, snapshot) {
                    if (snapshot.data != null) return Container();
                    return const Text(
                      'Role Tidak Boleh Kosong',
                      style: TextStyle(fontSize: 12, color: Colors.red),
                    );
                  }),
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
                  child: const Text('Submit',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
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
      await bloc.addUser().then((value) {
        if (value.toLowerCase() == 'akun berhasil dibuat!') {
          showToast(
            value,
            context: context,
            animation: StyledToastAnimation.slideFromTopFade,
            reverseAnimation: StyledToastAnimation.fade,
            position: StyledToastPosition.center,
            animDuration: const Duration(seconds: 1),
            duration: const Duration(seconds: 4),
            curve: Curves.elasticOut,
            reverseCurve: Curves.linear,
          );
          Navigator.of(context).pop();
        } else {
          showToast(
            value,
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
}

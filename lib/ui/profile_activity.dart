import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:sistem_penilaian/bloc/user_bloc.dart';
import 'package:sistem_penilaian/model/user.dart';
import 'package:sistem_penilaian/ui/login_activity.dart';

class ProfileActivity extends StatefulWidget {
  const ProfileActivity({super.key, this.user});

  final User? user;

  @override
  State<ProfileActivity> createState() => _ProfileActivityState();
}

class _ProfileActivityState extends State<ProfileActivity> {
  UserBloc bloc = UserBloc();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formPassKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await bloc.getProfile(widget.user!.token!);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Halaman Profile",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: StreamBuilder(
          stream: bloc.subject.stream,
          builder: (context, snapshot) {
            User? user;
            if (snapshot.data != null) {
              user = snapshot.data as User;
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            radius: 30,
                            child: Text(
                              '${user?.name?.substring(0, 1)}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '${user?.nim}',
                                style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                '${user?.name}',
                                style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                '${user?.email}',
                                style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          InkWell(
                              onTap: () {
                                onClickEdit();
                              },
                              child: const Icon(Icons.edit_square,
                                  color: Colors.amber))
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      onClickForgotPass();
                    },
                    leading: const Icon(
                      Icons.key,
                      color: Colors.grey,
                    ),
                    title: const Text('Edit Password'),
                    trailing:
                        const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  ),
                  const Divider(
                    height: 2,
                    thickness: 2,
                  ),
                  ListTile(
                    onTap: () {
                      onLogout();
                    },
                    leading: const Icon(
                      Icons.subdirectory_arrow_left_sharp,
                      color: Colors.grey,
                    ),
                    title: const Text('Logout'),
                    trailing:
                        const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  ),
                  const Divider(
                    height: 2,
                    thickness: 2,
                  ),
                ],
              ),
            );
          }),
    );
  }

  onClickEdit() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Edit Profile'),
            content: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Nama Lengkap :",
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
                      height: 30,
                    ),
                    InkWell(
                      onTap: () {
                        onSubmit();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
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
                  ],
                )),
          );
        });
  }

  onClickForgotPass() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Edit Password'),
            content: Form(
                key: formPassKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Password Lama :",
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: bloc.password,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your old Password';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          hintText: "Masukkan Password Lama Anda"),
                    ),
                    const Text(
                      "Password Baru :",
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: bloc.newPassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your new Password';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          hintText: "Masukkan Password Baru Anda"),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      onTap: () {
                        onForgotPass();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
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
                  ],
                )),
          );
        });
  }

  onSubmit() async {
    if (formKey.currentState!.validate()) {
      await bloc
          .updateProfile(bloc.name.text, widget.user!.token!)
          .then((value) {
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
        Navigator.pop(context);
      });
    }
  }

  onForgotPass() async {
    if (formPassKey.currentState!.validate()) {
      await bloc.updatePassword(widget.user!.token!).then((value) {
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
        Navigator.pop(context);
      });
    }
  }

  onLogout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute<void>(
          builder: (BuildContext context) => const LoginActivity()),
      ModalRoute.withName('homePagePeserta'),
    );
  }
}

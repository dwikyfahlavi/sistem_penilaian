import 'package:flutter/material.dart';
import 'package:sistem_penilaian/bloc/user_bloc.dart';
import 'package:sistem_penilaian/model/user.dart';
import 'package:sistem_penilaian/ui/login_activity.dart';
import 'package:sistem_penilaian/ui/matakuliah_activity.dart';
import 'package:sistem_penilaian/ui/profile_activity.dart';
import 'package:sistem_penilaian/ui/user_activity.dart';

class HomePagePanitia extends StatefulWidget {
  const HomePagePanitia({super.key, this.user});

  final User? user;

  @override
  State<HomePagePanitia> createState() => _HomePagePanitiaState();
}

class _HomePagePanitiaState extends State<HomePagePanitia> {
  UserBloc bloc = UserBloc();

  @override
  void initState() {
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
        title: const Text("Halaman Home",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder(
                stream: bloc.subject.stream,
                builder: (context, snapshot) {
                  User? user;
                  if (snapshot.data != null) {
                    user = snapshot.data as User;
                  }

                  return Text(
                    'Selamat Datang Admin ${user?.name}',
                    style: const TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.w600),
                  );
                }),
            const SizedBox(
              height: 20,
            ),
            myButton(
                'Manajemen Peserta',
                const Icon(
                  Icons.person,
                  color: Colors.white,
                ), () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => UserActivity(
                    user: widget.user,
                  ),
                ),
              );
            }),
            myButton(
                'Manajemen Mata Kuliah',
                const Icon(
                  Icons.library_books_rounded,
                  color: Colors.white,
                ), () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => MataKuliahActivity(
                    user: widget.user,
                    isPanitia: true,
                  ),
                ),
              );
            }),
            myButton(
                'Logout',
                const Icon(
                  Icons.subdirectory_arrow_left_sharp,
                  color: Colors.white,
                ), () {
              onLogout();
            }),
          ],
        ),
      ),
    );
  }

  onClickProfile() {
    Navigator.push(
        context,
        MaterialPageRoute<void>(
            builder: (BuildContext context) => ProfileActivity(
                  user: widget.user,
                )));
  }

  myButton(String title, Icon icon, Function() onclick) {
    return InkWell(
      onTap: () {
        onclick();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(15),
        alignment: Alignment.center,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: title == 'Logout' ? Colors.red : Colors.blue,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(
              width: 10,
            ),
            Text(title,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
          ],
        ),
      ),
    );
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

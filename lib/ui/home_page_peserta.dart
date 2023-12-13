import 'package:flutter/material.dart';
import 'package:sistem_penilaian/bloc/user_bloc.dart';
import 'package:sistem_penilaian/model/user.dart';
import 'package:sistem_penilaian/ui/matakuliah_activity.dart';
import 'package:sistem_penilaian/ui/profile_activity.dart';

class HomePagePeserta extends StatefulWidget {
  const HomePagePeserta({super.key, this.user});

  final User? user;

  @override
  State<HomePagePeserta> createState() => _HomePagePesertaState();
}

class _HomePagePesertaState extends State<HomePagePeserta> {
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
                      'Selamat Datang ${user?.name}',
                      style: const TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w600),
                    );
                  }),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => MataKuliahActivity(
                        user: widget.user,
                        isPanitia: false,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  alignment: Alignment.center,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.blue,
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.library_books_rounded,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Mata Kuliah',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: InkWell(
          onTap: () {
            onClickProfile();
          },
          child: const Icon(
            Icons.person_pin,
            size: 55,
            color: Colors.black87,
          ),
        ));
  }

  onClickProfile() {
    Navigator.push(
        context,
        MaterialPageRoute<void>(
            builder: (BuildContext context) => ProfileActivity(
                  user: widget.user,
                )));
  }
}

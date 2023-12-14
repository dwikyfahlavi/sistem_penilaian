import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:sistem_penilaian/bloc/user_bloc.dart';
import 'package:sistem_penilaian/model/penilaian.dart';
import 'package:sistem_penilaian/model/user.dart';

class UserActivity extends StatefulWidget {
  const UserActivity({super.key, this.user});

  final User? user;

  @override
  State<UserActivity> createState() => _UserActivityState();
}

class _UserActivityState extends State<UserActivity> {
  UserBloc bloc = UserBloc();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formAddKey = GlobalKey<FormState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await bloc.getUser(widget.user!.token!);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Halaman Management User",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: StreamBuilder(
            stream: bloc.subjectListUser.stream,
            builder: (context, snapshot) {
              List<User> user = [];
              if (snapshot.data != null) {
                user = snapshot.data as List<User>;
              }

              return ListView.builder(
                  itemCount: user.length,
                  itemBuilder: (context, index) {
                    if (user[index].email != widget.user?.email) {
                      return Card(
                        child: ListTile(
                          onTap: () {
                            onClickMatkul(user[index]);
                          },
                          title: Text(
                            user[index].name!,
                            style: const TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.w600),
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  });
            }),
      ),
      floatingActionButton: InkWell(
        onTap: () {
          onClickAddIPK();
        },
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(50)),
          child: const Icon(
            Icons.add_chart,
            size: 45,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  onClickMatkul(User user) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Detail User'),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "Nama Lengkap :",
                    ),
                    Text(
                      user.name!,
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: const Divider(thickness: 2, height: 1),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "NIM :",
                    ),
                    Text(
                      user.nim!,
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: const Divider(thickness: 2, height: 1),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "Email :",
                    ),
                    Text(
                      user.email!,
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: const Divider(thickness: 2, height: 1),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        onDelete(getIdUser(user.links!.user!.href!));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.red,
                        ),
                        child: const Text('Delete',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        await bloc.getIpkById(
                            getIdUser(user.links!.user!.href!),
                            widget.user!.token!);
                        await bloc
                            .getAllNilai(getIdUser(user.links!.user!.href!),
                                widget.user!.token!)
                            .then((value) => onClickNilai(
                                getIdUser(user.links!.user!.href!)));

                        // onSubmit(matkul.id!, false);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.green,
                        ),
                        child: const Text('Nilai',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  getIdUser(String urlString) {
    Uri uri = Uri.parse(urlString);

    // Get the path segments
    List<String> pathSegments = uri.pathSegments;

    // Extract the last value (ID)
    if (pathSegments.isNotEmpty) {
      String lastValue = pathSegments.last;
      return int.parse(lastValue);
    } else {
      return 0;
    }
  }

  onClickAdd(int id) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Tambah Nilai'),
            content: Form(
                key: formAddKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Nama Mata Kuliah :",
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: bloc.name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Subject';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          hintText: "Masukkan Nama Mata Kuliah"),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Nilai Pretest :",
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: bloc.nilaiPretest,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Pretest value';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          hintText: "Masukkan Nilai Pretest"),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Nilai Posttest :",
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: bloc.nilaiPosttest,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Posttest value';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          hintText: "Masukkan Nilai Posttest"),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      onTap: () {
                        // onSubmit();
                        onAddNilai(id);
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

  onClickAddIPK() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Perhatian'),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Apakah Anda yakin untuk men-Generate IPK semua User yang telah memiliki nilai ?",
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.grey,
                        ),
                        child: const Text('Tidak',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        onIPKProses();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.green,
                        ),
                        child: const Text('Ya',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  onClickNilai(int id) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Row(
                children: [
                  const Text('Penilaian'),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      onClickAdd(id);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(50)),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  )
                ],
              ),
              content: StreamBuilder(
                  stream: bloc.listPenilaian.stream,
                  builder: (context, snapshot) {
                    List<Penilaian>? listNilai = [];
                    if (snapshot.data != null) {
                      listNilai = snapshot.data as List<Penilaian>;
                    }
                    if (listNilai.isEmpty) {
                      return const Center(
                        child: Text('Data Nilai Belum Ada'),
                      );
                    }
                    return SizedBox(
                      height: 550,
                      width: 300,
                      child: ListView.builder(
                          itemCount: listNilai.length,
                          itemBuilder: (context, index) {
                            if (listNilai?.isNotEmpty ?? false) {
                              Penilaian nilai = listNilai![index];
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      const Text(
                                        "Mata Kuliah :",
                                      ),
                                      Text(
                                        nilai.materiKU!,
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child:
                                        const Divider(thickness: 2, height: 1),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      const Text(
                                        "Nilai Pretest :",
                                      ),
                                      Text(
                                        nilai.nilaiPretest!.toString(),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child:
                                        const Divider(thickness: 2, height: 1),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      const Text(
                                        "Mata Posttest :",
                                      ),
                                      Text(
                                        nilai.nilaiPosttest!.toString(),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child:
                                        const Divider(thickness: 2, height: 1),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      const Text(
                                        "Bobot :",
                                      ),
                                      Text(
                                        nilai.bobot!.toString(),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child:
                                        const Divider(thickness: 2, height: 1),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      const Text(
                                        "Predikat :",
                                      ),
                                      Text(
                                        nilai.nilaiHuruf!,
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child:
                                        const Divider(thickness: 2, height: 1),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  if (listNilai.length == index + 1)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "IPK : ",
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          bloc.ipkModel?.first.ipKelulusan
                                                  .toString() ??
                                              'Belum ada',
                                          style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                ],
                              );
                            }
                            return Container();
                          }),
                    );
                  }));
        });
  }

  onAddNilai(int id) async {
    if (formAddKey.currentState!.validate()) {
      await bloc.addNilai(id, widget.user!.token!).then((value) {
        showToast(
          value.error ?? "Success Add Nilai",
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

  onIPKProses() async {
    await bloc.generateIPKUser(widget.user!.token!).then((value) {
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

  onDelete(int id) async {
    await bloc.deleteUser(id, widget.user!.token!).then((value) {
      showToast(
        value?.error ?? "Success Delete User",
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

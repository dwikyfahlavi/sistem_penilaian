import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:sistem_penilaian/bloc/matakuliah_bloc.dart';
import 'package:sistem_penilaian/model/mataKuliah.dart';
import 'package:sistem_penilaian/model/user.dart';

class MataKuliahActivity extends StatefulWidget {
  const MataKuliahActivity({super.key, this.user, required this.isPanitia});

  final User? user;
  final bool isPanitia;

  @override
  State<MataKuliahActivity> createState() => _MataKuliahActivityState();
}

class _MataKuliahActivityState extends State<MataKuliahActivity> {
  MataKuliahBloc bloc = MataKuliahBloc();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formAddKey = GlobalKey<FormState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await bloc.getMatkul(widget.user!.token!);
      if (!widget.isPanitia) {
        await bloc.getNilai(widget.user!.token!);
        await bloc.getIpkUser(widget.user!.token!);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Halaman Mata Kuliah",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: StreamBuilder(
            stream: bloc.matkul.stream,
            builder: (context, snapshot) {
              List<MataKuliah> matkul = [];
              if (snapshot.data != null) {
                matkul = snapshot.data as List<MataKuliah>;
              }

              return ListView.builder(
                  itemCount: matkul.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Card(
                          child: ListTile(
                            onTap: () {
                              onClickMatkul(matkul[index]);
                            },
                            title: Text(
                              matkul[index].nama!,
                              style: const TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        if (matkul.length == index + 1)
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "IPK : ",
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  bloc.listIpk.isNotEmpty
                                      ? bloc.listIpk.first.ipKelulusan
                                          .toString()
                                      : 'Belum di ada',
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                      ],
                    );
                  });
            }),
      ),
      floatingActionButton: widget.isPanitia
          ? InkWell(
              onTap: () {
                onClickAdd();
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(50)),
                child: const Icon(
                  Icons.add,
                  size: 45,
                  color: Colors.white,
                ),
              ),
            )
          : null,
    );
  }

  onClickAdd() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Tambah Mata Kuliah'),
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
                      "Jumlah SKS :",
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: bloc.jumlahSKS,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your SKS';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          hintText: "Masukkan Jumlah SKS"),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      onTap: () {
                        // onSubmit();
                        onAddMatkul();
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

  onClickMatkul(MataKuliah matkul) {
    if (!widget.isPanitia) {
      for (var nilai in bloc.listNilai!) {
        if (matkul.nama == nilai.materiKU) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Penilaian'),
                  content: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                        child: const Divider(thickness: 2, height: 1),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                        child: const Divider(thickness: 2, height: 1),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                        child: const Divider(thickness: 2, height: 1),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                        child: const Divider(thickness: 2, height: 1),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                        child: const Divider(thickness: 2, height: 1),
                      ),
                    ],
                  ),
                );
              });
        }
      }
    } else {
      bloc.mataKuliah.text = matkul.nama!;
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Edit Mata Kuliah'),
              content: Form(
                  key: formKey,
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
                        controller: bloc.mataKuliah,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your subject';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            hintText: "Masukkan Nama Mata Kuliah"),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              onSubmit(matkul.id!, true);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
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
                            onTap: () {
                              onSubmit(matkul.id!, false);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
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
                      ),
                    ],
                  )),
            );
          });
    }
  }

  onSubmit(int id, bool isDelete) async {
    if (formKey.currentState!.validate() || isDelete) {
      await bloc
          .updateMatkul(bloc.mataKuliah.text, id, widget.user!.token!, isDelete)
          .then((value) {
        showToast(
          isDelete ? "Success Delete Mata Kuliah" : "Success Edit Mata Kuliah",
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

  onAddMatkul() async {
    if (formAddKey.currentState!.validate()) {
      await bloc.addMatkul(widget.user!.token!).then((value) {
        showToast(
          value.error ?? "Success Add Mata Kuliah",
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
}

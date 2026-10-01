import 'package:flutter/material.dart';
import '../../model/pasien.dart';
import '../../widget/sidebar.dart';
import 'pasien_form.dart';
import 'pasien_item.dart';

class PasienPage extends StatefulWidget {
  const PasienPage({super.key});

  @override
  State<PasienPage> createState() => _PasienPageState();
}

class _PasienPageState extends State<PasienPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(),
      appBar: AppBar(
        title: const Text("Data Pasien"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PasienForm()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          PasienItem(
            pasien: Pasien(
              id: 1,
              nomorRm: "RM-001",
              nama: "Siti Aminah",
              tanggalLahir: "1992-05-12",
              nomorTelepon: "08567891234",
              alamat: "Jl. Merdeka No. 45 Yogyakarta",
            ),
          ),
          PasienItem(
            pasien: Pasien(
              id: 2,
              nomorRm: "RM-002",
              nama: "Ahmad Dahlan",
              tanggalLahir: "1980-11-20",
              nomorTelepon: "08139876543",
              alamat: "Jl. Kaliurang KM 5 Sleman",
            ),
          ),
        ],
      ),
    );
  }
}
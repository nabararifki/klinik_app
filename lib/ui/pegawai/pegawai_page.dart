import 'package:flutter/material.dart';
import '../../model/pegawai.dart';
import '../../widget/sidebar.dart';
import 'pegawai_form.dart';
import 'pegawai_item.dart';

class PegawaiPage extends StatefulWidget {
  const PegawaiPage({super.key});

  @override
  State<PegawaiPage> createState() => _PegawaiPageState();
}

class _PegawaiPageState extends State<PegawaiPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(),
      appBar: AppBar(
        title: const Text("Data Pegawai"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PegawaiForm()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          PegawaiItem(
            pegawai: Pegawai(
              id: 1,
              nip: "19850101",
              nama: "Budi Santoso",
              tanggalLahir: "1985-01-01",
              nomorTelepon: "08123456789",
              email: "budi@klinik.com",
              password: "password123",
            ),
          ),
          PegawaiItem(
            pegawai: Pegawai(
              id: 2,
              nip: "19880315",
              nama: "Dr. Anita Wijaya",
              tanggalLahir: "1988-03-15",
              nomorTelepon: "08987654321",
              email: "anita@klinik.com",
              password: "password123",
            ),
          ),
        ],
      ),
    );
  }
}
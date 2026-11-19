import 'package:flutter/material.dart';
import '../../model/pasien.dart';
import 'pasien_detail.dart';
import '../../service/pasien_service.dart';

class PasienForm extends StatefulWidget {
  const PasienForm({super.key});

  @override
  State<PasienForm> createState() => _PasienFormState();
}

class _PasienFormState extends State<PasienForm> {
  final _formKey = GlobalKey<FormState>();
  final _nomorRmCtrl = TextEditingController();
  final _namaCtrl = TextEditingController();
  final _tanggalLahirCtrl = TextEditingController();
  final _nomorTeleponCtrl = TextEditingController();
  final _alamatCtrl = TextEditingController();

  @override
  void dispose() {
    _nomorRmCtrl.dispose();
    _namaCtrl.dispose();
    _tanggalLahirCtrl.dispose();
    _nomorTeleponCtrl.dispose();
    _alamatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Pasien")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _fieldNomorRm(),
                const SizedBox(height: 12),
                _fieldNama(),
                const SizedBox(height: 12),
                _fieldTanggalLahir(),
                const SizedBox(height: 12),
                _fieldNomorTelepon(),
                const SizedBox(height: 12),
                _fieldAlamat(),
                const SizedBox(height: 20),
                _tombolSimpan(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _fieldNomorRm() {
    return TextFormField(
      controller: _nomorRmCtrl,
      decoration: const InputDecoration(labelText: "Nomor Rekam Medis"),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Nomor Rekam Medis tidak boleh kosong";
        }
        return null;
      },
    );
  }

  Widget _fieldNama() {
    return TextFormField(
      controller: _namaCtrl,
      decoration: const InputDecoration(labelText: "Nama Pasien"),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Nama Pasien tidak boleh kosong";
        }
        return null;
      },
    );
  }

  Widget _fieldTanggalLahir() {
    return TextFormField(
      controller: _tanggalLahirCtrl,
      decoration: const InputDecoration(labelText: "Tanggal Lahir (YYYY-MM-DD)"),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Tanggal Lahir tidak boleh kosong";
        }
        return null;
      },
    );
  }

  Widget _fieldNomorTelepon() {
    return TextFormField(
      controller: _nomorTeleponCtrl,
      decoration: const InputDecoration(labelText: "Nomor Telepon"),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Nomor Telepon tidak boleh kosong";
        }
        return null;
      },
    );
  }

  Widget _fieldAlamat() {
    return TextFormField(
      controller: _alamatCtrl,
      decoration: const InputDecoration(labelText: "Alamat"),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Alamat tidak boleh kosong";
        }
        return null;
      },
    );
  }

  Widget _tombolSimpan() {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          Pasien pasien = Pasien(
            nomorRm: _nomorRmCtrl.text,
            nama: _namaCtrl.text,
            tanggalLahir: _tanggalLahirCtrl.text,
            nomorTelepon: _nomorTeleponCtrl.text,
            alamat: _alamatCtrl.text,
          );
          await PasienService().simpan(pasien).then((value) {
            if (!mounted) return;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PasienDetail(pasien: value),
              ),
            );
          });
        }
      },
      child: const Text("Simpan"),
    );
  }
}
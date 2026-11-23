import 'package:flutter/material.dart';
import '../../model/pasien.dart';
import '../../service/pasien_service.dart';

class PasienUpdateForm extends StatefulWidget {
  final Pasien pasien;

  const PasienUpdateForm({super.key, required this.pasien});

  @override
  State<PasienUpdateForm> createState() => _PasienUpdateFormState();
}

class _PasienUpdateFormState extends State<PasienUpdateForm> {
  final _formKey = GlobalKey<FormState>();
  final _nomorRmCtrl = TextEditingController();
  final _namaCtrl = TextEditingController();
  final _tanggalLahirCtrl = TextEditingController();
  final _nomorTeleponCtrl = TextEditingController();
  final _alamatCtrl = TextEditingController();
  bool _isSubmitting = false;

  Future<void> getData() async {
    final id = widget.pasien.id;
    if (id == null || id.isEmpty) return;
    try {
      Pasien data = await PasienService().getById(id);
      if (!mounted) return;
      setState(() {
        _nomorRmCtrl.text = data.nomorRm;
        _namaCtrl.text = data.nama;
        _tanggalLahirCtrl.text = data.tanggalLahir;
        _nomorTeleponCtrl.text = data.nomorTelepon;
        _alamatCtrl.text = data.alamat;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memuat data: $e")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _nomorRmCtrl.text = widget.pasien.nomorRm;
    _namaCtrl.text = widget.pasien.nama;
    _tanggalLahirCtrl.text = widget.pasien.tanggalLahir;
    _nomorTeleponCtrl.text = widget.pasien.nomorTelepon;
    _alamatCtrl.text = widget.pasien.alamat;
    getData();
  }

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
      appBar: AppBar(title: const Text("Ubah Pasien")),
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
      onPressed: _isSubmitting
          ? null
          : () async {
              if (!_formKey.currentState!.validate()) return;
              final id = widget.pasien.id;
              if (id == null || id.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("ID Pasien tidak ditemukan")),
                );
                return;
              }
              setState(() {
                _isSubmitting = true;
              });
              try {
                Pasien pasien = Pasien(
                  nomorRm: _nomorRmCtrl.text.trim(),
                  nama: _namaCtrl.text.trim(),
                  tanggalLahir: _tanggalLahirCtrl.text.trim(),
                  nomorTelepon: _nomorTeleponCtrl.text.trim(),
                  alamat: _alamatCtrl.text.trim(),
                );
                Pasien updated = await PasienService().ubah(pasien, id);
                if (!mounted) return;
                Navigator.pop(context, updated);
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Gagal menyimpan perubahan: $e")),
                );
              } finally {
                if (mounted) {
                  setState(() {
                    _isSubmitting = false;
                  });
                }
              }
            },
      child: _isSubmitting
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Text("Simpan Perubahan"),
    );
  }
}

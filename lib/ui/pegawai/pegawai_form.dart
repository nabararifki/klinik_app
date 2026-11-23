import 'package:flutter/material.dart';
import '../../model/pegawai.dart';
import 'pegawai_detail.dart';
import '../../service/pegawai_service.dart';

class PegawaiForm extends StatefulWidget {
  const PegawaiForm({super.key});

  @override
  State<PegawaiForm> createState() => _PegawaiFormState();
}

class _PegawaiFormState extends State<PegawaiForm> {
  final _formKey = GlobalKey<FormState>();
  final _nipCtrl = TextEditingController();
  final _namaCtrl = TextEditingController();
  final _tanggalLahirCtrl = TextEditingController();
  final _nomorTeleponCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nipCtrl.dispose();
    _namaCtrl.dispose();
    _tanggalLahirCtrl.dispose();
    _nomorTeleponCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Pegawai")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _fieldNip(),
                const SizedBox(height: 12),
                _fieldNama(),
                const SizedBox(height: 12),
                _fieldTanggalLahir(),
                const SizedBox(height: 12),
                _fieldNomorTelepon(),
                const SizedBox(height: 12),
                _fieldEmail(),
                const SizedBox(height: 12),
                _fieldPassword(),
                const SizedBox(height: 20),
                _tombolSimpan(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _fieldNip() {
    return TextFormField(
      controller: _nipCtrl,
      decoration: const InputDecoration(labelText: "NIP"),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "NIP tidak boleh kosong";
        }
        return null;
      },
    );
  }

  Widget _fieldNama() {
    return TextFormField(
      controller: _namaCtrl,
      decoration: const InputDecoration(labelText: "Nama Pegawai"),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Nama Pegawai tidak boleh kosong";
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

  Widget _fieldEmail() {
    return TextFormField(
      controller: _emailCtrl,
      decoration: const InputDecoration(labelText: "Email"),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Email tidak boleh kosong";
        }
        return null;
      },
    );
  }

  Widget _fieldPassword() {
    return TextFormField(
      controller: _passwordCtrl,
      decoration: const InputDecoration(labelText: "Password"),
      obscureText: true,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Password tidak boleh kosong";
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
              setState(() {
                _isSubmitting = true;
              });
              try {
                Pegawai pegawai = Pegawai(
                  nip: _nipCtrl.text.trim(),
                  nama: _namaCtrl.text.trim(),
                  tanggalLahir: _tanggalLahirCtrl.text.trim(),
                  nomorTelepon: _nomorTeleponCtrl.text.trim(),
                  email: _emailCtrl.text.trim(),
                  password: _passwordCtrl.text.trim(),
                );
                Pegawai saved = await PegawaiService().simpan(pegawai);
                if (!mounted) return;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PegawaiDetail(pegawai: saved),
                  ),
                );
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Gagal menyimpan data: $e")),
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
          : const Text("Simpan"),
    );
  }
}
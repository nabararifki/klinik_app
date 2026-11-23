import 'package:flutter/material.dart';
import '../../model/poli.dart';
import '../../service/poli_service.dart';

class PoliUpdateForm extends StatefulWidget {
  final Poli poli;

  const PoliUpdateForm({super.key, required this.poli});

  @override
  State<PoliUpdateForm> createState() => _PoliUpdateFormState();
}

class _PoliUpdateFormState extends State<PoliUpdateForm> {
  final _formKey = GlobalKey<FormState>();
  final _namaPoliCtrl = TextEditingController();
  bool _isSubmitting = false;

  Future<void> getData() async {
    final id = widget.poli.id;
    if (id == null || id.isEmpty) return;
    try {
      Poli data = await PoliService().getById(id);
      if (!mounted) return;
      setState(() {
        _namaPoliCtrl.text = data.namaPoli;
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
    _namaPoliCtrl.text = widget.poli.namaPoli;
    getData();
  }

  @override
  void dispose() {
    _namaPoliCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ubah Poli")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _fieldNamaPoli(),
                const SizedBox(height: 20),
                _tombolSimpan(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _fieldNamaPoli() {
    return TextFormField(
      controller: _namaPoliCtrl,
      decoration: const InputDecoration(
        labelText: "Nama Poli",
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Nama Poli tidak boleh kosong";
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
              final id = widget.poli.id;
              if (id == null || id.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("ID Poli tidak ditemukan")),
                );
                return;
              }
              setState(() {
                _isSubmitting = true;
              });
              try {
                Poli poli = Poli(namaPoli: _namaPoliCtrl.text.trim());
                Poli updated = await PoliService().ubah(poli, id);
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

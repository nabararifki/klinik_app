import 'package:flutter/material.dart';
import '../../model/poli.dart';
import 'poli_update_form.dart';
import 'poli_page.dart';
import '../../service/poli_service.dart';

class PoliDetail extends StatefulWidget {
  final Poli poli;

  const PoliDetail({super.key, required this.poli});

  @override
  State<PoliDetail> createState() => _PoliDetailState();
}

class _PoliDetailState extends State<PoliDetail> {
  late Future<Poli> _poliFuture;

  @override
  void initState() {
    super.initState();
    _poliFuture = _fetchData();
  }

  Future<Poli> _fetchData() {
    final id = widget.poli.id;
    if (id == null || id.isEmpty) {
      return Future.value(widget.poli);
    }
    return PoliService().getById(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Poli")),
      body: FutureBuilder<Poli>(
        future: _poliFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: Text("Data Tidak Ditemukan"));
          }

          final Poli poli = snapshot.data!;
          return Column(
            children: [
              const SizedBox(height: 20),
              Text(
                "Nama Poli: ${poli.namaPoli}",
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _tombolUbah(poli),
                  _tombolHapus(poli),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _tombolUbah(Poli poli) {
    return ElevatedButton(
      onPressed: () async {
        final updated = await Navigator.push<Poli>(
          context,
          MaterialPageRoute(
            builder: (context) => PoliUpdateForm(poli: poli),
          ),
        );
        if (updated != null && mounted) {
          setState(() {
            _poliFuture = Future.value(updated);
          });
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      child: const Text("Ubah"),
    );
  }

  Widget _tombolHapus(Poli poli) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (dialogContext) => AlertDialog(
            content: const Text("Yakin ingin menghapus data ini?"),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await PoliService().hapus(poli);
                        if (dialogContext.mounted) {
                          Navigator.pop(dialogContext);
                        }
                        if (!mounted) return;
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PoliPage(),
                          ),
                          (route) => false,
                        );
                      } catch (e) {
                        if (dialogContext.mounted) {
                          Navigator.pop(dialogContext);
                        }
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Gagal menghapus data: $e")),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Ya"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Tidak"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      child: const Text("Hapus"),
    );
  }
}

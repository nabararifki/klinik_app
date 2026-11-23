import 'package:flutter/material.dart';
import '../../model/pasien.dart';
import '../../service/pasien_service.dart';
import 'pasien_update_form.dart';
import 'pasien_page.dart';

class PasienDetail extends StatefulWidget {
  final Pasien pasien;

  const PasienDetail({super.key, required this.pasien});

  @override
  State<PasienDetail> createState() => _PasienDetailState();
}

class _PasienDetailState extends State<PasienDetail> {
  late Future<Pasien> _pasienFuture;

  @override
  void initState() {
    super.initState();
    _pasienFuture = _fetchData();
  }

  Future<Pasien> _fetchData() {
    final id = widget.pasien.id;
    if (id == null || id.isEmpty) {
      return Future.value(widget.pasien);
    }
    return PasienService().getById(id);
  }

  Widget _buildPhotoPlaceholder() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade400, width: 2),
      ),
      child: Icon(
        Icons.person,
        size: 80,
        color: Colors.grey[600],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const Text(
            " : ",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tombolUbah(Pasien pasien) {
    return ElevatedButton(
      onPressed: () async {
        final updated = await Navigator.push<Pasien>(
          context,
          MaterialPageRoute(
            builder: (context) => PasienUpdateForm(pasien: pasien),
          ),
        );
        if (updated != null && mounted) {
          setState(() {
            _pasienFuture = Future.value(updated);
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

  Widget _tombolHapus(Pasien pasien) {
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
                        await PasienService().hapus(pasien);
                        if (dialogContext.mounted) {
                          Navigator.pop(dialogContext);
                        }
                        if (!mounted) return;
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PasienPage(),
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

  Widget _buildActionButtons(Pasien pasien) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _tombolUbah(pasien),
        _tombolHapus(pasien),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Pasien")),
      body: FutureBuilder<Pasien>(
        future: _pasienFuture,
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

          final Pasien pasien = snapshot.data!;
          return OrientationBuilder(
            builder: (context, orientation) {
              final isLandscape = orientation == Orientation.landscape;

              List<Widget> infoContent = [
                _buildDetailRow("Nomor RM", pasien.nomorRm),
                _buildDetailRow("Nama", pasien.nama),
                _buildDetailRow("Tanggal Lahir", pasien.tanggalLahir),
                _buildDetailRow("No. Telepon", pasien.nomorTelepon),
                _buildDetailRow("Alamat", pasien.alamat),
                const SizedBox(height: 20),
                _buildActionButtons(pasien),
              ];

              if (isLandscape) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPhotoPlaceholder(),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: infoContent,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildPhotoPlaceholder(),
                      const SizedBox(height: 20),
                      ...infoContent,
                    ],
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}

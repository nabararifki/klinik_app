import 'package:flutter/material.dart';
import '../../model/pegawai.dart';
import '../../service/pegawai_service.dart';
import 'pegawai_update_form.dart';
import 'pegawai_page.dart';

class PegawaiDetail extends StatefulWidget {
  final Pegawai pegawai;

  const PegawaiDetail({super.key, required this.pegawai});

  @override
  State<PegawaiDetail> createState() => _PegawaiDetailState();
}

class _PegawaiDetailState extends State<PegawaiDetail> {
  late Future<Pegawai> _pegawaiFuture;

  @override
  void initState() {
    super.initState();
    _pegawaiFuture = _fetchData();
  }

  Future<Pegawai> _fetchData() {
    final id = widget.pegawai.id;
    if (id == null || id.isEmpty) {
      return Future.value(widget.pegawai);
    }
    return PegawaiService().getById(id);
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

  Widget _tombolUbah(Pegawai pegawai) {
    return ElevatedButton(
      onPressed: () async {
        final updated = await Navigator.push<Pegawai>(
          context,
          MaterialPageRoute(
            builder: (context) => PegawaiUpdateForm(pegawai: pegawai),
          ),
        );
        if (updated != null && mounted) {
          setState(() {
            _pegawaiFuture = Future.value(updated);
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

  Widget _tombolHapus(Pegawai pegawai) {
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
                        await PegawaiService().hapus(pegawai);
                        if (dialogContext.mounted) {
                          Navigator.pop(dialogContext);
                        }
                        if (!mounted) return;
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PegawaiPage(),
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

  Widget _buildActionButtons(Pegawai pegawai) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _tombolUbah(pegawai),
        _tombolHapus(pegawai),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Pegawai")),
      body: FutureBuilder<Pegawai>(
        future: _pegawaiFuture,
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

          final Pegawai pegawai = snapshot.data!;
          return OrientationBuilder(
            builder: (context, orientation) {
              final isLandscape = orientation == Orientation.landscape;

              List<Widget> infoContent = [
                _buildDetailRow("NIP", pegawai.nip),
                _buildDetailRow("Nama", pegawai.nama),
                _buildDetailRow("Tanggal Lahir", pegawai.tanggalLahir),
                _buildDetailRow("No. Telepon", pegawai.nomorTelepon),
                _buildDetailRow("Email", pegawai.email),
                const SizedBox(height: 20),
                _buildActionButtons(pegawai),
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

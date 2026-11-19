import 'package:flutter/material.dart';
import '../../model/pegawai.dart';
import '../../widget/sidebar.dart';
import 'pegawai_form.dart';
import 'pegawai_item.dart';
import '../../service/pegawai_service.dart';

class PegawaiPage extends StatefulWidget {
  const PegawaiPage({super.key});

  @override
  State<PegawaiPage> createState() => _PegawaiPageState();
}

class _PegawaiPageState extends State<PegawaiPage> {
  Stream<List<Pegawai>> getList() async* {
    List<Pegawai> data = await PegawaiService().listData();
    yield data;
  }

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
              ).then((value) {
                setState(() {});
              });
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Pegawai>>(
        stream: getList(),
        builder: (context, AsyncSnapshot<List<Pegawai>> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Data Kosong"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return PegawaiItem(pegawai: snapshot.data![index]);
            },
          );
        },
      ),
    );
  }
}

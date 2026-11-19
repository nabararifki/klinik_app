import 'package:flutter/material.dart';
import '../../model/pasien.dart';
import '../../widget/sidebar.dart';
import 'pasien_form.dart';
import 'pasien_item.dart';
import '../../service/pasien_service.dart';

class PasienPage extends StatefulWidget {
  const PasienPage({super.key});

  @override
  State<PasienPage> createState() => _PasienPageState();
}

class _PasienPageState extends State<PasienPage> {
  Stream<List<Pasien>> getList() async* {
    List<Pasien> data = await PasienService().listData();
    yield data;
  }

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
              ).then((value) {
                setState(() {});
              });
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Pasien>>(
        stream: getList(),
        builder: (context, AsyncSnapshot<List<Pasien>> snapshot) {
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
              return PasienItem(pasien: snapshot.data![index]);
            },
          );
        },
      ),
    );
  }
}
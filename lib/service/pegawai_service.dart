import 'package:dio/dio.dart';
import '../helpers/api_client.dart';
import '../model/pegawai.dart';

class PegawaiService {
  Future<List<Pegawai>> listData() async {
    final Response response = await ApiClient().get("pegawai.json");
    if (response.data == null) return [];

    List<Pegawai> result = [];
    if (response.data is List) {
      final List data = response.data as List;
      for (var item in data) {
        if (item != null) {
          result.add(Pegawai.fromJson(Map<String, dynamic>.from(item)));
        }
      }
    } else if (response.data is Map) {
      final Map data = response.data as Map;
      data.forEach((key, value) {
        if (value is Map) {
          Pegawai pegawai = Pegawai.fromJson(Map<String, dynamic>.from(value));
          pegawai.id = int.tryParse(key.toString().replaceAll(RegExp(r'[^0-9]'), ''));
          result.add(pegawai);
        }
      });
    }
    return result;
  }

  Future<Pegawai> simpan(Pegawai pegawai) async {
    List<Pegawai> currentList = await listData();
    int nextNumber = currentList.length + 1;
    String newId = "pegawai_${nextNumber.toString().padLeft(2, '0')}";

    var data = pegawai.toJson();
    final Response response = await ApiClient().put('pegawai/$newId.json', data);
    Pegawai result = Pegawai.fromJson(Map<String, dynamic>.from(response.data ?? {}));
    result.id = nextNumber;
    return result;
  }

  Future<Pegawai> ubah(Pegawai pegawai, String id) async {
    var data = pegawai.toJson();
    final Response response = await ApiClient().put('pegawai/$id.json', data);
    Pegawai result = Pegawai.fromJson(Map<String, dynamic>.from(response.data ?? {}));
    result.id = int.tryParse(id.replaceAll(RegExp(r'[^0-9]'), ''));
    return result;
  }

  Future<Pegawai> getById(String id) async {
    final Response response = await ApiClient().get('pegawai/$id.json');
    Pegawai result = Pegawai.fromJson(Map<String, dynamic>.from(response.data ?? {}));
    result.id = int.tryParse(id.replaceAll(RegExp(r'[^0-9]'), ''));
    return result;
  }

  Future<Pegawai> hapus(Pegawai pegawai) async {
    final Response response = await ApiClient().delete('pegawai/${pegawai.id}.json');
    Pegawai result = Pegawai.fromJson(Map<String, dynamic>.from(response.data ?? {}));
    return result;
  }
}

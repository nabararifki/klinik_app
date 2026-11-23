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
      for (int i = 0; i < data.length; i++) {
        final item = data[i];
        if (item is Map) {
          Pegawai pegawai = Pegawai.fromJson(Map<String, dynamic>.from(item));
          pegawai.id ??= i.toString();
          result.add(pegawai);
        }
      }
    } else if (response.data is Map) {
      final Map data = response.data as Map;
      data.forEach((key, value) {
        if (value is Map) {
          Pegawai pegawai = Pegawai.fromJson(Map<String, dynamic>.from(value));
          pegawai.id = key.toString();
          result.add(pegawai);
        }
      });
    }
    return result;
  }

  Future<Pegawai> simpan(Pegawai pegawai) async {
    List<Pegawai> currentList = await listData();
    int maxNumber = currentList.length;
    for (final item in currentList) {
      final match = RegExp(r'(\d+)$').firstMatch(item.id ?? '');
      if (match != null) {
        final numVal = int.tryParse(match.group(1)!) ?? 0;
        if (numVal > maxNumber) maxNumber = numVal;
      }
    }
    int nextNumber = maxNumber + 1;
    String newId = "pegawai_${nextNumber.toString().padLeft(2, '0')}";

    var data = pegawai.toJson();
    final Response response = await ApiClient().put('pegawai/$newId.json', data);
    Pegawai result = Pegawai.fromJson(Map<String, dynamic>.from(response.data ?? {}));
    result.id = newId;
    return result;
  }

  Future<Pegawai> ubah(Pegawai pegawai, String id) async {
    var data = pegawai.toJson();
    final Response response = await ApiClient().put('pegawai/$id.json', data);
    Pegawai result = Pegawai.fromJson(Map<String, dynamic>.from(response.data ?? {}));
    result.id = id;
    return result;
  }

  Future<Pegawai> getById(String id) async {
    final Response response = await ApiClient().get('pegawai/$id.json');
    if (response.data == null) {
      throw Exception("Data pegawai tidak ditemukan");
    }
    Pegawai result = Pegawai.fromJson(Map<String, dynamic>.from(response.data));
    result.id = id;
    return result;
  }

  Future<Pegawai> hapus(Pegawai pegawai) async {
    if (pegawai.id == null || pegawai.id!.isEmpty) {
      throw Exception("ID Pegawai tidak ditemukan");
    }
    final Response response = await ApiClient().delete('pegawai/${pegawai.id}.json');
    Pegawai result = Pegawai.fromJson(Map<String, dynamic>.from(response.data ?? {}));
    return result;
  }
}

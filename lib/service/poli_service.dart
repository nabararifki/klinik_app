import 'package:dio/dio.dart';
import '../helpers/api_client.dart';
import '../model/poli.dart';

class PoliService {
  Future<List<Poli>> listData() async {
    final Response response = await ApiClient().get("poli.json");
    if (response.data == null) return [];

    List<Poli> result = [];
    if (response.data is List) {
      final List data = response.data as List;
      for (int i = 0; i < data.length; i++) {
        final item = data[i];
        if (item is Map) {
          Poli poli = Poli.fromJson(Map<String, dynamic>.from(item));
          poli.id ??= i.toString();
          result.add(poli);
        }
      }
    } else if (response.data is Map) {
      final Map data = response.data as Map;
      data.forEach((key, value) {
        if (value is Map) {
          Poli poli = Poli.fromJson(Map<String, dynamic>.from(value));
          poli.id = key.toString();
          result.add(poli);
        }
      });
    }
    return result;
  }

  Future<Poli> simpan(Poli poli) async {
    List<Poli> currentList = await listData();
    int maxNumber = currentList.length;
    for (final item in currentList) {
      final match = RegExp(r'(\d+)$').firstMatch(item.id ?? '');
      if (match != null) {
        final numVal = int.tryParse(match.group(1)!) ?? 0;
        if (numVal > maxNumber) maxNumber = numVal;
      }
    }
    int nextNumber = maxNumber + 1;
    String newId = "poli_${nextNumber.toString().padLeft(2, '0')}";

    var data = poli.toJson();
    final Response response = await ApiClient().put('poli/$newId.json', data);
    Poli result = Poli.fromJson(Map<String, dynamic>.from(response.data ?? {}));
    result.id = newId;
    return result;
  }

  Future<Poli> ubah(Poli poli, String id) async {
    var data = poli.toJson();
    final Response response = await ApiClient().put('poli/$id.json', data);
    Poli result = Poli.fromJson(Map<String, dynamic>.from(response.data ?? {}));
    result.id = id;
    return result;
  }

  Future<Poli> getById(String id) async {
    final Response response = await ApiClient().get('poli/$id.json');
    if (response.data == null) {
      throw Exception("Data poli tidak ditemukan");
    }
    Poli result = Poli.fromJson(Map<String, dynamic>.from(response.data));
    result.id = id;
    return result;
  }

  Future<Poli> hapus(Poli poli) async {
    if (poli.id == null || poli.id!.isEmpty) {
      throw Exception("ID Poli tidak ditemukan");
    }
    final Response response = await ApiClient().delete('poli/${poli.id}.json');
    Poli result = Poli.fromJson(Map<String, dynamic>.from(response.data ?? {}));
    return result;
  }
}

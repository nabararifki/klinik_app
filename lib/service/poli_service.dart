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
      for (var item in data) {
        if (item != null) {
          result.add(Poli.fromJson(Map<String, dynamic>.from(item)));
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
    int nextNumber = currentList.length + 1;
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
    Poli result = Poli.fromJson(Map<String, dynamic>.from(response.data ?? {}));
    result.id = id;
    return result;
  }

  Future<Poli> hapus(Poli poli) async {
    final Response response = await ApiClient().delete('poli/${poli.id}.json');
    Poli result = Poli.fromJson(Map<String, dynamic>.from(response.data ?? {}));
    return result;
  }
}

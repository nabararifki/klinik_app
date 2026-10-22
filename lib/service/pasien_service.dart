import 'package:dio/dio.dart';
import '../helpers/api_client.dart';
import '../model/pasien.dart';

class PasienService {
  Future<List<Pasien>> listData() async {
    final Response response = await ApiClient().get("pasien.json");
    if (response.data == null) return [];

    List<Pasien> result = [];
    if (response.data is List) {
      final List data = response.data as List;
      for (var item in data) {
        if (item != null) {
          result.add(Pasien.fromJson(Map<String, dynamic>.from(item)));
        }
      }
    } else if (response.data is Map) {
      final Map data = response.data as Map;
      data.forEach((key, value) {
        if (value is Map) {
          Pasien pasien = Pasien.fromJson(Map<String, dynamic>.from(value));
          pasien.id = int.tryParse(key.toString().replaceAll(RegExp(r'[^0-9]'), ''));
          result.add(pasien);
        }
      });
    }
    return result;
  }

  Future<Pasien> simpan(Pasien pasien) async {
    List<Pasien> currentList = await listData();
    int nextNumber = currentList.length + 1;
    String newId = "pasien_${nextNumber.toString().padLeft(2, '0')}";

    var data = pasien.toJson();
    final Response response = await ApiClient().put('pasien/$newId.json', data);
    Pasien result = Pasien.fromJson(Map<String, dynamic>.from(response.data ?? {}));
    result.id = nextNumber;
    return result;
  }

  Future<Pasien> ubah(Pasien pasien, String id) async {
    var data = pasien.toJson();
    final Response response = await ApiClient().put('pasien/$id.json', data);
    Pasien result = Pasien.fromJson(Map<String, dynamic>.from(response.data ?? {}));
    result.id = int.tryParse(id.replaceAll(RegExp(r'[^0-9]'), ''));
    return result;
  }

  Future<Pasien> getById(String id) async {
    final Response response = await ApiClient().get('pasien/$id.json');
    Pasien result = Pasien.fromJson(Map<String, dynamic>.from(response.data ?? {}));
    result.id = int.tryParse(id.replaceAll(RegExp(r'[^0-9]'), ''));
    return result;
  }

  Future<Pasien> hapus(Pasien pasien) async {
    final Response response = await ApiClient().delete('pasien/${pasien.id}.json');
    Pasien result = Pasien.fromJson(Map<String, dynamic>.from(response.data ?? {}));
    return result;
  }
}

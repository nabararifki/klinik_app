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
      for (int i = 0; i < data.length; i++) {
        final item = data[i];
        if (item is Map) {
          Pasien pasien = Pasien.fromJson(Map<String, dynamic>.from(item));
          pasien.id ??= i.toString();
          result.add(pasien);
        }
      }
    } else if (response.data is Map) {
      final Map data = response.data as Map;
      data.forEach((key, value) {
        if (value is Map) {
          Pasien pasien = Pasien.fromJson(Map<String, dynamic>.from(value));
          pasien.id = key.toString();
          result.add(pasien);
        }
      });
    }
    return result;
  }

  Future<Pasien> simpan(Pasien pasien) async {
    List<Pasien> currentList = await listData();
    int maxNumber = currentList.length;
    for (final item in currentList) {
      final match = RegExp(r'(\d+)$').firstMatch(item.id ?? '');
      if (match != null) {
        final numVal = int.tryParse(match.group(1)!) ?? 0;
        if (numVal > maxNumber) maxNumber = numVal;
      }
    }
    int nextNumber = maxNumber + 1;
    String newId = "pasien_${nextNumber.toString().padLeft(2, '0')}";

    var data = pasien.toJson();
    final Response response = await ApiClient().put('pasien/$newId.json', data);
    Pasien result = Pasien.fromJson(Map<String, dynamic>.from(response.data ?? {}));
    result.id = newId;
    return result;
  }

  Future<Pasien> ubah(Pasien pasien, String id) async {
    var data = pasien.toJson();
    final Response response = await ApiClient().put('pasien/$id.json', data);
    Pasien result = Pasien.fromJson(Map<String, dynamic>.from(response.data ?? {}));
    result.id = id;
    return result;
  }

  Future<Pasien> getById(String id) async {
    final Response response = await ApiClient().get('pasien/$id.json');
    if (response.data == null) {
      throw Exception("Data pasien tidak ditemukan");
    }
    Pasien result = Pasien.fromJson(Map<String, dynamic>.from(response.data));
    result.id = id;
    return result;
  }

  Future<Pasien> hapus(Pasien pasien) async {
    if (pasien.id == null || pasien.id!.isEmpty) {
      throw Exception("ID Pasien tidak ditemukan");
    }
    final Response response = await ApiClient().delete('pasien/${pasien.id}.json');
    Pasien result = Pasien.fromJson(Map<String, dynamic>.from(response.data ?? {}));
    return result;
  }
}

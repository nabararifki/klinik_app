class Pasien {
  int? id;
  String nomorRm;
  String nama;
  String tanggalLahir;
  String nomorTelepon;
  String alamat;

  Pasien({
    this.id,
    required this.nomorRm,
    required this.nama,
    required this.tanggalLahir,
    required this.nomorTelepon,
    required this.alamat,
  });

  factory Pasien.fromJson(Map<String, dynamic> json) => Pasien(
        id: json["id"] != null ? int.tryParse(json["id"].toString()) : null,
        nomorRm: json["nomor_rm"] ?? json["nomorRm"] ?? "",
        nama: json["nama"] ?? "",
        tanggalLahir: json["tanggal_lahir"] ?? json["tanggalLahir"] ?? "",
        nomorTelepon: json["nomor_telepon"] ?? json["nomorTelepon"] ?? "",
        alamat: json["alamat"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "nomor_rm": nomorRm,
        "nama": nama,
        "tanggal_lahir": tanggalLahir,
        "nomor_telepon": nomorTelepon,
        "alamat": alamat,
      };
}

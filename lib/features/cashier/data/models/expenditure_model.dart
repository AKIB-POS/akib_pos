class ExpenditureModel {
  final String tanggal;
  final int jumlah;
  final String kategori;
  final String deskripsi;
  final int companyId;
  final int branchId;

  ExpenditureModel({
    required this.tanggal,
    required this.jumlah,
    required this.kategori,
    required this.deskripsi,
    this.companyId = 0,
    this.branchId = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'tanggal': tanggal,
      'jumlah': jumlah,
      'kategori': kategori,
      'deskripsi': deskripsi,
      'company_Id': companyId,
      'branch_Id': branchId,
    };
  }

  factory ExpenditureModel.fromJson(Map<String, dynamic> json) {
    return ExpenditureModel(
      tanggal: json['tanggal'],
      jumlah: json['jumlah'],
      kategori: json['kategori'],
      deskripsi: json['deskripsi'],
      companyId: json['company_Id'],
      branchId: json['branch_Id'],
    );
  }
}

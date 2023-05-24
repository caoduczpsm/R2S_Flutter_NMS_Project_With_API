class ModelRepository {
  final int? status;
  final int? error;

  ModelRepository({this.status, this.error});

  factory ModelRepository.fromJson(Map<String, dynamic> json) {
    return ModelRepository(
        status: json['status'],
        error: json['error']
    );
  }
}
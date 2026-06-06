class AppError implements Exception {
  final String msj;
  final int? code;

  AppError({required this.msj, this.code});
}

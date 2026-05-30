class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException([this.message = 'Sesi telah berakhir, silakan login kembali.']);

  @override
  String toString() => message;
}

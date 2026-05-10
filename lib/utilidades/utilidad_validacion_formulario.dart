/// Validaciones locales para formularios de autenticación (sin servidor).
bool correoTieneFormatoValido(String valor) {
  final v = valor.trim();
  if (v.isEmpty) return false;
  return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(v);
}

bool contrasenaCumpleMinimo(String valor, {int minimo = 6}) {
  return valor.trim().length >= minimo;
}

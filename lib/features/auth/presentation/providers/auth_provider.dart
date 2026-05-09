import 'package:flutter/material.dart';
import '../../data/models/pemilih.dart';

class AuthProvider extends ChangeNotifier {
  Pemilih? _pemilihAktif;
  bool _adminAktif = false;
  final List<Pemilih> _pemilih = [];

  Pemilih? get pemilihAktif => _pemilihAktif;
  bool get adminAktif => _adminAktif;
  List<Pemilih> get pemilih => List.unmodifiable(_pemilih);
  bool get isLoggedIn => _pemilihAktif != null || _adminAktif;

  bool register(String nama, String nim, String password) {
    if (nama.isEmpty || nim.isEmpty || password.isEmpty) {
      return false;
    }

    if (_pemilih.any((p) => p.nim == nim)) {
      return false;
    }

    final newPemilih = Pemilih(nama: nama, nim: nim, password: password);
    _pemilih.add(newPemilih);
    _pemilihAktif = newPemilih;
    _adminAktif = false;
    notifyListeners();
    return true;
  }

  bool login(String nim, String password) {
    if (nim.isEmpty || password.isEmpty) {
      return false;
    }

    // Check admin login
    if (nim.toLowerCase() == 'admin' && password == 'admin123') {
      _adminAktif = true;
      _pemilihAktif = null;
      notifyListeners();
      return true;
    }

    // Check pemilih login
    for (final pemilih in _pemilih) {
      if (pemilih.nim == nim && pemilih.password == password) {
        _pemilihAktif = pemilih;
        _adminAktif = false;
        notifyListeners();
        return true;
      }
    }

    return false;
  }

  void logout() {
    _pemilihAktif = null;
    _adminAktif = false;
    notifyListeners();
  }

  void markAsVoted(Pemilih pemilih) {
    pemilih.sudahMemilih = true;
    notifyListeners();
  }
}

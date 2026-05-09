class AppConstants {
  static const String appTitle = 'E-PILKETLAS';
  static const String appSubtitle = 'Pemilihan Ketua Kelas';

  // Admin credentials
  static const String adminUsername = 'admin';
  static const String adminPassword = 'admin123';

  // Validation messages
  static const String emptyFieldsError = 'Nama, NIS/NIM, dan token wajib diisi.';
  static const String emptyLoginError = 'NIS/NIM atau token wajib diisi.';
  static const String duplicateNimError = 'NIS/NIM sudah terdaftar.';
  static const String invalidCredentialsError = 'NIS/NIM atau token salah.';
  static const String alreadyVotedError = 'Hak suara kamu sudah digunakan.';
  static const String cannotChangeVoteError = 'Pilihan yang sudah dikirim tidak dapat diubah lagi.';
  static const String emptyCandidateFieldsError = 'Nama, visi, dan misi kandidat wajib diisi.';
  static const String duplicateCandidateError = 'Nama kandidat sudah terdaftar.';

  // UI Text
  static const String loginTab = 'Login';
  static const String registerTab = 'Register';
  static const String nimLabel = 'NIS / NIM';
  static const String passwordLabel = 'Password / Token';
  static const String fullNameLabel = 'Nama Lengkap';
  static const String loginButton = 'LOGIN';
  static const String registerButton = 'REGISTER';
  static const String logoutButton = 'LOGOUT';
  static const String voteButton = 'VOTE';
  static const String backButton = 'KEMBALI';

  // Screen titles
  static const String berandaTitle = 'BERANDA';
  static const String profileKandidatTitle = 'PROFIL KANDIDAT';
  static const String adminTitle = 'Admin E-PILKETLAS';
  static const String dashboardTitle = 'Dashboard Admin';
  static const String daftarKandidatTitle = 'Daftar Kandidat';
  static const String tambahKandidatTitle = 'Tambah Kandidat';
  static const String hasilTitle = 'HASIL QUICK COUNT';
  static const String riwayatTitle = 'Sejarah Voting';

  // Navigation labels
  static const String navBeranda = 'Beranda';
  static const String navKandidat = 'Kandidat';
  static const String navTambah = 'Tambah';
  static const String navHasil = 'Hasil';
  static const String navRiwayat = 'Riwayat';
}

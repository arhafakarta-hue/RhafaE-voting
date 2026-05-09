import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rpl_project/main.dart';
import 'package:rpl_project/features/auth/presentation/providers/auth_provider.dart';
import 'package:rpl_project/features/voting/presentation/providers/voting_provider.dart';

void main() {
  testWidgets('Alur pemilihan ketua kelas mengikuti wireframe', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('E-PILKETLAS'), findsOneWidget);
    expect(find.text('Pemilihan Ketua Kelas'), findsOneWidget);

    await tester.tap(find.text('Register'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('register_nama')), 'Dimas');
    await tester.enterText(find.byKey(const Key('register_nim')), '12345');
    await tester.enterText(find.byKey(const Key('register_password')), 'token');
    await tester.tap(find.text('REGISTER'));
    await tester.pumpAndSettle();

    expect(find.text('Beranda'), findsOneWidget);
    expect(find.text('Hai, Dimas!'), findsOneWidget);
    expect(find.text('Status Hak Suara: [ BELUM MEMILIH ]'), findsOneWidget);
    expect(find.text('DAFTAR KANDIDAT KETUA KELAS'), findsOneWidget);

    await tester.tap(find.text('[ Lihat Visi & Misi ]').first);
    await tester.pumpAndSettle();

    expect(find.text('PROFIL KANDIDAT'), findsOneWidget);
    expect(find.text('VISI'), findsOneWidget);
    expect(find.text('MISI'), findsOneWidget);

    await tester.tap(find.text('[VOTE]'));
    await tester.pumpAndSettle();

    expect(find.text('KONFIRMASI'), findsOneWidget);
    await tester.tap(find.text('YAKIN'));
    await tester.pumpAndSettle();

    expect(find.text('TERIMA KASIH!'), findsOneWidget);
    expect(
      find.text(
        'Suara kamu berhasil direkam.\nHak suara kamu telah digunakan.',
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('LIHAT HASIL (Quick Count)'));
    await tester.pumpAndSettle();

    expect(find.text('HASIL QUICK COUNT'), findsOneWidget);
    expect(find.text('1 suara'), findsWidgets);
  });

  testWidgets('Admin tetap bisa membuka form tambah kandidat', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.enterText(find.byKey(const Key('login_nim')), 'admin');
    await tester.enterText(find.byKey(const Key('login_password')), 'admin123');
    // 1. Scroll to the button first
    await tester.ensureVisible(find.text('LOGIN'));
    // 2. Now tap it
    await tester.tap(find.text('LOGIN'));
    // 3. Wait for the login navigation to finish
    await tester.pumpAndSettle();
    // 4. Now check for the dashboard
    expect(find.text('Dashboard Admin'), findsOneWidget);
    await tester.pumpAndSettle();

    expect(find.text('Dashboard Admin'), findsOneWidget);

    await tester.tap(find.text('Tambah'));
    await tester.pumpAndSettle();

    expect(find.text('Tambah Kandidat'), findsOneWidget);
    expect(find.text('Pilih Foto'), findsOneWidget);
  });

  testWidgets('Provider state management works correctly', (tester) async {
    final authProvider = AuthProvider();
    final votingProvider = VotingProvider();

    // Test register
    final registerSuccess = authProvider.register(
      'Test User',
      '99999',
      'pass123',
    );
    expect(registerSuccess, true);
    expect(authProvider.pemilihAktif?.nama, 'Test User');
    expect(authProvider.isLoggedIn, true);

    // Test duplicate register
    final duplicateRegister = authProvider.register(
      'Another User',
      '99999',
      'pass456',
    );
    expect(duplicateRegister, false);

    // Test logout
    authProvider.logout();
    expect(authProvider.pemilihAktif, null);
    expect(authProvider.isLoggedIn, false);

    // Test login
    authProvider.register('Test User', '99999', 'pass123');
    authProvider.logout();
    final loginSuccess = authProvider.login('99999', 'pass123');
    expect(loginSuccess, true);
    expect(authProvider.pemilihAktif?.nama, 'Test User');

    // Test admin login
    authProvider.logout();
    final adminLogin = authProvider.login('admin', 'admin123');
    expect(adminLogin, true);
    expect(authProvider.adminAktif, true);

    // Test voting
    final kandidatCount = votingProvider.kandidat.length;
    expect(kandidatCount, 2); // Default 3 kandidat

    final pemilih = authProvider.pemilihAktif ?? authProvider.pemilih.first;
    final kandidat = votingProvider.kandidat.first;
    final voteSuccess = votingProvider.vote(pemilih, kandidat);
    expect(voteSuccess, true);
    expect(kandidat.jumlahSuara, 1);
    expect(pemilih.sudahMemilih, true);

    // Test tambah kandidat
    final tambahSuccess = votingProvider.tambahKandidat(
      'Test Kandidat',
      'Test Visi',
      'Test Misi',
      null,
    );
    expect(tambahSuccess, true);
    expect(votingProvider.kandidat.length, kandidatCount + 1);
  });
}

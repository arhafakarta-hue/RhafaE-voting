import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/voting/presentation/providers/voting_provider.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/voting/presentation/screens/pemilih_home_screen.dart';
import 'features/admin/presentation/screens/admin_home_screen.dart';
import 'core/constants/dummy_users.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            final authProvider = AuthProvider();
            // Register dummy users
            DummyUsers.registerDummyUsers(authProvider);
            return authProvider;
          },
        ),
        ChangeNotifierProvider(create: (_) => VotingProvider()),
      ],
      child: MaterialApp(
        title: 'E-PILKETLAS',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
          useMaterial3: true,
        ),
        home: const AppRouter(),
      ),
    );
  }
}

class AppRouter extends StatelessWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    if (authProvider.adminAktif) {
      return const AdminHomeScreen();
    }

    if (authProvider.pemilihAktif != null) {
      return const PemilihHomeScreen();
    }

    return const LoginScreen();
  }
}

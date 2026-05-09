import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _nimController = TextEditingController();
  final _passwordController = TextEditingController();
  final _namaController = TextEditingController();
  bool _isLoginMode = true;

  @override
  void dispose() {
    _nimController.dispose();
    _passwordController.dispose();
    _namaController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final authProvider = context.read<AuthProvider>();
    final success = authProvider.login(
      _nimController.text.trim(),
      _passwordController.text.trim(),
    );

    if (!success) {
      _showMessage(AppConstants.invalidCredentialsError);
    }
  }

  void _handleRegister() {
    final authProvider = context.read<AuthProvider>();
    final success = authProvider.register(
      _namaController.text.trim(),
      _nimController.text.trim(),
      _passwordController.text.trim(),
    );

    if (!success) {
      if (_namaController.text.trim().isEmpty ||
          _nimController.text.trim().isEmpty ||
          _passwordController.text.trim().isEmpty) {
        _showMessage(AppConstants.emptyFieldsError);
      } else {
        _showMessage(AppConstants.duplicateNimError);
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: AppAssets.logo(size: 120),
                ),
                const SizedBox(height: 28),
                const Text(
                  AppConstants.appTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900),
                ),
                const Text(
                  AppConstants.appSubtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 36),
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(
                      value: true,
                      label: Text(AppConstants.loginTab),
                    ),
                    ButtonSegment(
                      value: false,
                      label: Text(AppConstants.registerTab),
                    ),
                  ],
                  selected: {_isLoginMode},
                  onSelectionChanged: (value) {
                    setState(() => _isLoginMode = value.first);
                  },
                ),
                const SizedBox(height: 18),
                if (_isLoginMode) _buildLoginForm() else _buildRegisterForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          AppConstants.nimLabel,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        TextField(
          key: const Key('login_nim'),
          controller: _nimController,
          decoration: const InputDecoration(
            hintText: 'Masukkan NIS/NIM atau "admin"',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          AppConstants.passwordLabel,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        TextField(
          key: const Key('login_password'),
          controller: _passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            hintText: '********',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (_) => _handleLogin(),
        ),
        const SizedBox(height: 8),
        Text(
          'Hint: Login sebagai admin dengan username "admin" dan password "admin123"',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 24),
        CustomButton(
          onPressed: _handleLogin,
          text: AppConstants.loginButton,
        ),
      ],
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          key: const Key('register_nama'),
          controller: _namaController,
          decoration: const InputDecoration(
            labelText: AppConstants.fullNameLabel,
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          key: const Key('register_nim'),
          controller: _nimController,
          decoration: const InputDecoration(
            labelText: AppConstants.nimLabel,
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          key: const Key('register_password'),
          controller: _passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: AppConstants.passwordLabel,
            border: OutlineInputBorder(),
          ),
          onSubmitted: (_) => _handleRegister(),
        ),
        const SizedBox(height: 18),
        CustomButton(
          onPressed: _handleRegister,
          text: AppConstants.registerButton,
        ),
      ],
    );
  }
}

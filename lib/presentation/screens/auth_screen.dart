import 'package:flutter/material.dart';

import '../../domain/usecases/validators.dart';
import '../controllers/app_controller.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({
    super.key,
    required this.mode,
    required this.onModeChanged,
    required this.onLogin,
    required this.onSignUp,
  });

  final AuthMode mode;
  final ValueChanged<AuthMode> onModeChanged;
  final Future<String?> Function(String email, String password) onLogin;
  final Future<String?> Function(String email, String password) onSignUp;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isSubmitting = false;
  String? _errorText;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorText = null;
    });

    final email = _emailController.text;
    final password = _passwordController.text;
    final error = widget.mode == AuthMode.login
        ? await widget.onLogin(email, password)
        : await widget.onSignUp(email, password);

    if (!mounted) {
      return;
    }

    setState(() {
      _isSubmitting = false;
      _errorText = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLogin = widget.mode == AuthMode.login;

    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? 'Вход' : 'Регистрация')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) => validateEmail(value ?? ''),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Пароль'),
                    validator: (value) => validatePassword(value ?? ''),
                  ),
                  const SizedBox(height: 16),
                  if (_errorText != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        _errorText!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  FilledButton(
                    onPressed: _isSubmitting ? null : _submit,
                    child: Text(isLogin ? 'Войти' : 'Зарегистрироваться'),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _isSubmitting
                        ? null
                        : () {
                            widget.onModeChanged(
                              isLogin ? AuthMode.signUp : AuthMode.login,
                            );
                            setState(() {
                              _errorText = null;
                            });
                          },
                    child: Text(
                      isLogin
                          ? 'Нет аккаунта? Зарегистрироваться'
                          : 'Уже есть аккаунт? Войти',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

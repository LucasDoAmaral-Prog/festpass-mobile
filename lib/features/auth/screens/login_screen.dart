import 'package:flutter/material.dart';

import '../../../shared/app_scope.dart';
import '../../../shared/widgets/festpass_logo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _register = false;
  bool _obscure = true;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = AppScope.of(context).auth;
    final success = _register
        ? await auth.register(_name.text, _email.text, _password.text)
        : await auth.login(_email.text, _password.text);
    if (!mounted || success) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(auth.error ?? 'Não foi possível continuar.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = AppScope.of(context).auth;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: FestPassLogoWithSubtitle(size: 1.08),
                  ),
                  const SizedBox(height: 42),
                  Text(
                    _register
                        ? 'Crie seu passaporte.'
                        : 'Sua próxima história começa aqui.',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontSize: 32),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _register
                        ? 'A conta guarda seus favoritos, endereço e ingressos somente para você.'
                        : 'Entre para descobrir eventos e manter seus ingressos sempre à mão.',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(height: 1.45),
                  ),
                  const SizedBox(height: 30),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        if (_register) ...[
                          TextFormField(
                            controller: _name,
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(
                                labelText: 'Nome',
                                prefixIcon: Icon(Icons.person_outline)),
                            validator: (value) =>
                                (value?.trim().length ?? 0) < 3
                                    ? 'Informe seu nome.'
                                    : null,
                          ),
                          const SizedBox(height: 12),
                        ],
                        TextFormField(
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          decoration: const InputDecoration(
                              labelText: 'E-mail',
                              prefixIcon: Icon(Icons.alternate_email)),
                          validator: (value) => !(value?.contains('@') ?? false)
                              ? 'Informe um e-mail válido.'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _password,
                          obscureText: _obscure,
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              onPressed: () =>
                                  setState(() => _obscure = !_obscure),
                              icon: Icon(_obscure
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined),
                            ),
                          ),
                          validator: (value) => (value?.length ?? 0) < 6
                              ? 'Use pelo menos 6 caracteres.'
                              : null,
                          onFieldSubmitted: (_) => _submit(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ListenableBuilder(
                    listenable: auth,
                    builder: (context, _) => ElevatedButton(
                      onPressed: auth.busy ? null : _submit,
                      child: auth.busy
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white))
                          : Text(_register ? 'Criar conta' : 'Entrar'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => setState(() {
                      _register = !_register;
                      _formKey.currentState?.reset();
                    }),
                    child: Text(_register
                        ? 'Já tenho conta'
                        : 'Primeira vez? Criar uma conta'),
                  ),
                  const SizedBox(height: 28),
                  const _SecurityNote(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SecurityNote extends StatelessWidget {
  const _SecurityNote();
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF2ECF7),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Row(
          children: [
            Icon(Icons.shield_outlined, size: 20, color: Color(0xFF7B2CBF)),
            SizedBox(width: 10),
            Expanded(
                child: Text(
                    'Login protegido pelo Firebase Authentication. Sua senha não é armazenada pelo aplicativo.',
                    style: TextStyle(fontSize: 12, height: 1.35))),
          ],
        ),
      );
}

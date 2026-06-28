import 'package:flutter/material.dart';

import '../../../shared/app_scope.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = AppScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: ListenableBuilder(
        listenable: Listenable.merge([scope.auth, scope.events, scope.tickets]),
        builder: (context, _) {
          final user = scope.auth.user!;
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
            children: [
              Row(children: [
                CircleAvatar(
                    radius: 34,
                    backgroundColor: const Color(0xFFFFDCE9),
                    child: Text(
                        user.name.isEmpty ? '?' : user.name[0].toUpperCase(),
                        style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFE51F68)))),
                const SizedBox(width: 15),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(user.name,
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 3),
                      Text(user.email),
                      const SizedBox(height: 4),
                      Text('Conta #${user.displayId}',
                          style: Theme.of(context).textTheme.bodySmall)
                    ])),
                IconButton.outlined(
                    onPressed: () => _edit(context),
                    tooltip: 'Editar perfil',
                    icon: const Icon(Icons.edit_outlined)),
              ]),
              const SizedBox(height: 26),
              Row(children: [
                _Stat(
                    value:
                        '${scope.tickets.tickets.where((item) => item.status == 'ativo').length}',
                    label: 'Ingressos'),
                const SizedBox(width: 10),
                _Stat(
                    value: '${scope.events.favoriteIds.length}',
                    label: 'Favoritos'),
              ]),
              const SizedBox(height: 28),
              Text('Sua conta', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              _Tile(
                  icon: Icons.phone_outlined,
                  title: 'Telefone',
                  subtitle: user.phone.isEmpty ? 'Não informado' : user.phone,
                  onTap: () => _edit(context)),
              const _Tile(
                  icon: Icons.home_outlined,
                  title: 'Endereço',
                  subtitle: 'Salvo ou atualizado durante o checkout'),
              const _Tile(
                  icon: Icons.cloud_outlined,
                  title: 'Seus dados',
                  subtitle: 'Firebase Realtime Database · dados sincronizados'),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: const Color(0xFFEAF6FF),
                    borderRadius: BorderRadius.circular(16)),
                child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, color: Color(0xFF147DB3)),
                      SizedBox(width: 11),
                      Expanded(
                          child: Text(
                              'A busca de CEP usa a API ViaCEP. Perfil, favoritos, endereço e ingressos ficam no Firebase Realtime Database e são protegidos pelo seu login.',
                              style: TextStyle(
                                  height: 1.4, color: Color(0xFF205770))))
                    ]),
              ),
              const SizedBox(height: 28),
              OutlinedButton.icon(
                onPressed: () async {
                  scope.events.clear();
                  scope.tickets.clear();
                  await scope.auth.logout();
                  if (!context.mounted) return;
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                icon: const Icon(Icons.logout),
                label: const Text('Sair da conta'),
                style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFC62828),
                    minimumSize: const Size.fromHeight(50)),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _edit(BuildContext context) async {
    final auth = AppScope.of(context).auth;
    final name = TextEditingController(text: auth.user!.name);
    final phone = TextEditingController(text: auth.user!.phone);
    final formKey = GlobalKey<FormState>();
    final save = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Editar perfil'),
        content: Form(
          key: formKey,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextFormField(
                controller: name,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) =>
                    value!.trim().length < 3 ? 'Informe seu nome.' : null),
            const SizedBox(height: 12),
            TextFormField(
                controller: phone,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Telefone')),
          ]),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancelar')),
          FilledButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(dialogContext, true);
                }
              },
              child: const Text('Salvar')),
        ],
      ),
    );
    if (save == true) {
      await auth.updateProfile(name.text, phone.text);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Perfil atualizado no Firebase.')));
      }
    }
    name.dispose();
    phone.dispose();
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;
  const _Stat({required this.value, required this.label});
  @override
  Widget build(BuildContext context) => Expanded(
      child: Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFECE4E9)),
              borderRadius: BorderRadius.circular(16)),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: Theme.of(context).textTheme.headlineMedium),
                Text(label)
              ])));
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  const _Tile(
      {required this.icon,
      required this.title,
      required this.subtitle,
      this.onTap});
  @override
  Widget build(BuildContext context) => ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
              color: const Color(0xFFF7F2F5),
              borderRadius: BorderRadius.circular(12)),
          child: Icon(icon)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(subtitle),
      trailing: onTap == null ? null : const Icon(Icons.chevron_right),
      onTap: onTap);
}

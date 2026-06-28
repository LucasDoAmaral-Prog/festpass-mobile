# FestPass

Aplicativo Flutter para descobrir eventos universitários, salvar favoritos e comprar/gerenciar ingressos. A implementação foi organizada especificamente para demonstrar os requisitos acadêmicos de navegação, internet, persistência, autenticação e divisão em três camadas.

## Como executar

O projeto está preparado para Android. Com Flutter e as CLIs do Firebase instalados:

```bash
flutter pub get
dart pub global activate flutterfire_cli
flutterfire configure
firebase deploy --only database
flutter run
```

No Firebase Console, habilite **Authentication > E-mail/senha** e crie o **Realtime Database**. O aplicativo Android está registrado no projeto `festpass-a318c` pelo arquivo `android/app/google-services.json`. Na primeira abertura, use **Criar uma conta**; a sessão é mantida pelo Firebase Authentication.

## Arquitetura em três camadas

```text
Interface (lib/features)
        ↓ ações / estado
BLoC (lib/blocs)
        ↓ regras e coordenação
Data Provider (lib/data/providers)
        ↓
Firebase Auth + Realtime Database + API ViaCEP/HTTP
```

- **Interface gráfica:** telas de autenticação, exploração, detalhes, checkout, ingressos e perfil.
- **BLoC:** estado e regras de autenticação, eventos/favoritos, compra/ingressos e CEP/endereço.
- **Data Provider:** operações no Firebase Auth/Realtime Database e requisição REST que recebe JSON.

O Realtime Database contém `events` e, dentro de `users/{uid}`, os dados privados de `profile`, `favorites`, `tickets` e `address`. Os eventos iniciais são semeados no primeiro acesso autenticado. As regras de `database.rules.json` garantem que cada usuário acesse apenas os próprios dados.

## Checklist da entrega

- Navegação inferior deixa Explorar, Ingressos e Perfil a um toque; detalhes e checkout formam uma jornada linear.
- Internet: no checkout, a lupa do CEP chama `https://viacep.com.br/ws/{cep}/json/` e preenche o formulário com o JSON recebido.
- Armazenamento Firebase: perfil, favoritos, endereço e ingressos persistem no Realtime Database.
- Autenticação não hardcoded: cadastro, login, logout e restauração de sessão usam Firebase Authentication; dados privados são vinculados ao UID autenticado.
- Listagem com figuras: eventos vêm do Realtime Database e cada categoria possui banner gráfico identificável, com cores e iniciais próprias.
- CRUD: compra cria ingresso; área privada lê; cancelamento atualiza; exclusão remove. Perfil e endereço também podem ser atualizados.

## Roteiro curto para a apresentação

1. Explique que o FestPass reúne descoberta e gestão de ingressos para festas e eventos universitários.
2. Crie duas contas diferentes e mostre que favoritos e ingressos de uma não aparecem na outra.
3. Pesquise um evento, favorite-o e abra os detalhes.
4. Escolha lote/quantidade; no checkout digite um CEP real e toque na lupa. Destaque o selo “ViaCEP · internet”.
5. Conclua a compra, abra o ingresso e seu QR visual, cancele e exclua o registro.
6. Edite nome/telefone no Perfil e explique o endereço salvo.
7. Mostre o Firebase Console com Authentication e Realtime Database; depois abra `firebase_service.dart`, uma tela, seu BLoC e seu Data Provider para evidenciar as três camadas.

> Para demonstrar a persistência, abra **Firebase Console > Realtime Database > Dados** e mostre os nós sendo atualizados após cadastrar, favoritar e comprar.

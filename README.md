# FestPass

Aplicativo mobile para descobrir eventos universitários e gerenciar toda a jornada de compra de ingressos em um só lugar.

> **Status:** concluído — versão `1.0.0+1`.

## Funcionalidades

- Cadastro, login, logout e restauração de sessão com Firebase Authentication.
- Catálogo de eventos com busca por nome, cidade ou categoria.
- Favoritos privados e persistentes para cada usuário.
- Detalhes do evento, seleção de lote e quantidade de ingressos.
- Checkout com Pix ou cartão de crédito.
- Consulta de CEP pela API ViaCEP e preenchimento automático do endereço.
- Histórico de ingressos com visualização, cancelamento e exclusão.
- Perfil editável com nome, telefone e endereço salvo.
- Isolamento dos dados privados por UID no Firebase Realtime Database.

## Tecnologias

- Flutter e Dart
- Firebase Authentication
- Firebase Realtime Database
- API REST ViaCEP
- BLoC com `ChangeNotifier`
- Material Design 3

## Arquitetura

O projeto utiliza três camadas para separar interface, estado e acesso a dados:

```text
Interface (lib/features)
        ↓ ações e estado
BLoC (lib/blocs)
        ↓ regras e coordenação
Data Provider (lib/data/providers)
        ↓
Firebase Auth + Realtime Database + ViaCEP
```

```text
lib/
├── blocs/             # Estado e regras de negócio
├── core/              # Modelos e dados iniciais
├── data/providers/    # Firebase e integrações HTTP
├── features/          # Telas organizadas por funcionalidade
├── shared/            # Escopo e componentes reutilizáveis
└── main.dart          # Inicialização, tema, rotas e navegação
```

No Realtime Database, os eventos ficam em `events`. Os dados particulares são armazenados em `users/{uid}`, nos nós `profile`, `favorites`, `tickets` e `address`. As regras em `database.rules.json` exigem autenticação e limitam cada usuário ao próprio UID.

## Como executar

### Pré-requisitos

- Flutter com Dart SDK `>=3.6.0 <4.0.0`
- Android Studio ou outro ambiente Android configurado
- Dispositivo físico ou emulador Android

### Instalação

```bash
git clone https://github.com/LucasDoAmaral-Prog/festpass-mobile.git
cd festpass-mobile
flutter pub get
```

Crie a configuração local a partir do modelo:

```bash
cp .env.example .env
```

No PowerShell, use `Copy-Item .env.example .env`. Preencha o `.env` com a configuração do cliente Firebase e execute:

```bash
flutter run --dart-define-from-file=.env
```

Na primeira execução, crie uma conta pela tela inicial. A sessão e os dados do usuário são sincronizados pelo Firebase.

Para conectar o aplicativo a outro projeto Firebase, habilite **Authentication por e-mail/senha** e o **Realtime Database**, substitua a configuração do cliente e publique as regras:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
firebase deploy --only database
```

## Qualidade

Execute as verificações locais antes de gerar uma versão:

```bash
flutter analyze
flutter test
```

## Segurança

- Senhas são tratadas pelo Firebase Authentication e não são armazenadas pelo aplicativo.
- Perfil, favoritos, endereço e ingressos são protegidos por UID nas regras do banco.
- O `.env` local é ignorado pelo Git; somente o modelo vazio `.env.example` é versionado.
- Chaves privadas, keystores e credenciais de contas de serviço são bloqueados pelo `.gitignore`.
- `google-services.json` e as opções Firebase presentes no cliente contêm identificadores públicos necessários para o app; não são chaves administrativas. Chaves privadas e arquivos de conta de serviço nunca devem ser versionados.

Para reduzir uso indevido da configuração pública, aplique restrições de aplicativo e de API à chave no Google Cloud Console.

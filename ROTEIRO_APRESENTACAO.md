# Roteiro de apresentação — FestPass

## Antes de gravar

- Testar o aplicativo em um celular Android ou emulador, não somente no Chrome.
- Deixar abertas duas abas do Firebase Console: **Authentication > Usuários** e **Realtime Database > Dados**.
- Ter duas contas de demonstração para provar que favoritos e ingressos são privados.
- Deixar preparado um CEP válido, por exemplo `01001-000`.
- Ensaiar uma compra, um cancelamento e uma exclusão antes da gravação.
- Cada integrante deve apresentar sua contribuição individual antes de demonstrar sua parte.

## Divisão sugerida

| Integrante | Parte principal | Tempo aproximado |
|---|---|---:|
| Rafael | Introdução, interface, autenticação e navegação | 4 min |
| Lucas | Eventos, listagem visual, favoritos, detalhes, checkout e ViaCEP | 5 min |
| João | Ingressos, CRUD, perfil, Firebase e arquitetura em três camadas | 5 min |

## Rafael — Propósito, interface e autenticação

### 1. Abertura

**Falar:**

> Olá, nós somos Rafael, Lucas e João, e este é o FestPass. O aplicativo foi criado para facilitar a descoberta de eventos universitários e concentrar em um só lugar os favoritos, a compra e o gerenciamento de ingressos. O problema que queremos resolver é a dispersão das informações de eventos e a dificuldade de acompanhar os ingressos adquiridos.

### 2. Participação dos integrantes

**Falar:**

> Eu sou o Rafael. Fiquei responsável pela estrutura da interface gráfica, incluindo as telas de cadastro e login, o tema visual, os componentes compartilhados e a navegação entre Explorar, Ingressos e Perfil. Também trabalhei no fluxo de autenticação visto pela interface, nas validações dos formulários e na organização das rotas do aplicativo.

> O Lucas ficou responsável pelo fluxo de descoberta e compra, incluindo eventos, busca, favoritos, detalhes, lotes, checkout e integração com a API ViaCEP. O João ficou responsável pela integração com Firebase Authentication e Realtime Database, persistência dos dados, gerenciamento dos ingressos e organização das camadas de dados. Apesar da divisão, revisamos e integramos o aplicativo em conjunto.

### 3. Tecnologias

**Mostrar:** `pubspec.yaml` rapidamente.

**Falar:**

> O aplicativo foi desenvolvido em Flutter e Dart. Usamos Firebase Authentication para cadastro, login e persistência da sessão; Firebase Realtime Database para armazenar eventos e dados privados; e o pacote HTTP para acessar a API REST ViaCEP, que devolve dados em JSON. No `pubspec.yaml`, as principais dependências são `firebase_core`, `firebase_auth`, `firebase_database` e `http`.

### 4. Cadastro e login

**Fazer:** abrir a tela inicial e cadastrar ou entrar com a primeira conta.

**Falar:**

> A autenticação não é hardcoded. Ao criar a conta, o aplicativo chama o Firebase Authentication. O Firebase devolve um UID exclusivo, e esse UID é usado para separar perfil, favoritos, endereço e ingressos no banco. A senha não é armazenada pelo nosso aplicativo.

### 5. Navegação

**Fazer:** mostrar as abas **Explorar**, **Ingressos** e **Perfil**.

**Falar:**

> Depois da autenticação, todas as funções principais ficam acessíveis pela barra inferior. Explorar mostra os eventos, Ingressos é a área privada de compras e Perfil concentra os dados do usuário e o logout. Os detalhes e o checkout seguem uma navegação linear para evitar caminhos confusos.

**Transição:**

> Agora o Lucas vai demonstrar a descoberta dos eventos e o uso da internet durante o checkout.

## Lucas — Listagem, figuras, favoritos e internet

### Participação individual

**Falar:**

> Eu sou o Lucas. Minha principal contribuição foi o fluxo de eventos e compra. Implementei a listagem visual, a pesquisa por evento, cidade ou categoria, os favoritos, a tela de detalhes e a escolha de lotes e quantidades. Também desenvolvi o checkout e a comunicação HTTP com a API ViaCEP, incluindo o tratamento do JSON recebido e o preenchimento do endereço.

### 6. Listagem de eventos

**Fazer:** percorrer a tela Explorar, usar a busca e abrir um evento.

**Falar:**

> Os eventos mostrados aqui são lidos do Realtime Database e apresentados em uma listagem agradável. Cada registro informa nome, data, local, categoria e preço. Também criamos banners gráficos diferentes e relacionados a cada evento, com cores e iniciais próprias, para que a figura ajude a identificar visualmente o registro.

> A pesquisa filtra por nome, cidade ou categoria. Ao selecionar um item, abrimos seus detalhes, com descrição, local, data, lotes e valores.

### 7. Favoritos particularizados

**Fazer:** favoritar um evento e mostrar o contador no Perfil.

**Falar:**

> O favorito é gravado em `users`, dentro do UID autenticado. Portanto, ele pertence somente a esta conta. O estado visual é atualizado imediatamente e continua salvo depois que o aplicativo é fechado.

### 8. Checkout e ViaCEP

**Fazer:** escolher lote e quantidade, avançar ao checkout, digitar `01001-000` e tocar na lupa.

**Falar antes da busca:**

> Neste momento demonstramos um acesso explícito à internet. O aplicativo envia o CEP em uma requisição HTTP GET para `viacep.com.br/ws/CEP/json/`.

**Falar depois do preenchimento:**

> A API respondeu em JSON. O Data Provider converteu a resposta e preencheu rua, bairro, cidade e estado. O usuário informa o número e pode salvar o endereço no Firebase para reutilização futura.

### 9. Compra

**Fazer:** selecionar Pix ou crédito, confirmar e mostrar a tela de sucesso.

**Falar:**

> Ao confirmar, o aplicativo cria um ingresso dentro do UID do usuário no Realtime Database. São armazenados o evento, lote, quantidade, valor, forma de pagamento, status e data da compra. A tela de confirmação apresenta o identificador gerado pelo Firebase.

**Transição:**

> O João vai mostrar como esses dados retornam ao usuário, o CRUD e a organização interna do código.

## João — CRUD, persistência e três camadas

### Participação individual

**Falar:**

> Eu sou o João. Fiquei responsável pela integração do aplicativo com o Firebase Authentication e o Realtime Database. Implementei a persistência de perfis, favoritos, endereços e ingressos por UID, além das operações de criação, leitura, cancelamento, atualização e exclusão. Também trabalhei na separação entre Interface Gráfica, BLoC e Data Provider e nas regras de segurança do banco.

### 10. Área privada de ingressos

**Fazer:** abrir **Ingressos**, abrir o ingresso e mostrar o QR visual.

**Falar:**

> Esta é uma tela privada. A listagem consulta somente `users/UID/tickets`, por isso cada conta visualiza apenas os próprios ingressos. Os dados não apenas entram no banco: eles retornam em forma de histórico e podem ser gerenciados.

### 11. CRUD

**Fazer:** cancelar o ingresso e depois excluí-lo.

**Falar:**

> Aqui demonstramos as operações de CRUD. A compra cria o ingresso; a tela faz a leitura; o cancelamento atualiza o status para cancelado; e a exclusão remove definitivamente o registro. A regra de negócio permite excluir somente um ingresso já cancelado.

### 12. Perfil e atualização

**Fazer:** abrir **Perfil**, editar nome ou telefone e salvar.

**Falar:**

> O perfil também é particularizado pelo UID. Nome e telefone podem ser modificados, e o endereço pode ser atualizado no checkout. O logout encerra a sessão e impede o acesso às telas privadas.

### 13. Firebase Console

**Fazer:** alternar para o Firebase Console. Mostrar primeiro **Authentication > Usuários** e depois **Realtime Database > Dados**. Expandir `events` e `users/UID`.

**Falar:**

> No Firebase Authentication podemos ver a conta criada e seu UID. No Realtime Database, `events` contém os dados da listagem. Em `users/UID`, ficam `profile`, `favorites`, `address` e `tickets`. Isso comprova que o banco é persistente e está hospedado na nuvem, não apenas na memória do aplicativo.

> As regras do banco exigem autenticação e comparam `auth.uid` com o UID do caminho. Assim, um usuário não pode ler nem alterar os dados privados de outro.

### 14. Arquitetura em três camadas

**Mostrar:** uma tela, seu BLoC e seu Data Provider. Sugestão: `my_tickets_screen.dart`, `tickets_bloc.dart` e `tickets_data_provider.dart`.

**Falar:**

> O código está dividido nas três camadas exigidas. A Interface Gráfica, dentro de `features`, recebe as ações do usuário e renderiza o estado. O BLoC, dentro de `blocs`, coordena estado e regras, sem conhecer detalhes do Firebase. O Data Provider, dentro de `data/providers`, executa autenticação, leitura, criação, atualização e remoção no Firebase ou a chamada HTTP ao ViaCEP.

> Por exemplo, ao cancelar um ingresso, a tela chama o `TicketsBloc`; o BLoC identifica o usuário e chama o `TicketsDataProvider`; e o Data Provider atualiza o status no Realtime Database. O resultado volta pelas camadas e a interface recarrega a lista.

### 15. Prova de separação entre usuários

**Fazer:** sair, entrar com a segunda conta e abrir Favoritos/Ingressos.

**Falar:**

> Ao entrar com uma segunda conta, os favoritos e ingressos anteriores não aparecem. Isso demonstra que a autenticação é relevante e que os dados estão realmente particularizados por usuário.

### 16. Encerramento

**Falar:**

> Com isso, o FestPass demonstra navegação coerente, comunicação com a internet, persistência em nuvem, autenticação com dados privados, listagem visual, operações de criação, leitura, atualização e exclusão, e a divisão em Interface Gráfica, BLoC e Data Provider.

## Checklist final da gravação

- [ ] Os três integrantes aparecem e falam no vídeo.
- [ ] Rafael, Lucas e João declaram suas contribuições individuais.
- [ ] O aplicativo é demonstrado em Android ou emulador.
- [ ] Cadastro e login são demonstrados.
- [ ] As três abas e todas as telas são visitadas.
- [ ] A listagem e os banners distintos são mostrados.
- [ ] A busca, o favorito e os detalhes são mostrados.
- [ ] O ViaCEP é usado ao vivo e o JSON é explicado.
- [ ] Uma compra é concluída.
- [ ] O ingresso é lido, cancelado e excluído.
- [ ] O perfil é atualizado.
- [ ] O Firebase Authentication e o Realtime Database são mostrados no console.
- [ ] A separação entre dois usuários é demonstrada.
- [ ] As três camadas são explicadas com arquivos reais.
- [ ] A entrega final é um arquivo `.zip`, não `.rar`.

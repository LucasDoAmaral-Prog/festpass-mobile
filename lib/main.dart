import 'package:flutter/material.dart';

import 'blocs/auth_bloc.dart';
import 'blocs/checkout_bloc.dart';
import 'blocs/events_bloc.dart';
import 'blocs/tickets_bloc.dart';
import 'data/providers/address_data_provider.dart';
import 'data/providers/auth_data_provider.dart';
import 'data/providers/firebase_service.dart';
import 'data/providers/events_data_provider.dart';
import 'data/providers/tickets_data_provider.dart';
import 'data/providers/via_cep_provider.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/checkout/checkout_screen.dart';
import 'features/checkout/confirmation_screen.dart';
import 'features/events/screens/event_details_screen.dart';
import 'features/events/screens/home_screen.dart';
import 'features/profile/screens/profile_screen.dart';
import 'features/tickets/screens/my_tickets_screen.dart';
import 'shared/app_scope.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final firebase = await FirebaseService.initialize();
    final auth = AuthBloc(AuthDataProvider(firebase));
    await auth.restoreSession();
    runApp(FestPassApp(
      auth: auth,
      events: EventsBloc(EventsDataProvider(firebase)),
      tickets: TicketsBloc(TicketsDataProvider(firebase)),
      checkout: CheckoutBloc(
        ViaCepProvider(),
        AddressDataProvider(firebase),
      ),
    ));
  } catch (error, stackTrace) {
    debugPrint('Falha ao iniciar o Firebase: $error');
    debugPrintStack(stackTrace: stackTrace);
    runApp(FirebaseStartupErrorApp(error: error.toString()));
  }
}

class FirebaseStartupErrorApp extends StatelessWidget {
  final String error;

  const FirebaseStartupErrorApp({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FestPass',
      debugShowCheckedModeBanner: false,
      theme: _theme(),
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(28),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.cloud_off_outlined,
                      size: 72,
                      color: Color(0xFFE51F68),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Firebase ainda não foi configurado',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Para abrir o FestPass, conecte este projeto Flutter ao '
                      'projeto Firebase usado no trabalho.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFECE4E9)),
                      ),
                      child: const SelectableText(
                        '1. Habilite Authentication > E-mail/senha\n'
                        '2. Crie o Realtime Database\n'
                        '3. Adicione android/app/google-services.json\n'
                        '4. Execute novamente: flutter run',
                        style: TextStyle(height: 1.65),
                      ),
                    ),
                    const SizedBox(height: 18),
                    ExpansionTile(
                      title: const Text('Detalhes técnicos'),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: SelectableText(
                            error,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FestPassApp extends StatelessWidget {
  final AuthBloc auth;
  final EventsBloc events;
  final TicketsBloc tickets;
  final CheckoutBloc checkout;

  const FestPassApp({
    super.key,
    required this.auth,
    required this.events,
    required this.tickets,
    required this.checkout,
  });

  @override
  Widget build(BuildContext context) {
    return AppScope(
      auth: auth,
      events: events,
      tickets: tickets,
      checkout: checkout,
      child: MaterialApp(
        title: 'FestPass',
        debugShowCheckedModeBanner: false,
        theme: _theme(),
        home: const AuthGate(),
        routes: {
          '/main': (_) => const MainNavigatorScreen(),
          '/event_details': (_) => const EventDetailsScreen(),
          '/checkout': (_) => const CheckoutScreen(),
          '/confirmation': (_) => const ConfirmationScreen(),
        },
      ),
    );
  }
}

ThemeData _theme() {
  const ink = Color(0xFF17131F);
  const pink = Color(0xFFE51F68);
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFFFFFBFC),
    colorScheme: ColorScheme.fromSeed(
      seedColor: pink,
      primary: pink,
      secondary: const Color(0xFF7B2CBF),
      surface: Colors.white,
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(fontWeight: FontWeight.w900, color: ink),
      titleLarge: TextStyle(fontWeight: FontWeight.w800, color: ink),
      titleMedium: TextStyle(fontWeight: FontWeight.w700, color: ink),
      bodyLarge: TextStyle(color: ink),
      bodyMedium: TextStyle(color: Color(0xFF655D6D)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF7F2F5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: pink,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontWeight: FontWeight.w800),
      ),
    ),
  );
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AppScope.of(context).auth;
    return ListenableBuilder(
      listenable: auth,
      builder: (context, _) =>
          auth.user == null ? const LoginScreen() : const MainNavigatorScreen(),
    );
  }
}

class MainNavigatorScreen extends StatefulWidget {
  const MainNavigatorScreen({super.key});

  @override
  State<MainNavigatorScreen> createState() => _MainNavigatorScreenState();
}

class _MainNavigatorScreenState extends State<MainNavigatorScreen> {
  int _index = 0;
  String? _loadedUser;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final scope = AppScope.of(context);
    final userId = scope.auth.user!.id;
    if (_loadedUser != userId) {
      _loadedUser = userId;
      scope.events.load(userId);
      scope.tickets.load(userId);
    }
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map && args['tabIndex'] is int) {
      _index = args['tabIndex'] as int;
    }
  }

  @override
  Widget build(BuildContext context) {
    const screens = [HomeScreen(), MyTicketsScreen(), ProfileScreen()];
    return Scaffold(
      body: IndexedStack(index: _index, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        indicatorColor: const Color(0xFFFFDCE9),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.explore_outlined),
              selectedIcon: Icon(Icons.explore),
              label: 'Explorar'),
          NavigationDestination(
              icon: Icon(Icons.confirmation_number_outlined),
              selectedIcon: Icon(Icons.confirmation_number),
              label: 'Ingressos'),
          NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Perfil'),
        ],
      ),
    );
  }
}

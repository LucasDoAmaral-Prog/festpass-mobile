import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../core/data/seed_events.dart';

class FirebaseService {
  final FirebaseAuth auth;
  final FirebaseDatabase database;

  FirebaseService._({required this.auth, required this.database});

  static const _webOptions = FirebaseOptions(
    apiKey: String.fromEnvironment('FIREBASE_API_KEY'),
    appId: String.fromEnvironment('FIREBASE_APP_ID'),
    messagingSenderId: String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID'),
    projectId: String.fromEnvironment('FIREBASE_PROJECT_ID'),
    authDomain: String.fromEnvironment('FIREBASE_AUTH_DOMAIN'),
    databaseURL: String.fromEnvironment('FIREBASE_DATABASE_URL'),
    storageBucket: String.fromEnvironment('FIREBASE_STORAGE_BUCKET'),
  );

  static Future<FirebaseService> initialize() async {
    if (kIsWeb) {
      _validateWebOptions();
    }
    await Firebase.initializeApp(
      options: kIsWeb ? _webOptions : null,
    );
    return FirebaseService._(
      auth: FirebaseAuth.instance,
      database: FirebaseDatabase.instance,
    );
  }

  static void _validateWebOptions() {
    final requiredValues = {
      'FIREBASE_API_KEY': _webOptions.apiKey,
      'FIREBASE_APP_ID': _webOptions.appId,
      'FIREBASE_MESSAGING_SENDER_ID': _webOptions.messagingSenderId,
      'FIREBASE_PROJECT_ID': _webOptions.projectId,
      'FIREBASE_AUTH_DOMAIN': _webOptions.authDomain,
      'FIREBASE_DATABASE_URL': _webOptions.databaseURL,
      'FIREBASE_STORAGE_BUCKET': _webOptions.storageBucket,
    };
    final missing = requiredValues.entries
        .where((entry) => entry.value == null || entry.value!.isEmpty)
        .map((entry) => entry.key)
        .toList();
    if (missing.isNotEmpty) {
      throw StateError(
        'Configuração Firebase ausente: ${missing.join(', ')}. '
        'Execute com --dart-define-from-file=.env.',
      );
    }
  }

  Future<void> ensureSeedEvents() async {
    final events = database.ref('events');
    final snapshot = await events.get();
    final existing = snapshot.value is Map
        ? (snapshot.value as Map).keys.map((key) => key.toString()).toSet()
        : <String>{};
    final writes = <Future<void>>[];
    for (var index = 0; index < seedEvents.length; index++) {
      final event = seedEvents[index];
      if (existing.contains(event.id)) continue;
      writes.add(events.child(event.id).set({
        ...event.toMap(),
        'sort_index': index,
        'seeded': true,
      }));
    }
    await Future.wait(writes);
  }
}

Map<String, dynamic> firebaseMap(Object? value) {
  if (value is! Map) return <String, dynamic>{};
  return value.map(
    (key, item) => MapEntry(key.toString(), item),
  );
}

import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../core/data/seed_events.dart';

class FirebaseService {
  final FirebaseAuth auth;
  final FirebaseDatabase database;

  FirebaseService._({required this.auth, required this.database});

  static Future<FirebaseService> initialize() async {
    await Firebase.initializeApp(
      options: kIsWeb
          ? const FirebaseOptions(
              apiKey: 'AIzaSyB-x8g8BOoKEzRRl-47O504-6TMipRAHQc',
              appId: '1:557857217695:android:f130a01080842ec73e96aa',
              messagingSenderId: '557857217695',
              projectId: 'festpass-a318c',
              authDomain: 'festpass-a318c.firebaseapp.com',
              databaseURL: 'https://festpass-a318c-default-rtdb.firebaseio.com',
              storageBucket: 'festpass-a318c.firebasestorage.app',
            )
          : null,
    );
    return FirebaseService._(
      auth: FirebaseAuth.instance,
      database: FirebaseDatabase.instance,
    );
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

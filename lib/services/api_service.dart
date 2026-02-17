import 'package:http/http.dart' as http;
import '../models/flashcard.dart';
import 'cache_service.dart';

class ApiService {
  static const String apiUrl =
      'https://gist.githubusercontent.com/CalvertWanguy/b2d7ff31dcdb35d236d3d1a9a7067494/raw';

  final CacheService cacheService = CacheService();

  Future<List<Flashcard>> fetchFlashcards() async {
    try {
      final http.Response response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        await cacheService.saveFlashcards(response.body);
        return Flashcard.listFromJson(response.body);
      }
    } catch (_) {
      // Ignore network errors and continue with local fallbacks.
    }

    final String? cachedData = await cacheService.getCachedFlashcards();
    if (cachedData != null && cachedData.isNotEmpty) {
      try {
        return Flashcard.listFromJson(cachedData);
      } catch (_) {
        // Corrupted cache, continue with bundled cards.
      }
    }

    final List<Flashcard> offlineCards = _offlineFlashcards();
    if (offlineCards.isNotEmpty) {
      return offlineCards;
    }

    throw Exception('Impossible de charger les flashcards.');
  }

  List<Flashcard> _offlineFlashcards() {
    return <Flashcard>[
      Flashcard(
        id: 'offline_flutter_stateful',
        category: 'flutter',
        question: 'Quelle est la difference entre StatelessWidget et StatefulWidget ?',
        answer:
            'StatelessWidget est immuable. StatefulWidget peut changer via son State.',
        explanation:
            'Utilise StatelessWidget pour une UI fixe et StatefulWidget quand les donnees changent.',
        docUrl: 'https://docs.flutter.dev/ui',
        logoUrl: '',
      ),
      Flashcard(
        id: 'offline_dart_future',
        category: 'dart',
        question: 'A quoi sert Future en Dart ?',
        answer:
            'Future represente une valeur disponible plus tard pour les traitements asynchrones.',
        explanation:
            'Les appels reseau et les operations I/O utilisent souvent Future avec async/await.',
        docUrl: 'https://dart.dev/libraries/async/async-await',
        logoUrl: '',
      ),
      Flashcard(
        id: 'offline_api_get',
        category: 'api',
        question: 'Que fait une requete HTTP GET ?',
        answer: 'Elle recupere des donnees depuis un serveur sans modifier la ressource.',
        explanation:
            'GET est la methode la plus courante pour lire des ressources distantes.',
        docUrl: 'https://developer.mozilla.org/fr/docs/Web/HTTP/Methods/GET',
        logoUrl: '',
      ),
      Flashcard(
        id: 'offline_git_commit',
        category: 'git',
        question: 'A quoi sert git commit ?',
        answer: 'git commit enregistre un snapshot des changements dans l historique local.',
        explanation:
            'Un bon commit contient un message clair et un ensemble coherent de modifications.',
        docUrl: 'https://git-scm.com/docs/git-commit',
        logoUrl: '',
      ),
      Flashcard(
        id: 'offline_firebase_firestore',
        category: 'firebase',
        question: 'Qu est-ce que Cloud Firestore ?',
        answer:
            'Une base NoSQL cloud temps reel pour stocker et synchroniser les donnees.',
        explanation:
            'Firestore offre des ecoutes temps reel et une bonne integration avec Flutter.',
        docUrl: 'https://firebase.google.com/docs/firestore',
        logoUrl: '',
      ),
    ];
  }
}

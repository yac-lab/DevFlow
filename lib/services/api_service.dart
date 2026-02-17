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
        id: 'offline_flutter_hot_reload',
        category: 'flutter',
        question: 'A quoi sert le hot reload dans Flutter ?',
        answer: 'Il applique les changements de code a chaud sans redemarrer l app.',
        explanation:
            'Le hot reload accelere le debug en conservant l etat de l application.',
        docUrl: 'https://docs.flutter.dev/tools/hot-reload',
        logoUrl: '',
      ),
      Flashcard(
        id: 'offline_flutter_layout',
        category: 'flutter',
        question: 'Quelle difference entre Row et Column ?',
        answer: 'Row aligne horizontalement, Column aligne verticalement.',
        explanation:
            'Utilise les axes principaux et secondaires pour controler la mise en page.',
        docUrl: 'https://docs.flutter.dev/ui/layout',
        logoUrl: '',
      ),
      Flashcard(
        id: 'offline_flutter_state_mgmt',
        category: 'flutter',
        question: 'Pourquoi utiliser Provider en Flutter ?',
        answer: 'Pour partager et reactualiser l etat entre plusieurs widgets.',
        explanation:
            'Provider simplifie la gestion d etat et evite les passes de props lourds.',
        docUrl: 'https://pub.dev/packages/provider',
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
        id: 'offline_dart_null_safety',
        category: 'dart',
        question: 'Qu est-ce que la null safety en Dart ?',
        answer: 'Elle force a declarer si une variable peut etre nulle ou non.',
        explanation:
            'Cela reduit les erreurs a l execution en detectant les problemes a la compilation.',
        docUrl: 'https://dart.dev/null-safety',
        logoUrl: '',
      ),
      Flashcard(
        id: 'offline_dart_stream',
        category: 'dart',
        question: 'A quoi sert Stream en Dart ?',
        answer: 'Stream fournit une suite de valeurs asynchrones au fil du temps.',
        explanation:
            'Utile pour les evenements continus comme les clics ou les donnees temps reel.',
        docUrl: 'https://dart.dev/tutorials/language/streams',
        logoUrl: '',
      ),
      Flashcard(
        id: 'offline_dart_collections',
        category: 'dart',
        question: 'Quelle difference entre List et Map en Dart ?',
        answer: 'List est indexee, Map associe une cle a une valeur.',
        explanation:
            'List est ordonnee par index, Map est un dictionnaire cle/valeur.',
        docUrl: 'https://dart.dev/language/collections',
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
        id: 'offline_api_post',
        category: 'api',
        question: 'Quand utiliser une requete HTTP POST ?',
        answer: 'Pour creer une nouvelle ressource ou envoyer des donnees au serveur.',
        explanation:
            'POST transporte un body et est utilise pour les creations ou actions.',
        docUrl: 'https://developer.mozilla.org/fr/docs/Web/HTTP/Methods/POST',
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
        id: 'offline_git_branch',
        category: 'git',
        question: 'Pourquoi utiliser des branches Git ?',
        answer: 'Pour isoler des changements et experimenter sans casser la branche principale.',
        explanation:
            'Les branches facilitent le travail en equipe et les revues de code.',
        docUrl: 'https://git-scm.com/book/en/v2/Git-Branching-Branches-in-a-Nutshell',
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
      Flashcard(
        id: 'offline_firebase_auth',
        category: 'firebase',
        question: 'A quoi sert Firebase Authentication ?',
        answer: 'A gerer les utilisateurs et les connexions dans une application.',
        explanation:
            'Elle prend en charge email, Google, Apple et d autres fournisseurs.',
        docUrl: 'https://firebase.google.com/docs/auth',
        logoUrl: '',
      ),
      Flashcard(
        id: 'offline_android_activity',
        category: 'android',
        question: 'Qu est-ce qu une Activity Android ?',
        answer: 'Un ecran de l application qui gere l interaction utilisateur.',
        explanation:
            'Une app Android est composee de plusieurs activities selon les ecrans.',
        docUrl: 'https://developer.android.com/guide/components/activities/intro-activities',
        logoUrl: '',
      ),
      Flashcard(
        id: 'offline_android_manifest',
        category: 'android',
        question: 'A quoi sert AndroidManifest.xml ?',
        answer: 'Il decrit les composants et permissions de l application.',
        explanation:
            'Le manifest declare activities, services, permissions et config globale.',
        docUrl: 'https://developer.android.com/guide/topics/manifest/manifest-intro',
        logoUrl: '',
      ),
    ];
  }
}

import 'package:http/http.dart' as http;
import '../models/flashcard.dart';
import 'cache_service.dart';

class ApiService {
  static const String apiUrl =
      'https://gist.githubusercontent.com/CalvertWanguy/b2d7ff31dcdb35d236d3d1a9a7067494/raw';

  CacheService cacheService = CacheService();
  Future<List<Flashcard>> fetchFlashcards() async {
    try {
      print('📡 Chargement depuis l\'API...');
      http.Response response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        print('✅ API OK - Sauvegarde en cache');
        await cacheService.saveFlashcards(response.body);
        return Flashcard.listFromJson(response.body);
      }
    } catch (e) {
      print('❌ Erreur API: $e');
    }
    print('📦 Tentative de chargement depuis le cache...');
    String? cachedData = await cacheService.getCachedFlashcards();

    if (cachedData != null) {
      print('✅ Cache OK');
      return Flashcard.listFromJson(cachedData);
    }
    print('❌ Pas de données disponibles');
    throw Exception(
      'Impossible de charger les flashcards. Verifie ta connexion !',
    );
  }
}

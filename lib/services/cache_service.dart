import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  // Clés pour SharedPreferences
  static const String flashcardsDataKey = 'flashcards_data';
  static const String lastUpdateKey = 'last_update';
  
  // Sauvegarder les flashcards localement
  Future<void> saveFlashcards(String jsonData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(flashcardsDataKey, jsonData);
    await prefs.setString(lastUpdateKey, DateTime.now().toIso8601String());
    print('💾 Flashcards sauvegardées localement');
  }
  
  // Récupérer les flashcards du cache
  Future<String?> getCachedFlashcards() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(flashcardsDataKey);
  }
  
  // Vérifier si on a des données en cache
  Future<bool> hasCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(flashcardsDataKey);
  }
  
  // Récupérer la date de dernière mise à jour
  Future<String?> getLastUpdate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(lastUpdateKey);
  }
}

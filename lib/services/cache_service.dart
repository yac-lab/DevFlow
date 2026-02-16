import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static const String flashcardsDataKey = 'flashcards_data';
  static const String lastUpdateKey = 'last_update';
  Future<void> saveFlashcards(String jsonData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(flashcardsDataKey, jsonData);
    await prefs.setString(lastUpdateKey, DateTime.now().toIso8601String());
    print('💾 Flashcards sauvegardées localement');
  }

  Future<String?> getCachedFlashcards() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(flashcardsDataKey);
  }

  Future<bool> hasCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(flashcardsDataKey);
  }

  Future<String?> getLastUpdate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(lastUpdateKey);
  }
}

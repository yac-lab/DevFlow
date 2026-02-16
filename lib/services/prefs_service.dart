import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  static const String favoriteIdsKey = 'favorite_ids';
  static const String cardsViewedKey = 'cards_viewed';
  static const String totalProgressKey = 'total_progress';
  Future<List<String>> getFavoriteIds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoriteIds = prefs.getStringList(favoriteIdsKey);
    return favoriteIds ?? []; // Retourner [] si null
  }

  Future<void> saveFavoriteIds(List<String> ids) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(favoriteIdsKey, ids);
  }

  Future<int> getCardsViewed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? cardsViewed = prefs.getInt(cardsViewedKey);
    return cardsViewed ?? 0; // Retourner 0 si null
  }

  Future<void> incrementCardsViewed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int currentCards = prefs.getInt(cardsViewedKey) ?? 0;
    await prefs.setInt(cardsViewedKey, currentCards + 1);
    int currentTotal = prefs.getInt(totalProgressKey) ?? 0;
    await prefs.setInt(totalProgressKey, currentTotal + 1);

    print('📊 Progression: ${currentCards + 1}');
  }

  Future<int> getTotalProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? totalProgress = prefs.getInt(totalProgressKey);
    return totalProgress ?? 0; // Retourner 0 si null
  }

  Future<void> resetSessionProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(cardsViewedKey, 0);
    print('🔄 Session réinitialisée');
  }
}

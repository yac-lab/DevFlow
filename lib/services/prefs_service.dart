import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  // Clés pour SharedPreferences
  static const String favoriteIdsKey = 'favorite_ids';
  static const String cardsViewedKey = 'cards_viewed';
  static const String totalProgressKey = 'total_progress';
  
  // --- GESTION DES FAVORIS ---
  
  // Récupérer la liste des IDs favoris
  Future<List<String>> getFavoriteIds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoriteIds = prefs.getStringList(favoriteIdsKey);
    return favoriteIds ?? [];  // Retourner [] si null
  }
  
  // Sauvegarder les IDs favoris
  Future<void> saveFavoriteIds(List<String> ids) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(favoriteIdsKey, ids);
  }
  
  // --- GESTION DE LA PROGRESSION ---
  
  // Récupérer le nombre de cartes vues dans cette session
  Future<int> getCardsViewed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? cardsViewed = prefs.getInt(cardsViewedKey);
    return cardsViewed ?? 0;  // Retourner 0 si null
  }
  
  // Incrémenter le compteur de cartes vues
  Future<void> incrementCardsViewed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    // Incrémenter cardsViewed (session)
    int currentCards = prefs.getInt(cardsViewedKey) ?? 0;
    await prefs.setInt(cardsViewedKey, currentCards + 1);
    
    // Incrémenter totalProgress (tout le temps)
    int currentTotal = prefs.getInt(totalProgressKey) ?? 0;
    await prefs.setInt(totalProgressKey, currentTotal + 1);
    
    print('📊 Progression: ${currentCards + 1}');
  }
  
  // Récupérer la progression totale (depuis le début)
  Future<int> getTotalProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? totalProgress = prefs.getInt(totalProgressKey);
    return totalProgress ?? 0;  // Retourner 0 si null
  }
  
  // Réinitialiser le compteur de session
  Future<void> resetSessionProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(cardsViewedKey, 0);
    print('🔄 Session réinitialisée');
  }
}

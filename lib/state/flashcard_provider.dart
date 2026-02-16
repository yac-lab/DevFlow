import 'dart:math';
import 'package:flutter/material.dart';
import '../models/flashcard.dart';
import '../services/api_service.dart';
import '../services/prefs_service.dart';

class FlashcardProvider extends ChangeNotifier {
  FlashcardProvider({required this.apiService, required this.prefsService});
  final ApiService apiService;
  final PrefsService prefsService;
  List<Flashcard> cards = [];
  List<String> favoriteIds = [];
  int currentIndex = 0, cardsViewed = 0, totalProgress = 0;
  bool isLoading = false;
  String? errorMessage;

  Flashcard? get currentCard => cards.isEmpty ? null : cards[currentIndex];
  List<Flashcard> get favoriteCards =>
      cards.where((c) => favoriteIds.contains(c.id)).toList();
  double get progress => cards.isEmpty ? 0 : (currentIndex + 1) / cards.length;
  bool isFavorite(String id) => favoriteIds.contains(id);

  Future<void> init() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      favoriteIds = await prefsService.getFavoriteIds();
      cardsViewed = await prefsService.getCardsViewed();
      totalProgress = await prefsService.getTotalProgress();
      cards = await apiService.fetchFlashcards()
        ..shuffle(Random());
      currentIndex = 0;
    } catch (e) {
      errorMessage = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  void nextCard() {
    if (cards.isEmpty) return;
    final isLast = currentIndex >= cards.length - 1;
    currentIndex = isLast ? 0 : currentIndex + 1;
    if (isLast) cards.shuffle(Random());
    _updateProgress();
    notifyListeners();
  }

  void previousCard() {
    if (cards.isEmpty) return;
    currentIndex = currentIndex <= 0 ? cards.length - 1 : currentIndex - 1;
    notifyListeners();
  }

  Future<void> _updateProgress() async {
    await prefsService.incrementCardsViewed();
    cardsViewed = await prefsService.getCardsViewed();
    totalProgress = await prefsService.getTotalProgress();
    notifyListeners();
  }

  Future<void> toggleFavorite(String id) async {
    favoriteIds.contains(id) ? favoriteIds.remove(id) : favoriteIds.add(id);
    await prefsService.saveFavoriteIds(favoriteIds);
    notifyListeners();
  }

  Future<void> removeFavorite(String id) async {
    favoriteIds.remove(id);
    await prefsService.saveFavoriteIds(favoriteIds);
    notifyListeners();
  }

  Future<void> retry() => init();
}

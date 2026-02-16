import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'models/flashcard.dart';
import 'services/api_service.dart';
import 'services/prefs_service.dart';

// ============================================================
// ================== MAIN =====================================
// ============================================================

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DevFlowApp());
}

// ============================================================
// ================== APP ======================================
// ============================================================

class DevFlowApp extends StatelessWidget {
  const DevFlowApp({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (_) => FlashcardProvider(
      apiService: ApiService(),
      prefsService: PrefsService(),
    )..init(),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: false,
        textTheme: GoogleFonts.nunitoTextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green.shade400,
          centerTitle: true,
          elevation: 0,
        ),
      ),
      home: const SplashScreen(),
    ),
  );
}

// ============================================================
// ================== PROVIDER (État) ==========================
// ============================================================

class FlashcardProvider extends ChangeNotifier {
  // Services
  ApiService apiService;
  PrefsService prefsService;
  
  // Données des cartes
  List<Flashcard> cards = [];
  List<String> favoriteIds = [];
  int currentIndex = 0;
  bool isLoading = false;
  String? errorMessage;
  int cardsViewed = 0;
  int totalProgress = 0;
  
  // Constructeur
  FlashcardProvider({required this.apiService, required this.prefsService});
  
  // Propriétés calculées
  Flashcard? get currentCard {
    if (cards.isEmpty) return null;
    return cards[currentIndex];
  }
  
  List<Flashcard> get favoriteCards {
    return cards.where((c) => favoriteIds.contains(c.id)).toList();
  }
  
  double get progress {
    if (cards.isEmpty) return 0;
    return (currentIndex + 1) / cards.length;
  }
  
  bool isFavorite(String id) {
    return favoriteIds.contains(id);
  }
  
  // --- INITIALISATION ---
  
  Future<void> init() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    
    try {
      // Charger les favoris sauvegardés
      favoriteIds = await prefsService.getFavoriteIds();
      
      // Charger les statistiques
      cardsViewed = await prefsService.getCardsViewed();
      totalProgress = await prefsService.getTotalProgress();
      
      // Charger les flashcards depuis l'API ou le cache
      cards = await apiService.fetchFlashcards();
      
      // Mélanger les cartes aléatoirement
      cards.shuffle(Random());
      currentIndex = 0;
      
      print('✅ Initialisation terminée');
    } catch (e) {
      errorMessage = e.toString();
      print('❌ Erreur initialisation: $e');
    }
    
    isLoading = false;
    notifyListeners();
  }
  
  // --- NAVIGATION ---
  
  void nextCard() {
    if (cards.isEmpty) {
      print('❌ Aucune carte disponible');
      return;
    }
    
    // Vérifier si on est à la dernière carte
    bool isLastCard = currentIndex >= cards.length - 1;
    
    if (isLastCard) {
      currentIndex = 0;  // Retourner au début
      cards.shuffle(Random());  // Mélanger à nouveau
    } else {
      currentIndex = currentIndex + 1;
    }
    
    // Incrémenter la progression
    _updateProgress();
    
    notifyListeners();
  }
  
  // Mettre à jour la progression
  void _updateProgress() async {
    await prefsService.incrementCardsViewed();
    cardsViewed = await prefsService.getCardsViewed();
    totalProgress = await prefsService.getTotalProgress();
    notifyListeners();
  }
  
  // --- FAVORIS ---
  
  Future<void> toggleFavorite(String id) async {
    if (favoriteIds.contains(id)) {
      favoriteIds.remove(id);
      print('❤️ Favori supprimé: $id');
    } else {
      favoriteIds.add(id);
      print('❤️ Ajouté aux favoris: $id');
    }
    
    await prefsService.saveFavoriteIds(favoriteIds);
    notifyListeners();
  }
  
  Future<void> removeFavorite(String id) async {
    favoriteIds.remove(id);
    await prefsService.saveFavoriteIds(favoriteIds);
    print('🗑️ Favori supprimé: $id');
    notifyListeners();
  }
  
  // --- AUTRES ---
  
  Future<void> retry() {
    return init();
  }
}

// ============================================================
// ================== WIDGETS ==================================
// ============================================================

class DevFlowLogo extends StatelessWidget {
  const DevFlowLogo({
    super.key,
    this.size = 36,
    this.showName = true,
    this.textColor = Colors.white,
  });
  
  final double size;
  final bool showName;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final nameSize = size * .58;
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF00C853), Color(0xFF00B0FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(size * .32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .16),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Text(
          'DF',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: size * .34,
            letterSpacing: .4,
          ),
        ),
      ),
      if (showName) ...[
        SizedBox(width: size * .24),
        Text(
          'DevFlow',
          style: GoogleFonts.poppins(
            color: textColor,
            fontSize: nameSize,
            fontWeight: FontWeight.w700,
            letterSpacing: .4,
          ),
        ),
      ]
    ]);
  }
}

class FlashcardView extends StatelessWidget {
  const FlashcardView({super.key, required this.card});
  final Flashcard card;

  // Images locales dans assets/images/
  static const _categoryLogos = {
    'flutter': 'assets/images/flutter.png',
    'dart': 'assets/images/dart.png',
    'android': 'assets/images/android.png',
    'firebase': 'assets/images/firebase.png',
    'api': 'assets/images/api.png',
    'git': 'assets/images/git.png',
    'github': 'assets/images/github.png',
  };

  String? get _logoPath => _categoryLogos[card.category.toLowerCase().trim()];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              card.category.toUpperCase(),
              style: GoogleFonts.nunito(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade800,
              ),
            ),
          ),
          const SizedBox(height: 30),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _logoPath != null
                ? Image.asset(
                    _logoPath!,
                    height: 64,
                    width: 64,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.image_not_supported,
                      size: 40,
                      color: Colors.grey.shade400,
                    ),
                  )
                : Icon(
                    Icons.category,
                    size: 40,
                    color: Colors.grey.shade400,
                  ),
          ),
          const SizedBox(height: 20),
          Text(
            card.question,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 30),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.touch_app, size: 16, color: Colors.grey.shade400),
            const SizedBox(width: 8),
            Text(
              'Appuyez pour voir la reponse',
              style: GoogleFonts.nunito(
                fontSize: 13,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
          ]),
        ]),
      ),
    );
  }
}

class ErrorRetryWidget extends StatelessWidget {
  const ErrorRetryWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });
  
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.wifi_off, size: 64, color: Colors.red.shade200),
      const SizedBox(height: 16),
      Text(message, textAlign: TextAlign.center),
      ElevatedButton(onPressed: onRetry, child: const Text('Reessayer')),
    ]),
  );
}

// ============================================================
// ================== SCREENS (Pages) =========================
// ============================================================

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.green.shade400,
    body: const Center(
      child: DevFlowLogo(size: 86, showName: true, textColor: Colors.white),
    ),
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  
  void _open(BuildContext c, Widget page) =>
      Navigator.of(c).push(MaterialPageRoute(builder: (_) => page));

  @override
  Widget build(BuildContext context) => Consumer<FlashcardProvider>(
    builder: (context, p, _) => Scaffold(
      appBar: AppBar(
        title: const DevFlowLogo(size: 30, showName: true, textColor: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () => _open(context, const LibraryScreen()),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _open(context, const AboutScreen()),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, cs) => SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: cs.maxHeight),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: _content(context, p),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  Widget _content(BuildContext c, FlashcardProvider p) {
    if (p.isLoading) return const Center(child: CircularProgressIndicator());
    if (p.errorMessage != null) {
      return ErrorRetryWidget(message: p.errorMessage!, onRetry: p.retry);
    }
    final card = p.currentCard;
    if (card == null) return const Center(child: Text('Aucune carte.'));
    
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(
        'Progression',
        style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: LinearProgressIndicator(
          value: p.progress,
          minHeight: 10,
          backgroundColor: Colors.grey.shade300,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade400),
        ),
      ),
      const SizedBox(height: 6),
      Text(
        '${p.currentIndex + 1} / ${p.cards.length} cartes',
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      const SizedBox(height: 30),
      GestureDetector(
        onTap: () => _open(c, DetailScreen(card: card)),
        child: FlashcardView(card: card),
      ),
      const SizedBox(height: 40),
      Row(children: [
        GestureDetector(
          onTap: () => p.toggleFavorite(card.id),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: p.isFavorite(card.id)
                  ? Colors.pink.shade50
                  : Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: Icon(
              p.isFavorite(card.id) ? Icons.favorite : Icons.favorite_border,
              color: p.isFavorite(card.id) ? Colors.pink : Colors.grey.shade600,
              size: 28,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: p.nextCard,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade400,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
            ),
            child: Text(
              'CARTE SUIVANTE',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ]),
    ]);
  }
}

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  Future<bool> _confirm(BuildContext c) async {
    final r = await showDialog<bool>(
      context: c,
      builder: (context) => AlertDialog(
        title: const Text('Retirer des favoris'),
        content: const Text('Voulez-vous effacer cet element ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Effacer'),
          ),
        ],
      ),
    );
    return r ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final p = Provider.of<FlashcardProvider>(context);
    final favs = p.favoriteCards;
    
    return Scaffold(
      appBar: AppBar(title: const Text('Mes Favoris')),
      body: favs.isEmpty
          ? const Center(child: Text('Aucun favori pour le moment'))
          : ListView.builder(
              itemCount: favs.length,
              itemBuilder: (context, i) {
                final card = favs[i];
                return Dismissible(
                  key: ValueKey(card.id),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (_) => _confirm(context),
                  onDismissed: (_) => p.removeFavorite(card.id),
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.red.shade400,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ListTile(
                    title: Text(card.question),
                    subtitle: Text(card.category),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () async {
                        if (await _confirm(context)) {
                          p.removeFavorite(card.id);
                        }
                      },
                    ),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => DetailScreen(card: card),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.card});
  final Flashcard card;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Reponse')),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          card.category,
          style: TextStyle(
            color: Colors.green.shade700,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          card.question,
          style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const Divider(height: 40),
        _section('LA REPONSE', card.answer, Colors.blue.shade50),
        const SizedBox(height: 20),
        _section('EXPLICATION', card.explanation, Colors.grey.shade100),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => launchUrl(
              Uri.parse(card.docUrl),
              mode: LaunchMode.externalApplication,
            ),
            icon: const Icon(Icons.open_in_new),
            label: const Text('Voir la documentation officielle'),
          ),
        ),
      ]),
    ),
  );

  Widget _section(String title, String content, Color bg) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
      const SizedBox(height: 8),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(content, style: const TextStyle(fontSize: 16, height: 1.5)),
      ),
    ],
  );
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('A propos')),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const DevFlowLogo(size: 74, showName: true, textColor: Colors.black87),
          const SizedBox(height: 20),
          Text(
            'DevFlow v1.0',
            style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          const Text(
            'Projet realise par : CALVERT Wanguy, CESAR Yves Angello, JOSEPH Scarline',
            textAlign: TextAlign.center,
          ),
        ]),
      ),
    ),
  );
}

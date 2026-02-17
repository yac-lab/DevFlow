import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'models/flashcard.dart';
import 'services/api_service.dart';
import 'services/prefs_service.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DevFlowApp());
}



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



class FlashcardProvider extends ChangeNotifier {
  
  ApiService apiService;
  PrefsService prefsService;
  
  
  List<Flashcard> cards = [];
  List<String> favoriteIds = [];
  int currentIndex = 0;
  bool isLoading = false;
  String? errorMessage;
  int cardsViewed = 0;
  int totalProgress = 0;
  
  
  FlashcardProvider({required this.apiService, required this.prefsService});
  
  
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
  
  
  
  Future<void> init() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    
    try {
      
      favoriteIds = await prefsService.getFavoriteIds();
      
      
      cardsViewed = await prefsService.getCardsViewed();
      totalProgress = await prefsService.getTotalProgress();
      
      
      cards = await apiService.fetchFlashcards();
      
      
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
  
  
  
  void nextCard() {
    if (cards.isEmpty) {
      print('❌ Aucune carte disponible');
      return;
    }
    
    
    bool isLastCard = currentIndex >= cards.length - 1;
    
    if (isLastCard) {
      currentIndex = 0; 
      cards.shuffle(Random());  
    } else {
      currentIndex = currentIndex + 1;
    }
    
    
    _updateProgress();
    
    notifyListeners();
  }

  void previousCard() {
    if (cards.isEmpty) return;
    currentIndex = currentIndex <= 0 ? cards.length - 1 : currentIndex - 1;
    notifyListeners();
  }
  
  
  void _updateProgress() async {
    await prefsService.incrementCardsViewed();
    cardsViewed = await prefsService.getCardsViewed();
    totalProgress = await prefsService.getTotalProgress();
    notifyListeners();
  }
  
  
  
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

  static const _defaultLogo = 'assets/images/devflow_icon.png';

  String get _logoPath =>
      _categoryLogos[card.category.toLowerCase().trim()] ?? _defaultLogo;

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
            child: card.logoUrl.trim().isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: card.logoUrl,
                    height: 64,
                    width: 64,
                    fit: BoxFit.contain,
                    errorWidget: (_, __, ___) => Image.asset(
                      _logoPath,
                      height: 64,
                      width: 64,
                      fit: BoxFit.contain,
                    ),
                  )
                : Image.asset(
                    _logoPath,
                    height: 64,
                    width: 64,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => Icon(
                      Icons.image_not_supported,
                      size: 40,
                      color: Colors.grey.shade400,
                    ),
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
          onTap: p.previousCard,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_back_rounded,
              color: Colors.grey.shade700,
              size: 28,
            ),
          ),
        ),
        const SizedBox(width: 12),
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

  Widget _member(String name) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    decoration: BoxDecoration(
      color: const Color(0xFFFAFBFC),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: Text(
      name,
      style: GoogleFonts.nunito(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: Colors.grey.shade800,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('A propos')),
    backgroundColor: const Color(0xFFF6F7F9),
    body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .05),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: DevFlowLogo(
                    size: 56,
                    showName: true,
                    textColor: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    'DevFlow v1.0',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.shade900,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Application de revision interactive pour apprendre Flutter, Dart et les bases du developpement mobile.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    height: 1.35,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 12),
                Divider(color: Colors.grey.shade200, height: 1),
                const SizedBox(height: 10),
                Text(
                  'Equipe projet',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade900,
                  ),
                ),
                const SizedBox(height: 8),
                ...['CALVERT Wanguy', 'CESAR Yves Angello', 'JOSEPH Scarline']
                    .map(
                      (n) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: _member(n),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

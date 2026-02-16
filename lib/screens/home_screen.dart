import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../state/flashcard_provider.dart';
import '../widgets/devflow_logo.dart';
import '../widgets/error_retry_widget.dart';
import '../widgets/flashcard_view.dart';
import 'about_screen.dart';
import 'detail_screen.dart';
import 'library_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  void _open(BuildContext c, Widget page) =>
      Navigator.of(c).push(MaterialPageRoute(builder: (_) => page));
  Widget _iconButton(VoidCallback onTap, IconData icon, Color bg, Color fg) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
          child: Icon(icon, color: fg, size: 28),
        ),
      );

  @override
  Widget build(BuildContext context) => Consumer<FlashcardProvider>(
    builder: (context, p, _) => Scaffold(
      appBar: AppBar(
        title: const DevFlowLogo(
          size: 30,
          showName: true,
          textColor: Colors.white,
        ),
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
    if (p.errorMessage != null)
      return ErrorRetryWidget(message: p.errorMessage!, onRetry: p.retry);
    final card = p.currentCard;
    if (card == null) return const Center(child: Text('Aucune carte.'));
    final fav = p.isFavorite(card.id);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
        Row(
          children: [
            _iconButton(
              p.previousCard,
              Icons.arrow_back_rounded,
              Colors.grey.shade200,
              Colors.grey.shade700,
            ),
            const SizedBox(width: 12),
            _iconButton(
              () => p.toggleFavorite(card.id),
              fav ? Icons.favorite : Icons.favorite_border,
              fav ? Colors.pink.shade50 : Colors.grey.shade200,
              fav ? Colors.pink : Colors.grey.shade600,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: p.nextCard,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade400,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
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
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/flashcard_provider.dart';
import 'detail_screen.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  Future<bool> _confirm(BuildContext c) async =>
      (await showDialog<bool>(
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
      )) ??
      false;

  @override
  Widget build(BuildContext context) {
    final p = Provider.of<FlashcardProvider>(context), favs = p.favoriteCards;
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
                        if (await _confirm(context)) p.removeFavorite(card.id);
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

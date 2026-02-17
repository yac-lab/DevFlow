import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/flashcard.dart';

class FlashcardView extends StatelessWidget {
  const FlashcardView({super.key, required this.card});
  final Flashcard card;
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
  Widget build(BuildContext context) => Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
                    errorBuilder: (_, __, ___) => Icon(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
            ],
          ),
        ],
      ),
    ),
  );
}

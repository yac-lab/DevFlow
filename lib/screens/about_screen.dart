import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/devflow_logo.dart';

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
                ...[
                  'CALVERT Wanguy',
                  'CESAR Yves Angello',
                  'JOSEPH Scarline',
                ].map(
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

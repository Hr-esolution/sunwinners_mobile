// views/pages/terms_of_use_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sunwinners/widgets/sunwinners_app_bar.dart';

class TermsOfUseView extends StatelessWidget {
  const TermsOfUseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0f1419),
      appBar: SunwinnersAppBar(
        title: 'Conditions d\'Utilisation',
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        iconColor: const Color(0xFFffd60a),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: const Color(0xFFffd60a)),
          onPressed: () => Get.back(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1a1f2e), Color(0xFF0f1419), Color(0xFF051628)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFffd60a).withOpacity(0.1),
                ),
                child: Icon(
                  Icons.description_rounded,
                  size: 40,
                  color: const Color(0xFFffd60a).withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Conditions d\'Utilisation',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'En utilisant notre application, vous acceptez nos conditions générales, incluant la responsabilité limitée, les droits de propriété intellectuelle et les modalités de service.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

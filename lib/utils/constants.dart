 // lib/utils/constants.dart
import 'package:flutter/material.dart';

class AppColors {
  // Couleurs principales optimisées pour mobile
  static const Color primary = Color(0xFF0B0E11);      
  static const Color secondary = Color(0xFF1E2329);     
  static const Color accent = Color(0xFFF0B90B);        
  static const Color surface = Color(0xFF2B3139);       
  static const Color background = Color(0xFF181A20);    // Fond plus doux pour mobile
  static const Color cardBackground = Color(0xFF1E2329); 
  
  // Couleurs de texte avec meilleur contraste
  static const Color textPrimary = Color(0xFFFFFFFF);   
  static const Color textSecondary = Color(0xFFB7BDC6); 
  static const Color textAccent = Color(0xFFF0B90B);    
  
  // Couleurs d'état plus visibles sur mobile
  static const Color success = Color(0xFF00D4AA);       
  static const Color error = Color(0xFFFF4747);         
  static const Color warning = Color(0xFFFFA726);       
  
  // Couleurs sur fond
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onAccent = Color(0xFF000000);      
  static const Color onSurface = Color(0xFFFFFFFF);
  static const Color onBackground = Color(0xFFFFFFFF);
  
  // Couleurs de border
  static const Color border = Color(0xFF2B3139);
  static const Color borderLight = Color(0xFF474D57);
}

class AppTextStyles {
  // Tailles de texte optimisées pour mobile
  static const TextStyle heading1 = TextStyle(
    fontSize: 30,  // Plus gros pour mobile
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle heading2 = TextStyle(
    fontSize: 26,  // Plus gros pour mobile
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle heading3 = TextStyle(
    fontSize: 22,  // Plus gros pour mobile
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 18,  // Plus gros pour mobile
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 16,  // Plus gros pour mobile
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,  // Plus gros pour mobile
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );
  
  static const TextStyle price = TextStyle(
    fontSize: 20,  // Plus visible
    fontWeight: FontWeight.w700,
    color: AppColors.accent,
  );
  
  static const TextStyle priceSmall = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.accent,
  );
  
  static const TextStyle button = TextStyle(
    fontSize: 17,  // Plus gros pour mobile
    fontWeight: FontWeight.w600,
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );
  
  static const TextStyle label = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );
}

class AppSpacing {
  // Espacements plus grands pour mobile
  static const double xs = 6.0;   
  static const double sm = 12.0;  
  static const double md = 18.0;  
  static const double lg = 26.0;  
  static const double xl = 34.0;  
  static const double xxl = 42.0; 
}

class AppRadius {
  static const double sm = 6.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 28.0;
}
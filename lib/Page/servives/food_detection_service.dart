import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';

class FoodDetectionService {
  late ImageLabeler _imageLabeler;

  // Base de données simulée de calories (pour 100g ou par portion)
  final Map<String, int> _calorieDatabase = {
    'apple': 52,
    'banana': 89,
    'orange': 47,
    'broccoli': 34,
    'carrot': 41,
    'tomato': 18,
    'bread': 265,
    'chicken': 239,
    'beef': 250,
    'egg': 155,
    'pizza': 266,
    'burger': 295,
    'strawberry': 33,
    'grape': 67,
    'pineapple': 50,
    'watermelon': 30,
    'cucumber': 15,
    'potato': 77,
    'rice': 130,
    'pasta': 131,
    'fruit': 50, // Generic fallback
    'vegetable': 40, // Generic fallback
    'food': 100, // Generic fallback
  };

  FoodDetectionService() {
    _initializeLabeler();
  }

  void _initializeLabeler() {
    // Utilisation du modèle "Base" de ML Kit (on-device)
    final options = ImageLabelerOptions(confidenceThreshold: 0.4);
    _imageLabeler = ImageLabeler(options: options);
  }

  Future<List<Map<String, dynamic>>> detectFood(InputImage inputImage) async {
    try {
      final List<ImageLabel> labels = await _imageLabeler.processImage(inputImage);
      List<Map<String, dynamic>> results = [];

      for (ImageLabel label in labels) {
        final text = label.label.toLowerCase();
        final confidence = label.confidence;

        // On vérifie les correspondances exactes ou partielles
        bool found = false;
        _calorieDatabase.forEach((key, calories) {
          if (text.contains(key) || key.contains(text)) {
            results.add({
              'name': label.label,
              'confidence': confidence,
              'calories': calories,
            });
            found = true;
          }
        });

        // Si pas de calorie trouvée mais détection solide, on l'affiche quand même
        if (!found && confidence > 0.6) {
          results.add({
            'name': label.label,
            'confidence': confidence,
            'calories': 'Unknown',
          });
        }
      }

      // Supprimer les doublons (si "Apple" matche plusieurs fois)
      final seen = <String>{};
      results.retainWhere((x) => seen.add(x['name']));

      // Trier par confiance
      results.sort((a, b) => b['confidence'].compareTo(a['confidence']));
      
      return results;
    } catch (e) {
      print("Erreur ML Kit Image Labeling: $e");
      return [];
    }
  }

  void dispose() {
    _imageLabeler.close();
  }
}

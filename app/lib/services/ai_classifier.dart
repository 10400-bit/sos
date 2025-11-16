class AIClassifier {
  // Keyword-based offline classification
  static const Map<String, List<String>> _keywords = {
    'accident': [
      'crash', 'hit', 'bike', 'car', 'vehicle', 'collision', 'accident',
      'bleeding', 'road', 'fall', 'injured', 'wound', 'broken', 'collide'
    ],
    'fire': [
      'fire', 'burn', 'smoke', 'flame', 'blaze', 'burning', 'smoking',
      'ignite', 'explosion', 'explode'
    ],
    'criminal': [
      'knife', 'attack', 'hitting', 'robbery', 'theft', 'steal', 'rob',
      'assault', 'threat', 'danger', 'weapon', 'gun', 'violence', 'criminal'
    ],
    'medical': [
      'pain', 'breathing', 'heart', 'unconscious', 'faint', 'chest',
      'difficulty', 'sick', 'ill', 'hospital', 'ambulance', 'medical',
      'emergency', 'help', 'dying', 'critical'
    ],
    'disaster': [
      'flood', 'earthquake', 'storm', 'tsunami', 'cyclone', 'hurricane',
      'landslide', 'avalanche', 'disaster', 'natural'
    ],
  };

  static String classify(String description) {
    if (description.isEmpty) return 'accident';

    String lowerDesc = description.toLowerCase();
    Map<String, int> scores = {};

    // Count keyword matches
    for (String category in _keywords.keys) {
      scores[category] = 0;
      for (String keyword in _keywords[category]!) {
        if (lowerDesc.contains(keyword)) {
          scores[category] = scores[category]! + 1;
        }
      }
    }

    // Find category with highest score
    String bestCategory = 'accident';
    int maxScore = 0;

    scores.forEach((category, score) {
      if (score > maxScore) {
        maxScore = score;
        bestCategory = category;
      }
    });

    // If no matches, default to accident
    return maxScore > 0 ? bestCategory : 'accident';
  }
}


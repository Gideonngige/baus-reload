List<String> kCategorys(String type) => type == 'disposal'
    ? [
        'cardboard',
        'construction',
        'e-waste',
        'food waste',
        'furniture',
        'metal',
        'glass',
        'plastic',
        // 'traditional waste',
        'paper',
      ]
    : [
        'pet',
        'hdpe',
      ];


class AutoCompletePredication {
  final String? description;
  final StructuredFormatting? structuredformatting;
  final String? placeId;
  final String? reference;
  AutoCompletePredication({
    this.description,
    this.structuredformatting,
    this.placeId,
    this.reference,
  });

  factory AutoCompletePredication.fromJson(Map<String, dynamic> json) {
    return AutoCompletePredication(
      description: json['description'] as String?,
      structuredformatting: json['structured_formatting'] != null
          ? StructuredFormatting.fromJson(json['structured_formatting'])
          : null,
      placeId: json['place_id'] as String?,
      reference: json['reference'] as String?,
    );
  }
}

class StructuredFormatting {
  final String? mainText;
  final String? secondaryText;

  StructuredFormatting({
    this.mainText,
    this.secondaryText,
  });

  factory StructuredFormatting.fromJson(Map<String, dynamic> json) {
    return StructuredFormatting(
      mainText: json['main_text'] as String?,
      secondaryText: json['secondary_text'] as String?,
    );
  }
}

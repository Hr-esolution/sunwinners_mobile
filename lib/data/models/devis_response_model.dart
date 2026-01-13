class DevisResponseModel {
  final int? id;
  final int? devisId;
  final int? technicianId;
  final String? commentaire;
  final double? prixTotal;
  final String? statut;
  final List<DevisResponseComponent>? composants;
  final List<DevisResponseComponent>? components; // For backward compatibility

  DevisResponseModel({
    this.id,
    this.devisId,
    this.technicianId,
    this.commentaire,
    this.prixTotal,
    this.statut,
    this.composants,
    this.components, // For backward compatibility
  });

  factory DevisResponseModel.fromJson(Map<String, dynamic> json) {
    List<DevisResponseComponent>? parseComponents(dynamic value) {
      if (value == null) return null;

      // Handle components from a List
      if (value is List) {
        return value.map((e) => DevisResponseComponent.fromJson(e)).toList();
      }

      // Handle components from composants array with pivot data (from API response)
      if (value is Map<String, dynamic>) {
        // Check if it has composants array (from API response)
        if (value.containsKey('composants')) {
          var composants = value['composants'] as List?;
          if (composants != null) {
            return composants
                .map((comp) => DevisResponseComponent.fromApiResponse(comp))
                .toList();
          }
        }
        // Check if it's the composants array itself
        else if (value.containsKey('id') && value.containsKey('pivot')) {
          // This is a single component from composants array
          return [DevisResponseComponent.fromApiResponse(value)];
        }
      }

      return null;
    }

    // Extract components from the main json object - handle both composants and components
    List<DevisResponseComponent>? composantsFromJson;
    List<DevisResponseComponent>? componentsFromJson;

    // Try to get composants first (new structure)
    if (json.containsKey('composants')) {
      composantsFromJson = parseComponents({'composants': json['composants']});
    }

    // Try to get components (old structure) as fallback
    if (json.containsKey('components')) {
      componentsFromJson = parseComponents(json['components']);
    } else if (json.containsKey('composants')) {
      // If we have composants but no components, use composants for both for backward compatibility
      componentsFromJson = parseComponents({'composants': json['composants']});
    }

    double? parseDoubleValue(dynamic value) {
      if (value == null) return null;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) {
        // Handle string numbers like "150.00"
        return double.tryParse(value);
      }
      // Handle cases where the value might be a numeric type stored as dynamic
      if (value is num) return value.toDouble();
      return null;
    }

    return DevisResponseModel(
      id: json['id'],
      devisId: json['devis_id'] ?? json['devisId'],
      technicianId: json['technician_id'] ?? json['technicianId'],
      commentaire: json['commentaire'] ?? json['comment'],
      prixTotal: parseDoubleValue(json['prix_total'] ?? json['prixTotal']),
      statut: json['statut'] ?? json['status'],
      composants: composantsFromJson,
      components: componentsFromJson,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'devis_id': devisId,
      'technician_id': technicianId,
      'commentaire': commentaire,
      'prix_total': prixTotal,
      'statut': statut,
      'composants': composants?.map((c) => c.toJson()).toList(),
      'components': components
          ?.map((c) => c.toJson())
          .toList(), // For backward compatibility
    };
  }
}

class DevisResponseComponent {
  final int composantId;
  final String? composantName;
  final int quantity;
  final double unitPrice;
  final double totalPrice;

  DevisResponseComponent({
    required this.composantId,
    this.composantName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory DevisResponseComponent.fromJson(Map<String, dynamic> json) {
    double parseDoubleValue(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) {
        // Handle string numbers like "150.00"
        return double.tryParse(value) ?? 0.0;
      }
      // Handle cases where the value might be a numeric type stored as dynamic
      if (value is num) return value.toDouble();
      return 0.0;
    }

    return DevisResponseComponent(
      composantId: json['composant_id'] ?? json['id'] ?? 0,
      composantName: json['name'] ?? json['composantName'],
      quantity: json['quantity'] ?? json['pivot']?['quantity'] ?? 0,
      unitPrice: parseDoubleValue(
        json['unit_price'] ?? json['unitPrice'] ?? 0.0,
      ),
      totalPrice: parseDoubleValue(
        json['total_price'] ?? json['totalPrice'] ?? 0.0,
      ),
    );
  }

  factory DevisResponseComponent.fromApiResponse(Map<String, dynamic> json) {
    // Handle the API response structure where components come from composants array with pivot data
    var pivot = json['pivot'] as Map<String, dynamic>? ?? {};
    double parseDoubleValue(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) {
        // Handle string numbers like "150.00"
        return double.tryParse(value) ?? 0.0;
      }
      // Handle cases where the value might be a numeric type stored as dynamic
      if (value is num) return value.toDouble();
      return 0.0;
    }

    var unitPrice = parseDoubleValue(
      json['unit_price'] ?? json['unitPrice'] ?? 0.0,
    );
    var quantity = (pivot['quantity'] ?? 1).toInt();
    var totalPrice = unitPrice * quantity;

    return DevisResponseComponent(
      composantId: json['id'] ?? 0,
      composantName: json['name'] ?? json['composantName'],
      quantity: quantity,
      unitPrice: unitPrice,
      totalPrice: totalPrice,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'composant_id': composantId,
      'composantName': composantName,
      'quantity': quantity,
      'unit_price': unitPrice,
      'total_price': totalPrice,
    };
  }
}

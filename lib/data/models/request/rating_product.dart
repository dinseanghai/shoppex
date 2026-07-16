class RatingProduct {
  final String status;
  final int statusCode;
  final String message;
  final int? myRating;
  final int ratingsCount;
  final double ratingsAvg; // Parsed as double for UI consistency (e.g., 4.0)

  RatingProduct({
    required this.status,
    required this.statusCode,
    required this.message,
    this.myRating,
    required this.ratingsCount,
    required this.ratingsAvg,
  });

  /// Factory constructor to parse the JSON response safely
  factory RatingProduct.fromJson(Map<String, dynamic> json) {
    return RatingProduct(
      status: json['status'] ?? '',
      statusCode: json['status_code'] ?? 0,
      message: json['message'] ?? '',
      myRating: json['my_rating'],
      ratingsCount: json['ratings_count'] ?? 0,
      // Safely parse int or double from API to double
      ratingsAvg: (json['ratings_avg'] is num)
          ? (json['ratings_avg'] as num).toDouble()
          : double.tryParse(json['ratings_avg']?.toString() ?? '0.0') ?? 0.0,
    );
  }

  /// Convert model instance back to a Map JSON structure if needed
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'status_code': statusCode,
      'message': message,
      'my_rating': myRating,
      'ratings_count': ratingsCount,
      'ratings_avg': ratingsAvg,
    };
  }

  /// copyWith helper to easily update states in your GetX controller
  RatingProduct copyWith({
    String? status,
    int? statusCode,
    String? message,
    int? myRating,
    int? ratingsCount,
    double? ratingsAvg,
  }) {
    return RatingProduct(
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      message: message ?? this.message,
      myRating: myRating ?? this.myRating,
      ratingsCount: ratingsCount ?? this.ratingsCount,
      ratingsAvg: ratingsAvg ?? this.ratingsAvg,
    );
  }
}
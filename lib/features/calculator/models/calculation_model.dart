class CalculationModel {
  final String expression;
  final double result;
  final DateTime timestamp;

  CalculationModel({
    required this.expression,
    required this.result,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'expression': expression,
    'result': result,
    'timestamp': timestamp.toIso8601String(),
  };

  factory CalculationModel.fromJson(Map<String, dynamic> json) => CalculationModel(
    expression: json['expression'],
    result: json['result'],
    timestamp: DateTime.parse(json['timestamp']),
  );
}
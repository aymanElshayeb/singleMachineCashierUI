class Discount {
  final String taxCategory;
  final String taxExeptionReason;
  final String taxExeptionReasonCode;
  final double taxPercentage;
  final double grossAmount;
  double get taxAmount => grossAmount * taxPercentage / 100;
  double get netAmount => grossAmount - taxAmount;
  Discount({
    this.taxCategory = "Standard",
    this.taxExeptionReason = "",
    this.taxExeptionReasonCode = "",
    this.taxPercentage = 15.0,
    required this.grossAmount,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'taxCategory': taxCategory,
      'taxExeptionReason': taxExeptionReason,
      'taxExeptionReasonCode': taxExeptionReasonCode,
      'netAmount': netAmount,
      'taxAmount': taxAmount,
      'grossAmount': grossAmount,
    };
  }
}

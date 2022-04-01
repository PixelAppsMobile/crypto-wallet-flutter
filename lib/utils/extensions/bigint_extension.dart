import 'dart:math';

extension BigIntExtension on BigInt {
  double toDecimal() {
    double d = (toDouble() / pow(10, 18));
    String inString = d.toStringAsFixed(4);
    return double.parse(inString);
  }
}

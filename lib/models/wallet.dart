import 'package:my_crypto_wallet/models/token.dart';

class Wallet {
  final String publicAddress;
  final List<Token> tokens;
  final Map<String, double> tokenBalances;

  Wallet({
    required this.publicAddress,
    required this.tokens,
    required this.tokenBalances,
  });
}

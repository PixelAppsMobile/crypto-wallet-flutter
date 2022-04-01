import 'package:flutter/material.dart';
import 'package:my_crypto_wallet/screens/wallet_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'My Crypto Wallet',
      home: MyCryptoWallet(),
    );
  }
}

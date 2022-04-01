import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_crypto_wallet/providers/wallet_provider.dart';
import 'package:my_crypto_wallet/utils/extensions/bigint_extension.dart';

class TokenDetailsSection extends StatelessWidget {
  const TokenDetailsSection({
    Key? key,
    required this.tokenBalance,
    required WalletProvider walletProvider,
  })  : _walletProvider = walletProvider,
        super(key: key);

  final BigInt tokenBalance;
  final WalletProvider _walletProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 1,
          width: double.infinity,
          color: Colors.black12,
        ),
        SizedBox(
          height: 200,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black12)),
                  child: SvgPicture.asset(
                    'assets/svg/treecoin-trc-logo.svg',
                    height: 100,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'TRC ${tokenBalance.toDecimal()}',
                              style: const TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            InkWell(
                              onTap: () => _walletProvider.refreshBalance(),
                              child: Icon(
                                Icons.refresh,
                                color: Colors.grey,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text(
                              'Smart Contract',
                              style: TextStyle(fontSize: 12.0),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            SizedBox(
                              width: 120,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  const Expanded(
                                    child: Text(
                                      contractAddress,
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.grey,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  InkWell(
                                    onTap: () => FlutterClipboard.copy(
                                      contractAddress,
                                    ),
                                    child: const Icon(
                                      Icons.copy,
                                      size: 12,
                                      color: Colors.grey,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Container(
          height: 1,
          width: double.infinity,
          color: Colors.black12,
        ),
      ],
    );
  }
}

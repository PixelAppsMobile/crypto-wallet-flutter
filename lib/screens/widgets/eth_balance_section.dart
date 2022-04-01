import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_crypto_wallet/utils/extensions/bigint_extension.dart';

class ETHBalanceSection extends StatelessWidget {
  const ETHBalanceSection({
    Key? key,
    required this.ethBalance,
  }) : super(key: key);

  final BigInt ethBalance;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(
                'assets/svg/ethereum-eth-logo.svg',
                height: 40,
              ),
              Text(
                'ETH ${ethBalance.toDecimal().toString()}',
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
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

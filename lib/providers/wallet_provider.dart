import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

const String contractAddress = '0x6F6621EA05E7c2C5af925fc9Df015584E220aE2a';

final walletProvider = ChangeNotifierProvider((ref) => WalletProvider());

class WalletProvider extends ChangeNotifier {
  late final Web3Client _web3client;
  late final Credentials _credentials;
  late final DeployedContract _contract;

  // Contract RPC API
  ContractEvent _transferEvent() => _contract.event('Transfer');
  ContractFunction _balanceFunction() => _contract.function('balanceOf');
  ContractFunction _sendFunction() => _contract.function('transfer');

  // TODO: Replace publicAddress with Wallet model in future.
  late final String _publicAddress;
  late final EthereumAddress _ethereumAddress;

  late BigInt _ethBalance;
  late BigInt _tokenBalance;

  bool _loading = false;

  String get publicAddress => _publicAddress;

  bool get loading => _loading;

  BigInt get ethBalance => _ethBalance;

  BigInt get tokenBalance => _tokenBalance;

  Future<void> initialiseWallet() async {
    setBusy(true);

    await _initialiseClient();
    await _initialiseCredentials();
    await _initialiseContract();
    await refreshBalance();

    setBusy(false);
  }

  Future<void> refreshBalance() async {
    setBusy(true);

    await _getEthBalance(_ethereumAddress);
    await _getTokenBalance(_ethereumAddress);

    setBusy(false);
  }

  Future<String> sendToken(String to) async {
    EthereumAddress toAddress = EthereumAddress.fromHex(to);
    BigInt amount = BigInt.from(5 * pow(10, 18));

    String txBlockHash = await _web3client.sendTransaction(
      _credentials,
      Transaction.callContract(
        contract: _contract,
        function: _sendFunction(),
        parameters: [toAddress, amount],
      ),
      chainId: 4,
    );
    return txBlockHash;
  }

  void setBusy(bool val) {
    if (_loading == val) return;
    _loading = val;
    notifyListeners();
  }

  Future<void> _getEthBalance(EthereumAddress from) async {
    EtherAmount etherAmount = await _web3client.getBalance(from);
    _ethBalance = etherAmount.getInWei;
  }

  Future<void> _getTokenBalance(EthereumAddress from) async {
    final response = await _web3client.call(
        contract: _contract, function: _balanceFunction(), params: [from]);
    _tokenBalance = response.first;
  }

  Future<void> _initialiseClient() async {
    // Initialse Web3 client
    _web3client = Web3Client(
      dotenv.env['ALCHEMY_RINKEBY_URL']!,
      http.Client(),
    );
  }

  Future<void> _initialiseCredentials() async {
    // Initialise Credentials
    _credentials = EthPrivateKey.fromHex(dotenv.env['RINKEBY_PRIVATE_KEY']!);
    await _updatePublicAddress();
  }

  Future<void> _initialiseContract() async {
    // Initialise Deployed Contract
    final abiString = await rootBundle.loadString('assets/abi/abi.json');
    final ContractAbi abi = ContractAbi.fromJson(abiString, 'TreeCoin');
    _contract = DeployedContract(abi, EthereumAddress.fromHex(contractAddress));
  }

  Future<void> _updatePublicAddress() async {
    EthereumAddress address = await _credentials.extractAddress();
    _ethereumAddress = address;
    _publicAddress = address.hex;
  }

  @override
  dispose() async {
    await _web3client.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_crypto_wallet/providers/base_view_model.dart';
import 'package:my_crypto_wallet/providers/wallet_provider.dart';

final walletPageViewModel =
    ChangeNotifierProvider((ref) => WalletPageViewModel(ref.read));

mixin WalletPageView {
  showAlertDialog(String message, String url);
}

class WalletPageViewModel extends BaseViewModel<WalletPageView> {
  final Reader _reader;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController toController = TextEditingController();

  final FocusNode toFocusNode = FocusNode();

  WalletPageViewModel(this._reader) {
    FocusManager.instance.addListener(_focusListener);
  }

  Future<void> send() async {
    if (formKey.currentState!.validate()) {
      toFocusNode.unfocus();
      loading = true;

      String txBlockHash =
          await _reader(walletProvider).sendToken(toController.text);
      toController.clear();

      loading = false;

      print(txBlockHash);
      String url = "https://rinkeby.etherscan.io/tx/$txBlockHash";
      String message =
          "Tx block hash: $txBlockHash\nIt might take a while for transaction to complete. You can track the progress on Etherscan.";

      view!.showAlertDialog(message, url);
    }
  }

  String? addressValidator(String? val) {
    if (val!.isEmpty) return "Add receiver's address.";
    return null;
  }

  void _focusListener() {
    notifyListeners();
  }

  @override
  void dispose() {
    toFocusNode.dispose();
    toController.dispose();
    FocusManager.instance.removeListener(_focusListener);
    super.dispose();
  }
}

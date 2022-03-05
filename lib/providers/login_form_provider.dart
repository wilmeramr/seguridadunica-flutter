import 'package:flutter/material.dart';

class LoginFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  String email = '';
  String password = '';

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingToken = false;
  bool get isLoadingToken => _isLoadingToken;

  set isLoadingToken(bool value) {
    _isLoadingToken = value;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}

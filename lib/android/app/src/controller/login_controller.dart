import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:stream_me/android/app/src/model/login_model.dart';


class LoginController extends ControllerMVC {
  factory LoginController() {
    return  LoginController._();
  }

  static LoginController _this = LoginController();
  
  LoginController._();
  
  int get counter => LoginModel.counter;

  void incrementCounter() {
    LoginModel.incrementCounter();
  }

  void decrementCounter() {
    LoginModel.decrementCounter();
  }
}
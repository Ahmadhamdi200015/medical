import 'package:get/get.dart';

validInput(String val, int min, int max, String type) {
  if (type == "username") {
    if (!GetUtils.isUsername(val)) {
      return "not Valid UserName ";
    }
  }

  if (type == "email") {
    if (!GetUtils.isEmail(val)) {
      return "not Valid Email ";
    }
  }

  if (type == "phone") {
    if (!GetUtils.isPhoneNumber(val)) {
      return "not Valid phoneNumber ";
    }

  }

  if (type == "number") {
    if (!GetUtils.isNumericOnly(val)) {
      return "not Valid Numeric ";
    }
  }
  if (val.isEmpty) {
    return "can't be Empty field";
  }
  if (val.length < min) {
    return "Can't be less than $min";
  }
  if (val.length > max) {
    return "Can't be large than $max";
  }
}

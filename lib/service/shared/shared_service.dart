import 'package:shared_preferences/shared_preferences.dart';

class SharedService {
  // Add Data

  Future<bool> setName(String name) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(Keywords.name.name, name);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> setSurname(String surname) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(Keywords.surname.name, surname);
      return true;
    } catch (e) {
      return false;
    }
  }

  //if user login before isLoginned = true if it's not isLoginned = false

  Future<void> setUserLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(Keywords.isLoginned.name, true);
  }

  // Read Data

  Future<String> getName() async {
    final prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString(Keywords.name.name);
    return name ?? "";
  }

  Future<String> getSurname() async {
    final prefs = await SharedPreferences.getInstance();
    String? surName = prefs.getString(Keywords.surname.name);
    return surName ?? "";
  }

  Future<bool?> getLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? result = prefs.getBool(Keywords.isLoginned.name);
    return result;
  }

//Delete Data

  Future<void> deleteUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(Keywords.name.name);
    await prefs.remove(Keywords.surname.name);
    await prefs.remove(Keywords.isLoginned.name);
  }
}

enum Keywords {
  name,
  surname,
  isLoginned,
  counter,
}

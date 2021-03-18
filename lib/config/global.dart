/*
  * Prefs
  * Usage: save, get, delete data from device storage, same as local storage in browser
 */
import 'package:shared_preferences/shared_preferences.dart';

const ACCESS_TOKEN = "accessToken";
const ANONYMOUS_TOKEN = "anonymousToken";
const UPLOAD_TOKEN = "uploadToken";
const CURRENT_USER = "currentUser";
const FIREBASE_TOKEN = "firebaseToken";
const HASH_ID = "hashId";

class Prefs {
  static Future<void> savePrefs(String nameSave, String stringSave) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(nameSave);
    await prefs.setString(nameSave, stringSave);
  }

  static Future<String> getPref(String nameSave) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.get(nameSave);
  }

  static void deletePref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}


/*
  * Prefs
  * Usage: save, get, delete data from device storage, same as local storage in browser
 */
import 'package:shared_preferences/shared_preferences.dart';

const ACCESS_TOKEN = "accessToken";
const ANONYMOUS_TOKEN = "anonymousToken";
const CURRENT_USER = "currentUser";
const FIREBASE_TOKEN = "firebaseToken";

const VIDEO_SUBCATEGORY_INDEX = "videoCategory";
const EXAM_CATEGORY_ID = "examCategoryID";
const PROFILE = "profile";
const PROFILE_NAME = "profile_name";
const BOOK_ID = "book_id";

class Prefs {
  static void savePrefs(String nameSave, String stringSave) async {
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


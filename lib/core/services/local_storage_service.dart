import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  final SharedPreferences _prefs;
  LocalStorageService(this._prefs);

  static const String _favouritesKey = 'favourite_product_ids';
  static const String _themeKey = 'is_dark_mode';

  bool getIsDarkMode() {
    return _prefs.getBool(_themeKey) ?? false;
  }

  Future<void> saveIsDarkMode(bool isDrakMode) async {
    await _prefs.setBool(_themeKey, isDrakMode);
  }

  Set<int> getFavouriteIds() {
    final favList = _prefs.getStringList(_favouritesKey);
    if (favList == null || favList.isEmpty) return {};

    return favList.map((id) => int.tryParse(id)).whereType<int>().toSet();
  }

  Future<void> saveFavouriteIds(Set<int> favouriteIds) async {
    final stringList = favouriteIds.map((id) => id.toString()).toList();
    await _prefs.setStringList(_favouritesKey, stringList);
  }
}

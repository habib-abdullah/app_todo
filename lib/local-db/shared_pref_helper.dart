enum Todos { mealList }

class SharedPrefHelper {
  SharedPrefHelper._internal();

  static final SharedPrefHelper _singleton = SharedPrefHelper._internal();

  factory SharedPrefHelper() {
    return _singleton;
  }
}

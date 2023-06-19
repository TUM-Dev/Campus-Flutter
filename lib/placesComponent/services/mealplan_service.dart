import 'package:campus_flutter/base/extensions/dateTime+weekNumber.dart';
import 'package:campus_flutter/base/networking/apis/eatApi/eatApi.dart';
import 'package:campus_flutter/base/networking/apis/eatApi/eatApiError.dart';
import 'package:campus_flutter/base/networking/apis/eatApi/eatApiService.dart';
import 'package:campus_flutter/base/networking/protocols/mainApi.dart';
import 'package:campus_flutter/placesComponent/model/cafeterias/cafeteria.dart';
import 'package:campus_flutter/placesComponent/model/cafeterias/cafeteria_menu.dart';
import 'package:campus_flutter/placesComponent/model/cafeterias/dish.dart';
import 'package:campus_flutter/placesComponent/model/cafeterias/meal_plan.dart';
import 'package:campus_flutter/placesComponent/model/cafeterias/mensa_menu.dart';
import 'package:campus_flutter/providers_get_it.dart';

class MealPlanService {
  static Future<List<CafeteriaMenu>> getCafeteriaMenu(
      Cafeteria cafeteria) async {
    MainApi mainApi = getIt<MainApi>();
    final today = DateTime.now();
    final response = await mainApi.makeRequest<MealPlan, EatApi, EatApiError>(
        EatApi(
            EatApiServiceMenu(location: cafeteria.id, year: today.year, week: today.weekNumber())),
        MealPlan.fromJson,
        EatApiError.fromJson,
        false);

    final List<CafeteriaMenu> thisWeekMenu = _getMenuPerDay(response.data);

    try {
      final nextWeek = today.add(const Duration(days: 7));

      final nextWeekResponse = await mainApi.makeRequest<MealPlan, EatApi, EatApiError>(
          EatApi(EatApiServiceMenu(
              location: cafeteria.id, year: nextWeek.year, week: nextWeek.weekNumber()
          )),
          MealPlan.fromJson,
          EatApiError.fromJson,
          false);

      final List<CafeteriaMenu> nextWeekMenu =
      _filterNextWeekMenu(_getMenuPerDay(nextWeekResponse.data), thisWeekMenu);

      thisWeekMenu.addAll(nextWeekMenu);

      return thisWeekMenu;
    } catch (_) {
      print("Error");
      print(thisWeekMenu.length);
      return thisWeekMenu;
    }
  }

  static List<CafeteriaMenu> _filterNextWeekMenu(
      List<CafeteriaMenu> nextWeekMenu, List<CafeteriaMenu> thisWeekMenu) {
    List<CafeteriaMenu> filteredMenu = nextWeekMenu.where((menu) {
      return !thisWeekMenu.any((thisWeekMenu) => thisWeekMenu.date == menu.date);
    }).toList();

    return filteredMenu;
  }

  static List<CafeteriaMenu> _getMenuPerDay(MealPlan mealPlan) {
    List<CafeteriaMenu> cafeteriaMenu = [];
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    mealPlan.days.removeWhere((element) => (element.dishes.isEmpty ||
          (element.date != todayDate || element.date.isBefore(todayDate))));
    mealPlan.days.sort((menu1, menu2) => menu1.date.compareTo(menu2.date));

    cafeteriaMenu = mealPlan.days.map((e) {
      final List<MenuCategory> categories = _categories(e.dishes);
      return CafeteriaMenu(date: e.date, categories: categories);
    }).toList();

    cafeteriaMenu.sort((menu1, menu2) => menu1.date.compareTo(menu2.date));
    return cafeteriaMenu;
  }

  static List<MenuCategory> _categories(List<Dish> dishes) {
    Map<String, List<Dish>> dishMap = {};

    dishes.sort((dish1, dish2) => dish1.dishType.compareTo(dish2.dishType));

    for (var dish in dishes) {
      String type = dish.dishType.isEmpty ? "Sonstige" : dish.dishType;

      if (dishMap.containsKey(type)) {
        dishMap[type]?.add(dish);
      } else {
        dishMap[type] = [dish];
      }
    }

    List<MenuCategory> menuCategories = dishMap.entries.map((entry) {
      return MenuCategory(name: entry.key, dishes: entry.value);
    }).toList();

    return menuCategories;
  }
}
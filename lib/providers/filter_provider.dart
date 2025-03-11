import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mealsapp/providers/meals_provider.dart';

enum Filter { glutenFree, lactoseFree, vegetarian, vegan }

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false,
};

class FilterNotifier extends StateNotifier<Map<Filter, bool>> {
  FilterNotifier() : super(kInitialFilters);

  void setFilter(Filter filter, bool isActive) {
    state = {...state, filter: isActive};
  }

  void setFilters(Map<Filter, bool> filters) {
    state = filters;
  }
}

final filtersProvider =
    StateNotifierProvider<FilterNotifier, Map<Filter, bool>>(
      (ref) => FilterNotifier(),
    );

// Well, by using this ref argument here. Up to this point, whenever we created a provider,
//we never used this ref argument. We only did that in our widgets.
//But the ref argument we get here, automatically by riverpod,
// is in the end the same ref argument, the same ref object,
// we can use in our widgets. It's just that here, we're using it in a provider.
// And that's the beauty of riverpod. It allows us to use the same object in both places.
// It allows us to read or watch providers.
// And that's exactly what I want to do here now

////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////

// Now for that, we must import this meals_provider.dart filefrom the provider's folder.
// But with it imported, we can set up a watcher.And if you do set up a watcher here,
// the riverpod package will make sure ,that this function here gets re-executed
// whenever the watched value changes,so that in the end here you can then return an updated data.
// And any widgets that would be listening to this provider ,would then also be updated
// if one of the dependencies of that provider would update. All of that would happen automatically behind the scenes.
final filtredMealsProvider = Provider((ref) {
  final meals = ref.watch(mealsProvider);

  final activeFilters = ref.watch(filtersProvider);

  return meals.where((meal) {
    if (activeFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
      return false;
    }
    if (activeFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
      return false;
    }
    if (activeFilters[Filter.vegetarian]! && !meal.isVegetarian) {
      return false;
    }
    if (activeFilters[Filter.vegan]! && !meal.isVegan) {
      return false;
    }

    return true;
  }).toList();
});
// Now, with this, we're done with our filter provider. We have a provider that manages our filters,
// we have a provider that filters our meals based on these filters.

// <!--
// ==================================================
// Widgets/Tools utilisés sur cette page :
// - BottomNavigationBar → Navigation principale (max 5 items recommandé)
// - ScaffoldMessenger → Gestion des SnackBars (feedback utilisateur)
// - StatefulWidget → Gestion d'état complexe (favoris + filtres)
// - Async Navigation → await/Navigator

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mealsapp/screens/categories.dart';
import 'package:mealsapp/screens/meals.dart';
import 'package:mealsapp/widgets/sidedrawer.dart';
import 'package:mealsapp/screens/filters.dart';
import 'package:mealsapp/providers/favorite_provider.dart';
import 'package:mealsapp/providers/filter_provider.dart'; // Import du modèle Filter

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false,
};

class TabsScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selesctedpageindex = 0;

  void _selectPage(int index) {
    setState(() {
      _selesctedpageindex = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'filters') {
      await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(builder: (context) => const FiltersScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals = ref.watch(filtredMealsProvider);
    Widget activepage = CategoriesScreen(availableMeals: availableMeals);
    var activePageTitle = 'Categories';

    if (_selesctedpageindex == 1) {
      final favoriteMeals = ref.watch(favoriteMealProvider);
      activepage = MealsScreen(meals: favoriteMeals);
      activePageTitle = 'Your favorites';
    }

    return Scaffold(
      appBar: AppBar(title: Text(activePageTitle)),
      drawer: Sidedrawer(onSelectScreen: _setScreen),
      body: activepage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selesctedpageindex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal_outlined),
            label: 'Categories',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites'),
        ],
      ),
    );
  }
}

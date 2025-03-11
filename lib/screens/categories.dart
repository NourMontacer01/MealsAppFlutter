// <!--
// ==================================================
// Widgets/Tools utilisés sur cette page :
// - GridView → Optimisé pour les listes de grande taille (utilisation de .map avec génération dynamique)
// - SliverGridDelegateWithMaxCrossAxisExtent → Responsive adaptatif (maxCrossAxisExtent contrôle la largeur des colonnes)
// - CategoriesGridItem → Widget réutilisable avec gestion de tap via onSelectCategory
// - MaterialPageRoute → Navigation standard avec passage de paramètres (meals)

// Tips :
// • GridView > Préférer `builder` pour les listes longues (meilleures performances)
// • Hero Animation → Utiliser un `tag` unique (meal.id) pour lier les écrans
// • CategoriesGridItem → Encapsule la logique UI/gestures pour une meilleure maintenabilité
// ==================================================
// -->

import 'package:flutter/material.dart';
import 'package:mealsapp/models/category.dart';
import 'package:mealsapp/widgets/categories_grid_item.dart';
import 'package:mealsapp/data/dummy_data.dart';
import 'package:mealsapp/screens/meals.dart';
import 'package:mealsapp/models/meal.dart';

class CategoriesScreen extends StatefulWidget {
  CategoriesScreen({super.key, required this.availableMeals});

  final List<Meal> availableMeals;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  // SingleProviderState for one animation however TickerProviderStateMixin for multiple animations
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
      lowerBound: 0,
      upperBound: 1,
    );

    //starting the animation explicetly
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectedCategory(BuildContext context, Category category) {
    final filteredMeals =
        widget.availableMeals
            .where((meal) => meal.categories.contains(category.id))
            .toList();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) =>
                MealsScreen(title: category.title, meals: filteredMeals),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      child: GridView(
        padding: const EdgeInsets.all(25),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        children: [
          //availableCategories.map((category) => CategoriesGridItem(category: category)).toList(),
          for (final category in availableCategories)
            CategoriesGridItem(
              category: category,
              onSelectCategory: () {
                _selectedCategory(context, category);
              },
            ),
        ],
      ),
      builder:
          (context, child) => SlideTransition(
            position: Tween(begin: Offset(0, 0.3), end: Offset(0, 0)).animate(
              CurvedAnimation(
                parent: _animationController,
                curve: Curves.easeInOut,
              ),
            ),
            child: child,
          ),
    );
  }
}

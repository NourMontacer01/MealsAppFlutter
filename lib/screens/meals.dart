// <!-- 
// ==================================================
// Widgets/Tools utilisés sur cette page :
// - ListView.builder → Optimisé pour les listes dynamiques (rendu paresseux)
// - MealItem → Widget réutilisable avec gestion de clics
// - Conditional Rendering → Logique de contenu alternatif (meals.isEmpty)

// Tips :
// • ListView.builder > Préféré à Column+For pour les longues listes (meilleures perfs)
// • La gestion centralisée du layout (Scaffold/AppBar conditionnel) simplifie la réutilisation
// • Utilisation de Theme.of(context) pour une cohérence stylistique globale
// • Encapsulation de la logique de navigation dans _onSelectedmeal
// ==================================================
// -->

import 'package:flutter/material.dart';
import 'package:mealsapp/models/meal.dart';
import 'package:mealsapp/screens/meal.dart';
import 'package:mealsapp/widgets/meal_item.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({
    super.key,
    this.title,
    required this.meals,
    this.emptyTitle = 'No meals found, please check your filters',
    this.emptyHint = 'Try selecting another category',
  });

  final String? title;
  final List<Meal> meals;
  final String emptyTitle;
  final String emptyHint;

  void _onSelectedmeal(BuildContext context, Meal meal) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(body: MealScreen(meal: meal )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = ListView.builder(
      itemCount: meals.length,
      itemBuilder:
          (ctx, index) => MealItem(
            meal: meals[index],
            onSelectedMeal: () {
              _onSelectedmeal(context, meals[index]);
            },
          ),
    );
    if (meals.isEmpty) {
      content = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emptyTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: Text(
                emptyHint,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      );
    }
    if (title != null) {
      return Scaffold(appBar: AppBar(title: Text(title!)), body: content);
    }
    return content;
  }
}

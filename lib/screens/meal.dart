// <!--
// ==================================================
// Widgets/Tools utilisés sur cette page :
// - PopScope → Contrôle personnalisé du retour natif (sauvegarde auto des filtres)
// - SwitchListTile → Combine Switch + ListTile (état géré via setState)
// - Theme.of(context) → Récupération cohérente des styles (couleurs, typographie)

// Tips :
// • SwitchListTile > Isoler dans un StatefulWidget pour éviter les rebuilds inutiles
// • Utiliser `initState` pour initialiser les valeurs depuis les props (currentFilters)
// • PopScope > `canPop: false` force la validation via la flèche retour physique
// ==================================================
// -->

import 'package:flutter/material.dart';
import 'package:mealsapp/models/meal.dart';
import 'package:mealsapp/providers/favorite_provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MealScreen extends ConsumerWidget {
  MealScreen({super.key, required this.meal});

  final Meal meal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteMeals = ref.watch(favoriteMealProvider);
    final isFavorite = favoriteMeals.contains(meal);
    return Scaffold(
      appBar: AppBar(
        title: Text(meal.title),
        actions: [
          IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, animation) {
                return RotationTransition(turns: animation, child: child);
              },
              child: Icon(
                isFavorite ? Icons.star : Icons.star_border,
                key: ValueKey(isFavorite),
              ),
            ),
            onPressed: () {
              final wasAdded = ref
                  .read(favoriteMealProvider.notifier)
                  .toggleMealFavorite(meal);
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor:
                      (wasAdded
                          ? const Color.fromARGB(255, 101, 199, 104)
                          : const Color.fromARGB(255, 194, 83, 75)),
                  content: Text(
                    wasAdded ? 'Added to favorites' : 'Removed from favorites',
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );

              // Close the screen after a delay because the page pop is faster than the state
              // update even with using future.microtask , the screen is popped so quickly
              //Future.microtask should run after the current build phase.
              //So the sequence would be: onPressed is called, the provider updates, then the microtask queues the pop.
              //The build method should run again with the new isFavorite value, then the pop happens.
              // But maybe the pop is too quick, so the animation doesn't have time to complete before the screen is gone.

              Future.delayed(
                const Duration(milliseconds: 500),
                () => Navigator.of(context).pop(),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Meal Image
            Hero(
              tag: meal.id,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                child: FadeInImage(
                  placeholder: MemoryImage(kTransparentImage),
                  image: NetworkImage(meal.imageUrl),
                  fit: BoxFit.cover,
                  height: 300,
                  width: double.infinity,
                ),
              ),
            ),

            // Meal Details
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Basic Info
                  _buildInfoRow('Category', meal.categories.toString()),
                  _buildInfoRow('Complexity', meal.complexity.name),
                  _buildInfoRow('Affordability', meal.affordability.name),
                  _buildInfoRow('Preparation Time', '${meal.duration} minutes'),

                  const SizedBox(height: 20),

                  // Ingredients
                  _buildSectionTitle('Ingredients'),
                  _buildInfoList(meal.ingredients),

                  const SizedBox(height: 20),

                  // Steps
                  _buildSectionTitle('Steps'),
                  _buildInfoList(meal.steps, numbered: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Section Title Widget
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color.fromARGB(221, 139, 255, 161),
      ),
    );
  }

  // Info Row Widget
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(137, 255, 255, 255),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Color.fromARGB(221, 255, 255, 255),
            ),
          ),
        ],
      ),
    );
  }

  // Info List Widget (for Ingredients & Steps)
  Widget _buildInfoList(List<String> items, {bool numbered = false}) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (context, index) => const Divider(color: Colors.grey),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            numbered ? '${index + 1}. ${items[index]}' : '• ${items[index]}',
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        );
      },
    );
  }
}

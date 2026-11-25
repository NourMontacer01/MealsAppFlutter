import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mealsapp/data/dummy_data.dart';
import 'package:mealsapp/main.dart';
import 'package:mealsapp/providers/favorite_provider.dart';
import 'package:mealsapp/providers/filter_provider.dart';

void main() {
  setUpAll(() {
    // Keep tests offline: fall back to the default font instead of downloading.
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('filtredMealsProvider', () {
    late ProviderContainer container;

    setUp(() => container = ProviderContainer());
    tearDown(() => container.dispose());

    test('returns every meal when no filter is active', () {
      expect(container.read(filtredMealsProvider), hasLength(dummyMeals.length));
    });

    test('vegan filter keeps only vegan meals', () {
      container.read(filtersProvider.notifier).setFilter(Filter.vegan, true);

      final meals = container.read(filtredMealsProvider);
      expect(meals, isNotEmpty);
      expect(meals.every((meal) => meal.isVegan), isTrue);
      expect(meals.length, dummyMeals.where((m) => m.isVegan).length);
    });

    test('filters combine', () {
      container.read(filtersProvider.notifier).setFilters({
        Filter.glutenFree: true,
        Filter.lactoseFree: true,
        Filter.vegetarian: false,
        Filter.vegan: false,
      });

      final expected = dummyMeals
          .where((m) => m.isGlutenFree && m.isLactoseFree)
          .length;
      expect(container.read(filtredMealsProvider), hasLength(expected));
    });

    test('turning a filter off brings the meals back', () {
      final notifier = container.read(filtersProvider.notifier);
      notifier.setFilter(Filter.vegan, true);
      notifier.setFilter(Filter.vegan, false);

      expect(container.read(filtredMealsProvider), hasLength(dummyMeals.length));
    });
  });

  group('FavoriteMealsNotifier', () {
    test('toggling adds then removes a meal', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(favoriteMealProvider.notifier);
      final meal = dummyMeals.first;

      expect(notifier.toggleMealFavorite(meal), isTrue);
      expect(container.read(favoriteMealProvider), [meal]);

      expect(notifier.toggleMealFavorite(meal), isFalse);
      expect(container.read(favoriteMealProvider), isEmpty);
    });
  });

  group('App', () {
    testWidgets('opens on the categories tab', (tester) async {
      await tester.pumpWidget(const ProviderScope(child: App()));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, 'Categories'), findsOneWidget);
      expect(find.text('Italian'), findsOneWidget);
    });

    testWidgets('empty Favorites tab explains how to add meals',
        (tester) async {
      await tester.pumpWidget(const ProviderScope(child: App()));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.star));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, 'Your favorites'), findsOneWidget);
      expect(find.text('No favorites yet'), findsOneWidget);
    });
  });
}

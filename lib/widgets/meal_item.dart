import 'package:flutter/material.dart';
import 'package:mealsapp/models/meal.dart';
import 'package:mealsapp/widgets/meal_item_trait.dart';
import 'package:transparent_image/transparent_image.dart';

class MealItem extends StatelessWidget {
  const MealItem({super.key, required this.meal,required this.onSelectedMeal});

  final Meal meal;
  final void Function() onSelectedMeal;

  String get complexityText {
    return meal.complexity.name[0].toUpperCase() +
        meal.complexity.name.substring(1);
  }

  String get affordabilityText {
    return meal.affordability.name[0].toUpperCase() +
        meal.affordability.name.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ), // we didn't seen any borderradius because
      //the stack widget is the one that is ignoring the border radius and any shape that we have set for the card
      // to ensure the border radius we can use ClipBehavior
      elevation: 8,
      clipBehavior:
          Clip.hardEdge, // this will ensure that the border radius is respected
      child: InkWell(
        onTap: onSelectedMeal,
        child: Stack(
          children: [
            FadeInImage(
              placeholder: MemoryImage(kTransparentImage),
              image: NetworkImage(meal.imageUrl),
              fit: BoxFit.cover,
              height: 200,
              width: double.infinity,
            ),
            Positioned(
              right: 0,
              left:
                  0, // if left=50 : means that the container should end 50px before getting to the left edge of the FadeInImage : which will be on bottom of the image
              bottom: 0,
              child: Container(
                color: Colors.black54,
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    Text(
                      meal.title,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      softWrap: true,
                      overflow:
                          TextOverflow
                              .ellipsis, // if we had a very long text it will be displayed on two lines and the rest of the text will be replaced by three dots ...
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MealItemTrait(
                          icon: Icons.schedule,
                          label: '${meal.duration}',
                        ),
                        const SizedBox(width: 40),
                        MealItemTrait(
                          icon: Icons.hardware,
                          label: complexityText,
                        ),
                        const SizedBox(width: 20),
                        MealItemTrait(
                          icon: Icons.attach_money_outlined,
                          label: affordabilityText,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

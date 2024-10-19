import 'package:flutter/material.dart';
//import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/providers/meals_provider.dart';
import 'package:meals_app/providers/favorites_provider.dart';
import 'package:meals_app/providers/filters_provider.dart';
import 'package:meals_app/screen/categories.dart';
import 'package:meals_app/screen/filters.dart';
import 'package:meals_app/screen/meals.dart';
//import 'package:meals_app/models/meal.dart';
import 'package:meals_app/widgets/main_drawer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// const kInitialFilters = {
//   Filter.glutenFree: false,
//   Filter.lactoseFree: false,
//   Filter.vegetarian: false,
//   Filter.vegan: false
// };

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;
  //final List<Meal> _favoriteMeals = [];
  //Map<Filter, bool> _selectedFilters = kInitialFilters;

  // void _showInfoMessage(String message) {
  //   ScaffoldMessenger.of(context).clearSnackBars();
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(message),
  //     ),
  //   );
  // }

  // void _toggleMealFavoritesStatus(Meal meal) {
  //   final isExisting = _favoriteMeals.contains(meal);

  //   if (isExisting) {
  //     setState(() {
  //       _favoriteMeals.remove(meal);
  //     });
  //     _showInfoMessage('Meal is no longer a favorite');
  //   } else {
  //     setState(() {
  //       _favoriteMeals.add(meal);
  //     });
  //     _showInfoMessage('Marked as a favorite');
  //   }
  // }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();

    if (identifier == 'filters') {
      await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (cxt) => const FiltersScreen(),
        ),
      );
    }

    // if (identifier == 'filters') {
    //   final result = await Navigator.of(context).push<Map<Filter, bool>>(
    //     MaterialPageRoute(
    //       builder: (cxt) => const FiltersScreen(
    //           currentFilters: _selectedFilters,
    //           ),
    //     ),
    //   );

    //   setState(() {
    //     //for (final item in result!) {}

    //     _selectedFilters = result ?? kInitialFilters;
    //     // if result is null, then return kInitalFilters
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    // final meals = ref.watch(mealsProvider);

    // final activeFilters = ref.watch(filtersProvider);

    // var availableMeals = meals.where((meal) {
    //   if (activeFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
    //     return false;
    //   }
    //   if (activeFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
    //     return false;
    //   }
    //   if (activeFilters[Filter.vegetarian]! && !meal.isVegetarian) {
    //     return false;
    //   }

    //   if (activeFilters[Filter.vegan]! && !meal.isVegan) {
    //     return false;
    //   }
    //   // if (_selectedFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
    //   //   return false;
    //   // }
    //   // if (_selectedFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
    //   //   return false;
    //   // }
    //   // if (_selectedFilters[Filter.vegetarian]! && !meal.isVegetarian) {
    //   //   return false;
    //   // }

    //   // if (_selectedFilters[Filter.vegan]! && !meal.isVegan) {
    //   //   return false;
    //   // }
    //   return true;
    // }).toList();

    var availableMeals = ref.watch(filteredMealsProvider);

    Widget activePage = CategoriesScreen(
      //onToggleFavorite: _toggleMealFavoritesStatus,
      availableMeals: availableMeals,
    );

    var activePageTitle = 'Categories';

    if (_selectedPageIndex == 1) {
      final favoriteMeals = ref.watch(favoriteMealsProvider);

      activePage = MealsScreen(
        //meals: _favoriteMeals,
        meals: favoriteMeals,
        //onToggleFavorite: _toggleMealFavoritesStatus,
      );
      activePageTitle = 'Your Favorites';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex, //control which tap highlight
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}

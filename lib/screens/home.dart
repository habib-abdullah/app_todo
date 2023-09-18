import 'dart:convert';

import 'package:app_todo/local-db/meal_model.dart';
import 'package:app_todo/utils/components.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final notifier = ValueNotifier(false);
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  List<MealModel> _list = [];
  Components _components = Components();
  final List<String> imgList = [
    "assets/back6.png",
    "assets/back1.png",
    "assets/back3.png",
    "assets/back4.png",
    "assets/back5.png",
    "assets/back2.png",
    "assets/back7.png",
    "assets/back8.png",
    "assets/back9.png",
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    notifier.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) async {
      _list.addAll([
        MealModel(id: "1", title: 'Vegetable Stir-fry', isCompleted: false),
        MealModel(id: "2", title: 'Spaghetti Aglio e Olio', isCompleted: false),
        MealModel(id: "3", title: 'Chickpea Curry', isCompleted: false),
        MealModel(id: "4", title: 'Caprese Salad', isCompleted: false),
        MealModel(id: "5", title: 'Veggie Burger', isCompleted: false),
      ]);
      await saveList();
      await getList();
    });
    super.initState();
  }

  Future<void> getList() async {
    notifier.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      String meal = prefs.getString("meal") ?? "";
      if (meal.isEmpty) {
        _list = [];
        notifier.value = false;
        return;
      }
      _list.clear();
      List mealList = jsonDecode(meal);
      for (final meal in mealList) {
        _list.add(MealModel.fromJson(meal));
      }
    } catch (err) {
      debugPrint("catch error on fetch meal list $err");
    }
    notifier.value = false;
  }

  Future<void> saveList() async {
    notifier.value = true;
    try {
      List items = _list.map((e) => e.toJson()).toList();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("meal", jsonEncode(items));
    } catch (err) {
      debugPrint("catch error on saving");
    }
    notifier.value = false;
  }

  Future<void> completeChallenge(model) async {
    await QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: "Congratulations for completed the challenge! 🎉",
        onConfirmBtnTap: () async {
          /// Updating the old value
          final indexOfUpdatingMeal = _list.indexWhere((element) => element.id == model.id);
          if (indexOfUpdatingMeal != -1) {
            _list[indexOfUpdatingMeal] = MealModel(
              id: model.id,
              title: model.title,
              isCompleted: true,
            );
            debugPrint("meal updated: ${_list[indexOfUpdatingMeal]}");
          } else {
            debugPrint("meal with id $indexOfUpdatingMeal not found.");
          }
          if (mounted) Navigator.pop(context);
          await saveList();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (
          context,
          innerBoxIsScrolled,
        ) =>
            [
          _components.sliverAppBar(imgList, "Meatless Meal"),
        ],
        body: ValueListenableBuilder<bool>(
          valueListenable: notifier,
          builder: (context, bool loading, _) {
            if (loading) return const Center(child: CircularProgressIndicator());
            if (_list.isEmpty) return const Center(child: Text("Add Meal"));
            return RefreshIndicator(
              onRefresh: () async {
                await getList();
                return;
              },
              child: ListView.builder(
                itemCount: _list.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  final model = _list[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Card(
                      color: Colors.white,
                      child: ListTile(
                        title: Text(
                          model.title ?? "",
                          style: TextStyle(
                            decoration: model.isCompleted ?? false ? TextDecoration.lineThrough : TextDecoration.none,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing: Checkbox(
                          value: model.isCompleted ?? false,
                          onChanged: (val) async {
                            if (model.isCompleted != null && model.isCompleted == true) {
                              return;
                            }
                            await completeChallenge(model);
                          },
                        ),
                        leading: IconButton(
                          onPressed: () {},
                          icon: Image.asset(
                            "assets/food.png",
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

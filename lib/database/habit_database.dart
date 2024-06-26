import 'package:flutter/material.dart';
import 'package:habit_tracker/models/app_settings.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier{
  static late Isar isar;
  //initializing db
  static Future<void> initialize() async{
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([HabitSchema, AppSettingsSchema], directory: dir.path);
  }


  //save first date
  Future<void> saveFirstLaunchDate() async{
    final existingSetting = await isar.appSettings.where().findFirst();
    if(existingSetting == null){
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

  //get first date app startup
  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchDate;
  }

//list of habit
final List<Habit> currentHabits = [];

//create habit
Future<void> addHabbit(String habitName) async{
 //create a new habit
  final newHabit = Habit()..name = habitName;
  //save to db
  await isar.writeTxn(() => isar.habits.put(newHabit));

  //read from db
  readHabits();
}

//read

Future<void> readHabits() async{
  //fetch all habit from db
  List<Habit> fetchHabits = await isar.habits.where().findAll();
  //give to current habits
  currentHabits.clear();
  currentHabits.addAll(fetchHabits);
  notifyListeners();
}

//update - check on and off
Future<void> updateHabitCompletion(int id , bool isCompleted) async{
  //find specific gabit
  final habit = await isar.habits.get(id);

  //update completed status
  if(habit !=null){
    await isar.writeTxn(() async {
      if(isCompleted && !habit.completedDays.contains(DateTime.now())){
        //today
        final today = DateTime.now();

        //add the current date if its not already in list
        habit.completedDays.add(
          DateTime(
            today.year,
            today.month,
            today.day,
          ),
        );
      }else{
        //remove the current date if habit is marked as not completed
        habit.completedDays.removeWhere((date) =>date.year == DateTime.now().year && date.month == DateTime.now().month
        &&date.day == DateTime.now().day
        );
      }
      //save updated habit
      await isar.habits.put(habit);
    });
  }
  //re read database
  readHabits();
}

//update edit habit name
Future<void> updateHabitName(int id , String newName) async{
  final habit = await isar.habits.get(id);

  //update habit name 
  if(habit != null){
    await isar.writeTxn(() async{
      habit.name = newName;
    //save AGAIN
    await isar.habits.put(habit);
    });
    
  }
  readHabits();
}
//DELETE HABIT
Future<void> deleteHabit (int id) async{
  await isar.writeTxn(() async{
    await isar.habits.delete(id);
  });
  readHabits();
}






}
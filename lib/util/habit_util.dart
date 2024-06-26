import 'package:habit_tracker/models/habit.dart';

bool isHabitCompletedToday(List<DateTime> completedDays){
  final today = DateTime.now();
  return completedDays.any((date) =>date.year == today.year &&
  date.month == today.month &&
  date.day == today.day );
}

//prepare heatmap dataset
Map<DateTime , int> prepareheatmapDataset(List<Habit> habit){
  Map<DateTime , int> dataset = {};

  for(var habitx in habit){
    for(var date in habitx.completedDays){
      final normalizedDate = DateTime(date.year,date.month,date.day);

      if(dataset.containsKey(normalizedDate)){
        dataset[normalizedDate] = dataset[normalizedDate]! + 1;
      }else{
        dataset[normalizedDate] = 1;
      }
    }
  }
  return dataset;
}
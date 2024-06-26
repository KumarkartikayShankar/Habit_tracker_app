import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:habit_tracker/components/my_drawer.dart';
import 'package:habit_tracker/components/my_habit_tile.dart';
import 'package:habit_tracker/components/my_heat_map.dart';
import 'package:habit_tracker/database/habit_database.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:habit_tracker/util/habit_util.dart';
import 'package:provider/provider.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
@override
  void initState() {
    //read existing habit
    Provider.of<HabitDatabase>(context , listen: false).readHabits();
    super.initState();
  }

  final TextEditingController textController = TextEditingController();
  //create new habit
  void createNewHabit(){
    showDialog(context: context, builder: (context)=> AlertDialog(
      content: TextField(
        controller: textController,
        decoration: const InputDecoration(
          hintText: "Create a new Habit",
          ),
          ),
          actions: [
            //save button 
            MaterialButton(onPressed: (){
              // Create new habit name
              String newHabitName = textController.text;
              // Save to db
              context.read<HabitDatabase>().addHabbit(newHabitName);


              //pop the box
              Navigator.pop(context);
              //clear text controller
              textController.clear();

            },
            child: const Text('Save'),
            ),
            MaterialButton(onPressed: (){
              //pop box
              Navigator.pop(context);
              //clear controller
               textController.clear();
            },
            child: const Text('Cancel'),),
            
          ],
    ));
  }
  void checkHabitOnOff(bool? value,Habit habit){
    if(value != null){
      context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
    }
  }

  //edit habit
  void editHabitBox(Habit habit){
    textController.text = habit.name;
    showDialog(context: context, builder: (context) =>AlertDialog(content:TextField(
      controller: textController
    ),actions: [
       //save button 
            MaterialButton(onPressed: (){
              // Create new habit name
              String newHabitName = textController.text;
              // Save to db
              context.read<HabitDatabase>().updateHabitName(habit.id,newHabitName);


              //pop the box
              Navigator.pop(context);
              //clear text controller
              textController.clear();

            },
            child: const Text('Save'),
            ),
            MaterialButton(onPressed: (){
              //pop box
              Navigator.pop(context);
              //clear controller
               textController.clear();
            },
            child: const Text('Cancel'),),
    ],),  );
  }
  //delete habit



  void deleteHabitBox(Habit habit){
     showDialog(context: context, builder: (context) =>  AlertDialog(
      title: Text('Are you Sure Want to Delete'),
      actions: [
       //save button 
            MaterialButton(onPressed: (){
              // Create new habit name
              String newHabitName = textController.text;
              // Save to db
              context.read<HabitDatabase>().deleteHabit(habit.id);


              //pop the box
              Navigator.pop(context);
              //clear text controller
              
            },
            child: const Text('Delete'),
            ),
            MaterialButton(onPressed: (){
              //pop box
              Navigator.pop(context);
             
            },
            child: const Text('Cancel'),),
    ],),  );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      drawer: const Mydrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: Icon(
          Icons.add, color: Colors.grey,),),
          body: ListView(children: [
             // HEAT MAP
            _buildHeatMap(),


             //HABITLIST
             _buildHabitList(),
          ],
           
            


           
          ),
    );
  }

Widget _buildHeatMap(){
  final habitDatabase = context.watch<HabitDatabase>();

  //current habit 
  List<Habit> currentHabits = habitDatabase.currentHabits;
  //return UI
  return FutureBuilder<DateTime?>(future: habitDatabase.getFirstLaunchDate(),builder: (context , snapshot){
    //one date available build heat map
    if(snapshot.hasData){
      return MyHeatMap(startDate: snapshot.data!, datasets: prepareheatmapDataset(currentHabits));

     
  
      

    }
     //handle where no date returned
     else{
      return Container();
     } 
  },);
}
  Widget _buildHabitList(){
    // habit db
    final habitDatabase = context.watch<HabitDatabase>();

    //currnt habits
    List<Habit> currentHabits = habitDatabase.currentHabits;
    return ListView.builder(itemCount: currentHabits.length,shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemBuilder: (context, index) {
      //get habit
      final habit = currentHabits[index];

      // check if the habit is completed today
      bool isCompletedToday = isHabitCompletedToday(habit.completedDays);

      //return habit tile UI
      return MyHabitTile(isCompleted: isCompletedToday, text: habit.name,
      onChanged: (value) => checkHabitOnOff(value , habit),
      editHabit: (context) => editHabitBox(habit),
      deleteHabit: (context) => deleteHabitBox(habit),);

    },);
  }
}

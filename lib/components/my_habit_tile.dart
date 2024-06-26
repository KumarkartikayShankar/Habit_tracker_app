import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';


class MyHabitTile extends StatelessWidget {
  final String text;
  final bool isCompleted;
  final void Function(bool?)? onChanged;
  final void Function(BuildContext)? editHabit;
  final void Function(BuildContext)? deleteHabit;


  const MyHabitTile({super.key, 
  required this.isCompleted, required this.text,
  required this.onChanged, required this.editHabit,required this.deleteHabit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 25),
      
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            //edit
            SlidableAction(onPressed: editHabit,
            backgroundColor: Colors.grey.shade800,
            icon: Icons.edit,
            borderRadius: BorderRadius.circular(8),),
            //delete option
             SlidableAction(onPressed: deleteHabit,
            backgroundColor: Colors.red.shade800,
            icon: Icons.delete,
            borderRadius: BorderRadius.circular(8),)
          ],
        ),
        child: InkWell(
          //splashColor: Color.fromARGB(42, 31, 103, 5),
          onTap: (){
            if(onChanged != null){
              onChanged!(!isCompleted);
            }
          },
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),
              color: isCompleted ? Colors.green : Theme.of(context).colorScheme.secondary
            ),
            padding: const EdgeInsets.all(12),
            child: ListTile(title: Text(text , style: TextStyle(color: isCompleted ? Colors.white : Theme.of(context).colorScheme.inversePrimary),),
            leading: Checkbox(value: isCompleted,
            activeColor: Colors.green,
            onChanged: onChanged,),),
          ),
        ),
      ),
    );
  }
}
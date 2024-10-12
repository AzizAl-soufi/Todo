import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo/cubit/cubit.dart';
import 'package:todo/cubit/states.dart';
import 'package:todo/models/task_model.dart';

class ArchivedScreen extends StatelessWidget {
  const ArchivedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCubit, TaskStates>(
      builder: (context, state) {
        var cubit = TaskCubit.get(context);
        var archived = cubit.archived;
        if (archived.isEmpty) {
          return cubit.nullScreens[2];
        }
        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) => TaskItem(
                  context,
                  TaskModel(
                    id: archived[index]["id"],
                    title: archived[index]['title'],
                    date: archived[index]['date'],
                    time: archived[index]['time'],
                  ),
                  cubit,
                ),
                separatorBuilder: (context, index) => Container(
                  height: 1,
                  color: const Color.fromARGB(255, 71, 71, 71),
                ),
                itemCount: archived.length,
              ),
            ),
            const SizedBox(height: 16.0),
          ],
        );
      },
    );
  }

  Widget TaskItem(BuildContext context, TaskModel task, cubit) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          color: const Color.fromARGB(23, 35, 33, 36),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      child: Text(
                        task.time,
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            children: [
                              Text(
                                task.title,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                          Text(
                            task.date,
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton(
                itemBuilder: (context) => [
                  const PopupMenuItem<Text>(
                    onTap: null,
                    child: Text('Options'),
                  ),
                  PopupMenuItem(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          final ValueNotifier<bool> isChecked =
                              ValueNotifier<bool>(false);
                          var titleController = TextEditingController();
                          var timeController = TextEditingController();
                          var dateController = TextEditingController();
                          titleController.text = task.title;
                          dateController.text = task.date;
                          timeController.text = task.time;
                          return AlertDialog(
                            backgroundColor: Colors.grey[900],
                            actionsAlignment: MainAxisAlignment.start,
                            title: Row(
                              children: [
                                const Icon(
                                  Icons.edit,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'Edit Task',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                            content: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    cursorColor: Theme.of(context).primaryColor,
                                    controller: titleController,
                                    keyboardType: TextInputType.text,
                                    validator: (value) => (value!.isEmpty)
                                        ? "Title is empty."
                                        : null,
                                    decoration: InputDecoration(
                                      iconColor:
                                          Theme.of(context).iconTheme.color,
                                      labelText: 'Task title',
                                      labelStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                      prefixIcon: Icon(
                                        Icons.title,
                                        color:
                                            Theme.of(context).iconTheme.color,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: dateController,
                                    keyboardType: TextInputType.datetime,
                                    validator: (value) => (value!.isEmpty)
                                        ? "date is empty."
                                        : null,
                                    onTap: () {
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.now()
                                            .add(const Duration(days: 30)),
                                      ).then(
                                        (value) {
                                          dateController.text = dateController
                                                  .text =
                                              DateFormat.yMMMd().format(value!);
                                        },
                                      );
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'Task date',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      prefixIcon: Icon(Icons.date_range),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: timeController,
                                    keyboardType: TextInputType.datetime,
                                    validator: (value) => (value!.isEmpty)
                                        ? "Time is empty."
                                        : null,
                                    onTap: () {
                                      showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      ).then((value) {
                                        timeController.text =
                                            value!.format(context);
                                      });
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'Task time',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      prefixIcon: Icon(Icons.watch_later),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text('Do you want to pin it.'),
                                      ValueListenableBuilder<bool>(
                                        valueListenable: isChecked,
                                        builder: (context, value, child) {
                                          return Checkbox(
                                            value: value,
                                            onChanged: (value) {
                                              isChecked.value = value!;
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        width: 60,
                                        height: 30,
                                        child: FloatingActionButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      SizedBox(
                                        width: 60,
                                        height: 30,
                                        child: FloatingActionButton(
                                          onPressed: () {
                                            if (titleController
                                                    .text.isNotEmpty &&
                                                dateController
                                                    .text.isNotEmpty &&
                                                timeController
                                                    .text.isNotEmpty) {
                                              cubit.updateTask(
                                                id: task.id,
                                                title: titleController.text,
                                                date: dateController.text,
                                                time: timeController.text,
                                                status: isChecked.value,
                                              );
                                            }
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Ok'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.edit),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: ((BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.grey[900],
                            title: const Text(
                              'delete',
                              style: TextStyle(color: Colors.red),
                            ),
                            content: const Text('are you sure!!'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  cubit.deleteTask(task.id);
                                  Navigator.of(context).pop();
                                },
                                child: const Text('yes'),
                              ),
                            ],
                          );
                        }),
                      );
                    },
                    child: const Row(
                      children: [
                        Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

isArabic(String text) {
  if (text.isEmpty) return false;
  RegExp arabic = RegExp(r'[\u0600-\u06ff]');
  return arabic.hasMatch(text);
}

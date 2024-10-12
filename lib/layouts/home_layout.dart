import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/cubit/cubit.dart';
import 'package:todo/cubit/states.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  final ValueNotifier<bool> isChecked = ValueNotifier<bool>(false);
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskCubit()..createDatabase(),
      child: BlocBuilder<TaskCubit, TaskStates>(
        builder: (context, state) {
          TaskCubit cubit = TaskCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndex]),
              elevation: 3,
            ),
            body: cubit.screens[cubit.currentIndex],
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isSheet) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDataBase(
                      title: titleController.text,
                      date: dateController.text,
                      time: timeController.text,
                      status: isChecked.value,
                    );
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: ((BuildContext context) {
                        return AlertDialog(
                          title: const Text(
                            'Success',
                            style: TextStyle(color: Colors.green),
                          ),
                          content: const Text('done saved a new task.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                titleController.text = '';
                                dateController.text = '';
                                titleController.text = '';
                                cubit.chaneBottomCheetState(
                                  icon: const Icon(Icons.add),
                                  isShow: false,
                                );
                              },
                              child: const Text('ok'),
                            ),
                          ],
                        );
                      }),
                    );
                  }
                } else {
                  scaffoldKey.currentState
                      ?.showBottomSheet(
                        (context) => Container(
                          padding: const EdgeInsets.all(20),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10,
                                        bottom: 10,
                                      ),
                                      child: Text(
                                        'New Task',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ),
                                  ],
                                ),
                                TextFormField(
                                  controller: titleController,
                                  keyboardType: TextInputType.text,
                                  validator: (value) => (value!.isEmpty)
                                      ? "Title is empty."
                                      : null,
                                  decoration: const InputDecoration(
                                    labelText: 'Task title',
                                    prefixIcon: Icon(Icons.title),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
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
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
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
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
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
                                          activeColor: Colors.blueAccent,
                                          value: value,
                                          onChanged: (value) {
                                            isChecked.value = value!;
                                          },
                                        );
                                      },
                                    ),
                                    SizedBox(
                                      width: 80,
                                      height: 30,
                                      child: FloatingActionButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          timeController.text = '';
                                          dateController.text = '';
                                          titleController.text = '';
                                          cubit.chaneBottomCheetState(
                                            icon: const Icon(Icons.add),
                                            isShow: false,
                                          );
                                        },
                                        // mini: true,
                                        child: const Text('Cancel'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .closed
                      .then((value) {
                    titleController.text = '';
                    dateController.text = '';
                    titleController.text = '';
                    cubit.chaneBottomCheetState(
                      icon: const Icon(Icons.add),
                      isShow: false,
                    );
                  });
                  cubit.chaneBottomCheetState(
                    icon: const Icon(Icons.arrow_downward),
                    isShow: true,
                  );
                }
              },
              child: cubit.iconFloating,
            ),
            bottomNavigationBar: NavigationBar(
              onDestinationSelected: (index) {
                cubit.changeIndex(index);
              },
              selectedIndex: cubit.currentIndex,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: "Home",
                ),
                NavigationDestination(
                  icon: Icon(Icons.push_pin_outlined),
                  selectedIcon: Icon(Icons.push_pin_rounded),
                  label: "Pinned",
                ),
                NavigationDestination(
                  icon: Icon(Icons.archive_outlined),
                  selectedIcon: Icon(Icons.archive),
                  label: 'Archived',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

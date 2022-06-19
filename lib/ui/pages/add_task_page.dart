import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/controllers/task_controller.dart';
import 'package:todo/ui/theme.dart';
import 'package:todo/ui/widgets/button.dart';
import 'package:todo/ui/widgets/input_field.dart';

import '../../models/task.dart';

/// add task page used to fill task details and time to notify
/// by aid of task controller to save task into database
/// to be able to retrieved and displayed in home page
class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 15)))
      .toString();
  int _selectedRemind = 0;
  List<int> remindList = [0, 5, 10, 15, 20];
  String _selectedRepeat = 'None';
  List<String> repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];
  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Add Task',
                style: headingStyle,
              ),
              InputField(
                title: 'Title',
                hint: 'Enter title here.',
                controller: _titleController,
              ),
              InputField(
                title: 'Note',
                hint: 'Enter note here.',
                controller: _noteController,
              ),
              InputField(
                title: 'Date',
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  onPressed: () => _getDateFromUser(),
                  icon: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      hint: _startTime,
                      title: 'Start Time',
                      widget: IconButton(
                        onPressed: () => _getTimeFromUser(isStartTime: true),
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InputField(
                      hint: _endTime,
                      title: 'End Time',
                      widget: IconButton(
                        onPressed: () => _getTimeFromUser(isStartTime: false),
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              InputField(
                title: 'Remind',
                hint: '$_selectedRemind minutes early',
                widget: Row(
                  children: [
                    DropdownButton<int>(
                      items: remindList
                          .map(
                            (e) => DropdownMenuItem<int>(
                              value: e,
                              child: Text(
                                '$e',
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (nVal) => setState(() {
                        _selectedRemind = nVal!;
                      }),
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                      dropdownColor: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10),
                      iconSize: 32,
                      elevation: 4,
                      underline: Container(
                        height: 0,
                      ),
                      style: subTitleStyle,
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                  ],
                ),
              ),
              InputField(
                title: 'Repeat',
                hint: _selectedRepeat,
                widget: Row(
                  children: [
                    DropdownButton<String>(
                      items: repeatList
                          .map(
                            (e) => DropdownMenuItem<String>(
                              value: e,
                              child: Text(
                                e,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (nVal) => setState(() {
                        _selectedRepeat = nVal!;
                      }),
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                      dropdownColor: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10),
                      iconSize: 32,
                      elevation: 4,
                      underline: Container(
                        height: 0,
                      ),
                      style: subTitleStyle,
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _colorPalette(),
                  MyButton(
                    label: 'Create Task',
                    onTap: _taskValidate,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar() => AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 24,
            color: primaryClr,
          ),
        ),
        elevation: 0,
        backgroundColor: context.theme.backgroundColor,
        actions: const [
          CircleAvatar(
            radius: 18,
            backgroundImage: AssetImage('images/person.jpeg'),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      );

  Column _colorPalette() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color',
          style: titleStyle,
        ),
        const SizedBox(
          height: 8,
        ),
        Wrap(
          children: List.generate(
              3,
              (index) => GestureDetector(
                    onTap: () => setState(() {
                      _selectedColor = index;
                    }),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: CircleAvatar(
                        backgroundColor: index == 0
                            ? primaryClr
                            : index == 1
                                ? pinkClr
                                : orangeClr,
                        radius: 14,
                        child: _selectedColor == index
                            ? const Icon(
                                Icons.done,
                                size: 16,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ),
                  )),
        )
      ],
    );
  }

  _taskValidate() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTaskToDB();
      Get.back();
    } else if (_titleController.text.isNotEmpty ||
        _noteController.text.isEmpty) {
      Get.snackbar(
        'Required',
        'All fields are required!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: pinkClr,
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: Colors.red,
        ),
      );
    } else {
      print('################## SOMETHING BAD HAPPENED ##################');
    }
  }

  _addTaskToDB() async {
    try {
      int value = await _taskController.addTask(
        task: Task(
          title: _titleController.text,
          note: _noteController.text,
          isCompleted: 0,
          date: DateFormat.yMd().format(_selectedDate),
          startTime: _startTime,
          endTime: _endTime,
          color: _selectedColor,
          repeat: _selectedRepeat,
          remind: _selectedRemind,
        ),
      );
      print('task id: $value');
    } catch (e) {
      print('Error');
    }
  }

  _getDateFromUser() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null) {
      setState(() => _selectedDate = pickedDate);
    } else {
      print('It\'s null or something is wrong');
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? TimeOfDay.fromDateTime(DateTime.now())
          : TimeOfDay.fromDateTime(
              DateTime.now().add(
                const Duration(minutes: 15),
              ),
            ),
    );
    if (pickedTime != null) {
      setState(() => isStartTime
          ? _startTime = pickedTime.format(context)
          : _endTime = pickedTime.format(context));
    } else {
      print('Time canceled or something wrong');
    }
  }
}

import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:show_up_animation/show_up_animation.dart';
import 'package:todo/models/task.dart';
import 'package:todo/services/notification_services.dart';
import 'package:todo/services/theme_services.dart';

import '../../controllers/task_controller.dart';
import '../size_config.dart';
import '../theme.dart';
import '../widgets/button.dart';
import '../widgets/task_tile.dart';
import 'add_task_page.dart';
import 'notification_screen.dart';

/// home page screen that displays tasks retrieved from the database
/// and using GetX controller to update if needed
class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.payload}) : super(key: key);

  final String? payload;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TaskController _taskController = Get.put(TaskController());
  DateTime _selectedDate = DateTime.now();
  var notifyHelper = NotifyHelper();

  @override
  initState() {
    super.initState();
    notifyHelper.initializeNotification();
    _taskController.getTasks();
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) {
      if (widget.payload != null) {
        debugPrint('My payload is ${widget.payload}');
        Get.to(() => NotificationScreen(
              payload: widget.payload!,
            ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          const SizedBox(
            height: 6,
          ),
          _showTasks(),
        ],
      ),
    );
  }

  AppBar _appBar() => AppBar(
        leading: IconButton(
          onPressed: () => ThemeServices().switchTheme(),
          icon: Icon(
            Get.isDarkMode
                ? Icons.wb_sunny_outlined
                : Icons.nightlight_round_outlined,
            size: 24,
            color: Get.isDarkMode ? Colors.white : darkGreyClr,
          ),
        ),
        elevation: 0,
        backgroundColor: context.theme.backgroundColor,
        actions: [
          IconButton(
            tooltip: 'Delete All Tasks',
            onPressed: () {
              notifyHelper.cancelAllNotifications();
              _taskController.deleteAllTasks();
            },
            icon: Icon(
              Icons.cleaning_services_outlined,
              size: 24,
              color: Get.isDarkMode ? Colors.white : darkGreyClr,
            ),
          ),
          const CircleAvatar(
            radius: 18,
            backgroundImage: AssetImage('images/person.jpeg'),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      );

  Widget _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(
        left: 10,
        right: 10,
        top: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: subHeadingStyle,
              ),
              Text(
                'Today',
                style: headingStyle,
              ),
            ],
          ),
          MyButton(
            label: '+ Add Task',
            onTap: () async {
              await Get.to(() => const AddTaskPage());
              _taskController.getTasks();
            },
          ),
        ],
      ),
    );
  }

  Widget _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 6, left: 20),
      child: DatePicker(
        DateTime.now(),
        width: 70,
        height: 100,
        initialSelectedDate: DateTime.now(),
        selectedTextColor: Colors.white,
        selectionColor: primaryClr,
        dateTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        onDateChange: (nDate) {
          setState(() {
            _selectedDate = nDate;
          });
        },
      ),
    );
  }

  Future<void> _onRefresh() async {
    await _taskController.getTasks();
  }

  Widget _showTasks() {
    // return Expanded(
    //   child: Obx(() {
    //     if (_taskController.taskList.isEmpty) {
    //       return _noTaskMsg();
    //     } else {
    //       return RefreshIndicator(
    //         onRefresh: _onRefresh,
    //         child: ListView.builder(
    //           scrollDirection: SizeConfig.orientation == Orientation.landscape
    //               ? Axis.horizontal
    //               : Axis.vertical,
    //           itemCount: _taskController.taskList.length,
    //           itemBuilder: (ctx, index) {
    //             var task = _taskController.taskList[index];
    //
    //             if (task.repeat == 'Daily' ||
    //                 task.date == DateFormat.yMd().format(_selectedDate) ||
    //                 (task.repeat == 'Weekly' &&
    //                     _selectedDate
    //                                 .difference(
    //                                     DateFormat.yMd().parse(task.date!))
    //                                 .inDays %
    //                             7 ==
    //                         0) ||
    //                 (task.repeat == 'Monthly' &&
    //                     _selectedDate.day ==
    //                         DateFormat.yMd().parse(task.date!).day)) {
    //               // var hour = task.startTime.toString().split(':')[0];
    //               // var minutes = task.startTime.toString().split(':')[1];
    //               // print('My time is $hour');
    //               // print('My minute is $minutes');
    //
    //               var date = DateFormat.jm().parse(task.startTime!);
    //               var myTime = DateFormat('HH:mm').format(date);
    //
    //               notifyHelper.scheduledNotification(
    //                 int.parse(myTime.toString().split(':')[0]),
    //                 int.parse(myTime.toString().split(':')[1]),
    //                 task,
    //               );
    //
    //               return AnimationConfiguration.staggeredList(
    //                 position: index,
    //                 delay: const Duration(milliseconds: 1375),
    //                 child: SlideAnimation(
    //                   horizontalOffset: 300,
    //                   child: FadeInAnimation(
    //                     child: GestureDetector(
    //                       onTap: () => showBottomSheet(
    //                         context,
    //                         task,
    //                       ),
    //                       child: TaskTile(
    //                         task: task,
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               );
    //             }
    //             return Container();
    //           },
    //         ),
    //       );
    //     }
    //   }),
    // );
    return Expanded(
      child: Obx(() {
        if (_taskController.taskList.isEmpty) {
          return _noTaskMsg();
        } else {
          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: ShowUpList(
              direction: Direction.horizontal,
              enableLazyLoading: true,
              animationDuration: const Duration(milliseconds: 1000),
              delayBetween: const Duration(milliseconds: 200),
              offset: 0.5,
              children: _taskController.taskList.map<Widget>((element) {
                var task = element;

                if (task.repeat == 'Daily' ||
                    task.date == DateFormat.yMd().format(_selectedDate) ||
                    (task.repeat == 'Weekly' &&
                        _selectedDate
                                    .difference(
                                        DateFormat.yMd().parse(task.date!))
                                    .inDays %
                                7 ==
                            0) ||
                    (task.repeat == 'Monthly' &&
                        _selectedDate.day ==
                            DateFormat.yMd().parse(task.date!).day)) {
                  var date = DateFormat.jm().parse(task.startTime!);
                  var myTime = DateFormat('HH:mm').format(date);

                  notifyHelper.scheduledNotification(
                    int.parse(myTime.toString().split(':')[0]),
                    int.parse(myTime.toString().split(':')[1]),
                    task,
                  );

                  return GestureDetector(
                    onTap: () => showBottomSheet(
                      context,
                      task,
                    ),
                    child: TaskTile(
                      task: task,
                    ),
                  );
                }
                return Container();
              }).toList(),
            ),
          );
        }
      }),
    );
  }

  Widget _noTaskMsg() {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 2000),
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                direction: SizeConfig.orientation == Orientation.landscape
                    ? Axis.horizontal
                    : Axis.vertical,
                children: [
                  SizeConfig.orientation == Orientation.portrait
                      ? const SizedBox(
                          height: 220,
                        )
                      : const SizedBox(
                          height: 6,
                        ),
                  SvgPicture.asset(
                    'images/task.svg',
                    color: primaryClr.withOpacity(0.5),
                    height: 90,
                    semanticsLabel: 'Task',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: Text(
                      'You do not have any tasks yet!\nAdd new tasks to make your days productive.',
                      style: subTitleStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizeConfig.orientation == Orientation.portrait
                      ? const SizedBox(
                          height: 180,
                        )
                      : const SizedBox(
                          height: 120,
                        ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  _buildBottomSheet({
    required String label,
    required Function() onTap,
    required Color clr,
    bool isClose = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 65,
        width: SizeConfig.screenWidth * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose
                ? Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[300]!
                : clr,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose ? Colors.transparent : clr,
        ),
        child: Center(
          child: Text(
            label,
            style: isClose
                ? titleStyle
                : titleStyle.copyWith(
                    color: Colors.white,
                  ),
          ),
        ),
      ),
    );
  }

  showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(top: 4),
        width: SizeConfig.screenWidth,
        height: (SizeConfig.orientation == Orientation.landscape)
            ? (task.isCompleted == 1
                ? SizeConfig.screenHeight * 0.6
                : SizeConfig.screenHeight * 0.8)
            : (task.isCompleted == 1
                ? SizeConfig.screenHeight * 0.30
                : SizeConfig.screenHeight * 0.39),
        color: Get.isDarkMode ? darkHeaderClr : Colors.white,
        child: Column(
          children: [
            Flexible(
              child: Container(
                height: 6,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Get.isDarkMode ? Colors.grey[600]! : Colors.grey[300]!,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            task.isCompleted == 1
                ? Container()
                : _buildBottomSheet(
                    label: 'Task Completed',
                    onTap: () {
                      notifyHelper.cancelNotification(task);
                      _taskController.markTaskAsCompleted(task: task);
                      Get.back();
                    },
                    clr: primaryClr,
                  ),
            _buildBottomSheet(
              label: 'Delete Task',
              onTap: () {
                notifyHelper.cancelNotification(task);
                _taskController.deleteTask(task: task);
                Get.back();
              },
              clr: Colors.red[300]!,
            ),
            Divider(
              color: Get.isDarkMode ? Colors.grey : darkGreyClr,
            ),
            _buildBottomSheet(
              label: 'Cancel',
              onTap: () => Get.back(),
              clr: primaryClr,
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    ));
  }
}

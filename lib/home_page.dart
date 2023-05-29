import 'dart:async';
import 'dart:convert';

import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proiect/weather_page.dart';
import 'task_controller.dart';
import 'task.dart';
import 'notify_config.dart';
import 'task_add.dart';
import 'size_config.dart';
import 'theme.dart';
import 'custom_button.dart';
import 'package:intl/intl.dart';
import 'task_tile.dart';
import 'package:http/http.dart' as http;
import 'theme_services.dart';


class HomePage extends StatefulWidget {
  @override
  myHomePage createState() => myHomePage();
}

class myHomePage extends State<HomePage> {
  DateTime selectedDate = DateTime.parse(DateTime.now().toString());
  final myTaskController = Get.put(TaskController());
  late var notifyConfig;
  bool animate=false;
  double left=630;
  double top=900;
  Timer? myTimer;
  @override
  void initState() {
    super.initState();
    notifyConfig = NotifyConfig();
    notifyConfig.initializeNotification();
    notifyConfig.requestIOSPermissions();
    myTimer = Timer(Duration(milliseconds: 500), () {
      setState(() {
        animate=true;
        left=30;
        top=top/3;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: myAppBar(),
      backgroundColor: context.theme.backgroundColor,
      body: Column(
        children: [
          todayBar(),
          dateBar(),
          Text('Your tasks are: ',
              textAlign:  TextAlign.start,
            style:detailText),
          SizedBox(
            height: 12,
          ),
          showTasks(),
          addTaskBar()
        ],
      ),
    );
  }

  dateBar() {
    return Container(
      margin: EdgeInsets.only(bottom: 10, left: 20),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20)
        ),
        child: DatePicker(
          DateTime.now(),
          height: 100.0,
          width: 80,
          initialSelectedDate: DateTime.now(),
          selectionColor: primaryColor,
          selectedTextColor: Colors.white,
          dateTextStyle: GoogleFonts.lato(
            textStyle: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          dayTextStyle: GoogleFonts.lato(
            textStyle: TextStyle(
              fontSize: 16.0,
              color: Colors.grey,
            ),
          ),
          monthTextStyle: GoogleFonts.lato(
            textStyle: TextStyle(
              fontSize: 10.0,
              color: Colors.grey,
            ),
          ),

          onDateChange: (date) {
            setState(
                  () {
                selectedDate = date;
              },
            );
          },
        ),
      ),
    );
  }

  todayBar() {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Today is:', style: detailText),
              SizedBox(height: 10),
            ],
          ),
          Text(
            DateFormat.yMMMMd().format(DateTime.now()),
            style: detailText,
          ),
        ],
      ),
    );
  }

  addTaskBar() {
    List<Task> previousTasks = myTaskController.taskList
        .where((task) =>
    task.date != DateFormat.yMd().format(selectedDate) &&
        task.isCompleted == 0)
        .toList();

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomButton(
            label: "View previous tasks",
            onTap: () {
              _showPreviousTasks();
            },
          ),
          CustomButton(
            label: "Add new task",
            onTap: () async {
              await Get.to(TaskAdd());
              myTaskController.getTasks();
            },
          ),
        ],
      ),
    );
  }


  _showPreviousTasks() {
    List<Task> previousTasks = myTaskController.taskList
        .where((task) =>
    task.date != DateFormat.yMd().format(selectedDate) &&
        task.isCompleted == 0)
        .toList();

    if (previousTasks.isEmpty) {
      Get.bottomSheet(
        Container(
          child: Center(
            child: Text(
              'No previous unfinished tasks',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      );
    } else {
      Get.bottomSheet(
        Container(
          child: ListView.builder(
            itemCount: previousTasks.length,
            itemBuilder: (context, index) {
              Task task = previousTasks[index];
              return ListTile(
                title: Text(task.title ?? ''),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(task.description ?? ''),
                    Text(task.date ?? ''),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Delete Task'),
                        content: Text('Are you sure you want to delete this task?'),
                        actions: [
                          TextButton(
                            child: Text('Cancel'),
                            onPressed: () => Navigator.pop(context),
                          ),
                          TextButton(
                            child: Text('Delete'),
                            onPressed: () {
                              myTaskController.deleteTask(task);
                              Navigator.pop(context);
                            },
                          ),
                        ],
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



  myAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: () {
          ThemeService().switchTheme();
          notifyConfig.displayNotification(
            title: "Bunny Tasks",
            body: Get.isDarkMode
                ? "Light theme activated."
                : "Dark theme activated",
          );
        },
        child: Icon(
            Get.isDarkMode ? Icons.wb_sunny : Icons.shield_moon,
            color: Get.isDarkMode ? Colors.white : darkGrey),
      ),
      actions: [
        GestureDetector(
          onTap: () async {
            if (await _checkLocationPermission()) {
              _getCurrentWeather();
            } else {
              showDialog(
                context: context,
                builder: (context) =>
                    AlertDialog(
                      title: Text('Location Access Denied'),
                      content: Text(
                          'Please enable location access to view weather.'),
                      actions: [
                        TextButton(
                          child: Text('OK'),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
              );
            }
          },
          child: CircleAvatar(
            radius: 16,
            backgroundImage: AssetImage("images/weather.png"),
          ),
        ),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }

  Future<bool> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  void _getCurrentWeather() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    double latitude = position.latitude;
    double longitude = position.longitude;

    String apiKey = 'PUT YOUR OWN API KEY';
    String apiUrl = 'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey';
    var response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var weatherData = jsonDecode(response.body);

      String city = weatherData['name'];
      double temperature = weatherData['main']['temp'] - 273.15;
      String weatherMain = weatherData['weather'][0]['main'];
      String description = weatherData['weather'][0]['description'];

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              WeatherPage(city: city,
                  temperature: temperature,
                  weatherMain: weatherMain,
                  description: description),
        ),
      );
    } else {
      print('Failed to get weather data. Error code: ${response.statusCode}');
    }
  }

  showTasks() {
    return Expanded(
      child: Obx(() {
        if (myTaskController.taskList.isEmpty) {
          return _noTaskMsg();
        } else
          return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: myTaskController.taskList.length,
              itemBuilder: (context, index) {
                Task task = myTaskController.taskList[index];
                if (task.repeat == 'Daily') {

                  var hour= task.startTime.toString().split(":")[0];
                  var minutes = task.startTime.toString().split(":")[1];
                  debugPrint("My time is "+hour);
                  debugPrint("My minute is "+minutes);
                  DateTime date= DateFormat.jm().parse(task.startTime!);
                  var myTime = DateFormat("HH:mm").format(date);
                  notifyConfig.scheduledNotification(int.parse(myTime.toString().split(":")[0]),
                      int.parse(myTime.toString().split(":")[1]), task);

                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 300),
                    child: SlideAnimation(
                      horizontalOffset: 300.0,
                      child: FadeInAnimation(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  showBottomSheet(context, task);
                                },
                                child: TaskTile(task)),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                if (task.date == DateFormat.yMd().format(selectedDate)) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 300),
                    child: SlideAnimation(
                      horizontalOffset: 300.0,
                      child: FadeInAnimation(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                                onTap: () {

                                  showBottomSheet(context, task);
                                },
                                child: TaskTile(task)),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              });
      }),
    );
  }

  showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(top: 4),
        height: task.isCompleted == 1
            ? SizeConfig.screenHeight * 0.24
            : SizeConfig.screenHeight * 0.32,
        width: SizeConfig.screenWidth,
        color: Get.isDarkMode ? headerColor : Colors.white,
        child: Column(children: [
          Container(
            height: 6,
            width: 120,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300]),
          ), SizedBox(
          height: 40,),
          _buildBottomSheetButton(
              label: "Delete Task",
              onTap: () {
                myTaskController.deleteTask(task);
                Get.back();
              },
              clr: Colors.red[300]),
          SizedBox(
            height: 20,
          ),
          _buildBottomSheetButton(
              label: "Close",
              onTap: () {
                Get.back();
              },
              isClose: true),
          SizedBox(
            height: 5,
          ),
        ]),
      ),
    );
  }

  _buildBottomSheetButton(
      {required String label, Function? onTap, Color? clr, bool isClose = false}) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: SizeConfig.screenWidth! * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose
                ? Get.isDarkMode
                ? Colors.grey[600]!
                : Colors.grey[300]!
                : clr!,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose ? Colors.transparent : clr,
        ),
        child: Center(
            child: Text(
              label,
              style: isClose
                  ? titleText
                  : titleText.copyWith(color: Colors.white),
            )),
      ),
    );
  }

  _noTaskMsg() {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: Duration(milliseconds: 300),
          left: 0,
          top: 0,
          right: 0,
          bottom: 0,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "images/rabbit.png",
                  height: 70,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 20,
                  ),
                  child: Text(
                    "Become productive today! :D",
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'task_controller.dart';
import 'task.dart';
import 'theme.dart';
import 'custom_button.dart';
import 'custom_field.dart';
import 'package:intl/intl.dart';

class TaskAdd extends StatefulWidget {
  @override
  _TaskAddState createState() => _TaskAddState();
}

class _TaskAddState extends State<TaskAdd> {
  final TaskController myTaskController = Get.find<TaskController>();

  final TextEditingController myTitleController = TextEditingController();
  final TextEditingController myDescriptionController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  String? myStartTime = DateFormat('hh:mm a').format(DateTime.now()).toString();

  String? myEndTime = "5:00 PM";
  int mySelectedColor = 0;

  int myReminder = 5;
  List<int> remindList = [
    5,
    10,
    15,
    20,
  ];

  String? myRepeat = 'None';
  List<String> repeatList = [
    'None',
    'Daily',
    'Weekly',
    'Monthly',
  ];

  @override
  Widget build(BuildContext context) {
    print(" starttime " + myStartTime!);
    final time_now = new DateTime.now();
    final date_time = DateTime(time_now.year, time_now.month, time_now.day, time_now.minute, time_now.second);
    final format = DateFormat.jm();
    print(format.format(date_time));
    print("add Task date: " + DateFormat.yMd().format(selectedDate));
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: customAppBar(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Create your task",
                style: headerText,
              ),
              SizedBox(
                height: 8,
              ),
              InputField(
                title: "Title",
                hint: "Add a title",
                controller: myTitleController,
              ),
              InputField(
                  title: "Description",
                  hint: "Add a description",
                  controller: myDescriptionController),
              InputField(
                title: "Date",
                hint: DateFormat.yMd().format(selectedDate),
                widget: IconButton(
                  icon: (Icon(
                    Icons.calendar_month_sharp,
                    color: Colors.grey,
                  )),
                  onPressed: () {
                    getDate();
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: "Start Time",
                      hint: myStartTime,
                      widget: IconButton(
                        icon: (Icon(
                          Icons.alarm,
                          color: Colors.grey,
                        )),
                        onPressed: () {
                          getTime(isStartTime: true);
                          setState(() {
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: InputField(
                      title: "End Time",
                      hint: myEndTime,
                      widget: IconButton(
                        icon: (Icon(
                          Icons.alarm,
                          color: Colors.grey,
                        )),
                        onPressed: () {
                          getTime(isStartTime: false);
                        },
                      ),
                    ),
                  )
                ],
              ),
              InputField(
                title: "Reminder",
                hint: "$myReminder minutes early",
                widget: Row(
                  children: [
                    DropdownButton<String>(
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey,
                        ),
                        iconSize: 30,
                        elevation: 5,
                        style: smallTitle,
                        underline: Container(height: 0),
                        onChanged: (String? newValue) {
                          setState(() {
                            myReminder = int.parse(newValue!);
                          });
                        },
                        items: remindList
                            .map<DropdownMenuItem<String>>((int value) {
                          return DropdownMenuItem<String>(
                            value: value.toString(),
                            child: Text(value.toString()),
                          );
                        }).toList()),
                    SizedBox(width: 6),
                  ],
                ),
              ),
              InputField(
                title: "Repeat task?",
                hint: myRepeat,
                widget: Row(
                  children: [
                    Container(

                      child: DropdownButton<String>(
                          dropdownColor: Colors.blueGrey,
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey,
                          ),
                          iconSize: 32,
                          elevation: 4,
                          style: smallTitle,
                          underline: Container(height: 6, ),
                          onChanged: (String? newValue) {
                            setState(() {
                              myRepeat = newValue;
                            });
                          },
                          items: repeatList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: TextStyle(color:Colors.white),),
                            );
                          }).toList()),
                    ),
                    SizedBox(width: 6),
                  ],
                ),
              ),
              SizedBox(
                height: 18.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  colorTags(),
                  CustomButton(
                    label: "Add Task",
                    onTap: () {
                      inputValidation();
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 30.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  inputValidation() {
    if (myTitleController.text.isNotEmpty && myDescriptionController.text.isNotEmpty) {
      addTaskDb();
      Get.back();
    } else if (myTitleController.text.isEmpty || myDescriptionController.text.isEmpty) {
      Get.snackbar(
        "You missed a field",
        "All fields are required.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.pink[100],
      );
    } else {
      print("Error");
    }
  }


  addTaskDb() async {
    await myTaskController.addTask(
      task: Task(
        description: myDescriptionController.text,
        title: myTitleController.text,
        date: DateFormat.yMd().format(selectedDate),
        startTime: myStartTime,
        endTime: myEndTime,
        remind: myReminder,
        repeat: myRepeat,
        color: mySelectedColor,
        isCompleted: 0,
      ),
    );
  }

  colorTags() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "Color",
        style: titleText,
      ),
      SizedBox(
        height: 8,
      ),
      Wrap(
        children: List<Widget>.generate(
          3,
              (int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  mySelectedColor = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: index == 0
                      ? primaryColor
                      : index == 1
                      ? myRed
                      : myMint,
                  child: index == mySelectedColor
                      ? Center(
                    child: Icon(
                      Icons.done,
                      color: Colors.white,
                      size: 18,
                    ),
                  )
                      : Container(),
                ),
              ),
            );
          },
        ).toList(),
      ),
    ]);
  }

  customAppBar() {
    return AppBar(
        elevation: 0,
        backgroundColor: context.theme.backgroundColor,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back_ios, size: 24, color: primaryColor),
        ),
        actions: [
          SizedBox(
            width: 20,
          ),
        ]);
  }
  double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;

  getTime({required bool isStartTime}) async {
    var _pickedTime = await timePick();
    print(_pickedTime.format(context));
    String? _formatedTime = _pickedTime.format(context);
    print(_formatedTime);
    if (_pickedTime == null)
      print("time canceld");
    else if (isStartTime)
      setState(() {
        myStartTime = _formatedTime;
      });
    else if (!isStartTime) {
      setState(() {
        myEndTime = _formatedTime;
      });
    }
  }

  timePick() async {
    return showTimePicker(
      initialTime: TimeOfDay(
          hour: int.parse(myStartTime!.split(":")[0]),
          minute: int.parse(myStartTime!.split(":")[1].split(" ")[0])),
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
    );
  }

  getDate() async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }
}
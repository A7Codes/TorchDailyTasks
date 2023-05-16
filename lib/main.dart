import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:torchdailytasks/task.dart';
import 'package:provider/provider.dart';
import 'Dialgos/CredentialsDialog.dart';
import 'Dialgos/EmailDialog.dart';
import 'Providers/MailData.dart';
import 'Providers/TaskData.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => TaskData()),
      ChangeNotifierProvider(create: (context) => MailData()),
    ],
    child: const MyApp(),
  ));
  doWhenWindowReady(() {
    final win = appWindow;
    const initialSize = Size(1920, 1080);
    win.minSize = initialSize;
    win.size = initialSize;
    win.alignment = Alignment.center;
    win.title = "TORCH Daily Tasks";
    win.show();
  });
}

//UI

const borderColor = Color(0xFF805306);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: WindowBorder(
          color: borderColor,
          width: 1,
          child: Row(
            children: const [Content()],
          ),
        ),
      ),
    );
  }
}

const backgroundStartColor = Color.fromARGB(255, 255, 255, 255);
const backgroundEndColor = Color.fromARGB(255, 255, 255, 255);

class Content extends StatelessWidget {
  const Content({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [backgroundStartColor, backgroundEndColor],
              stops: [0.0, 1.0]),
        ),
        child: Column(children: [
          WindowTitleBarBox(
            child: Row(
              children: [Expanded(child: MoveWindow()), const WindowButtons()],
            ),
          ),
          const Home(),
        ]),
      ),
    );
  }
}

final buttonColors = WindowButtonColors(
    iconNormal: const Color.fromARGB(255, 0, 0, 0),
    mouseOver: const Color.fromARGB(255, 0, 0, 0),
    mouseDown: const Color.fromARGB(255, 0, 0, 0),
    iconMouseOver: const Color.fromARGB(255, 255, 255, 255),
    iconMouseDown: const Color.fromARGB(255, 255, 255, 255));

final closeButtonColors = WindowButtonColors(
    mouseOver: const Color(0xFFD32F2F),
    mouseDown: const Color(0xFFB71C1C),
    iconNormal: const Color.fromARGB(255, 0, 0, 0),
    iconMouseOver: Colors.white);

class WindowButtons extends StatefulWidget {
  const WindowButtons({Key? key}) : super(key: key);

  @override
  _WindowButtonsState createState() => _WindowButtonsState();
}

class _WindowButtonsState extends State<WindowButtons> {
  void maximizeOrRestore() {
    setState(() {
      appWindow.maximizeOrRestore();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(colors: buttonColors),
        appWindow.isMaximized
            ? RestoreWindowButton(
                colors: buttonColors,
                onPressed: maximizeOrRestore,
              )
            : MaximizeWindowButton(
                colors: buttonColors,
                onPressed: maximizeOrRestore,
              ),
        CloseWindowButton(colors: closeButtonColors),
      ],
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});
  //Variables
  @override
  Widget build(BuildContext context) {
    TextStyle style1 = const TextStyle(
        fontSize: 34, fontFamily: "Cairo", fontWeight: FontWeight.bold);
    TextStyle style2 = const TextStyle(
        fontSize: 24, fontFamily: "Cairo", fontWeight: FontWeight.bold);

    final TextEditingController taskNumberController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController statusController = TextEditingController();
    final TextEditingController dateController = TextEditingController();

    //Functions
    void ClearPrefsTapped(BuildContext context) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("un", "");
      prefs.setString("pa", "");
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.95,
      child: Column(
        children: [
          //Header
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
              child: Center(child: Text("TORCH Daily Tasks", style: style1))),

          //Data Entery
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: taskNumberController,
                    decoration: const InputDecoration(hintText: "Task No."),
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                SizedBox(
                  width: 400,
                  child: TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(hintText: "Description"),
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: statusController,
                    decoration: const InputDecoration(hintText: "Status"),
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: dateController,
                    decoration: const InputDecoration(hintText: "Date"),
                  ),
                ),
                const SizedBox(
                  width: 200,
                ),
                ElevatedButton(
                  onPressed: () {
                    Provider.of<TaskData>(context, listen: false).addTask(
                        taskNumberController.text,
                        descriptionController.text,
                        statusController.text,
                        dateController.text);
                    taskNumberController.clear();
                    descriptionController.clear();
                    statusController.clear();
                    dateController.clear();
                  },
                  child: const Text("ADD"),
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
          ),
          //Table View
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: TasksTable(),
          ),
          //Bottom Controls
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Send email button
                ElevatedButton(
                  onPressed: () async {
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    String? un = "";
                    un = prefs.getString("un");
                    String? pa = "";
                    pa = prefs.getString("pa");
                    if (un != "" && pa != "" && un != null && pa != null) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const EmailDialog();
                        },
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CredentialsAlertDialog();
                        },
                      );
                    }
                  },
                  child: const Text('Send Tasks via Email'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                    onPressed: () {
                      Provider.of<TaskData>(context, listen: false)
                          .clearTasks();
                    },
                    child: const Text('Clear Data')),
                const SizedBox(width: 10),
                ElevatedButton(
                    onPressed: () {
                      ClearPrefsTapped(context);
                    },
                    child: const Text("Clear Prefrences")),
                const SizedBox(width: 10),
                ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CredentialsAlertDialog();
                        },
                      );
                    },
                    child: const Text("Setup Prefrences")),
              ],
            ),
          )
        ],
      ),
    );
  }
}

//Tasks
class TasksTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tasks = Provider.of<TaskData>(context).tasks;
    TextStyle style1 = const TextStyle(fontFamily: 'cairo', fontSize: 24);
    TextStyle style2 = const TextStyle(fontFamily: 'cairo', fontSize: 20);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          columns: [
            DataColumn(label: Text('Task No.', style: style1)),
            DataColumn(label: Text('Description', style: style1)),
            DataColumn(label: Text('Status', style: style1)),
            DataColumn(label: Text('Date', style: style1)),
          ],
          rows: tasks.map((task) {
            return DataRow(cells: [
              DataCell(Text(task.taskNumber, style: style2)),
              DataCell(Text(task.description, style: style2)),
              DataCell(Text(task.status, style: style2)),
              DataCell(Text(task.date, style: style2)),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}

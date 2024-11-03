import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remainders/widgets/item.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(const MyApp());
}

// Themes
ThemeData light = ThemeData(
    textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
    hintColor: const Color(0xFF0C79FE),
    highlightColor: Colors.white,
    primaryColor: const Color(0xFFE2E2E7),
    secondaryHeaderColor: const Color(0xFF808080),
    scaffoldBackgroundColor: const Color(0xFFF2F2F7),
    useMaterial3: true,
    focusColor: Colors.black);
ThemeData dark = ThemeData(
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
    hintColor: const Color(0xFF0C79FE),
    secondaryHeaderColor: const Color(0xFF808083),
    primaryColor: const Color(0xFF1B1B1C),
    scaffoldBackgroundColor: Colors.black,
    useMaterial3: true,
    focusColor: Colors.white);

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  final ThemeMode _theme = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Remainders',
      theme: light,
      darkTheme: dark,
      themeMode: _theme,
      home: const Remainders(),
    );
  }
}

class Remainder {
  late String id;
  String title;
  bool completed;

  Remainder({required this.title})
      : id = Uuid().v4(),
        completed = false;
}

class Remainders extends StatefulWidget {
  const Remainders({super.key});

  @override
  State<Remainders> createState() => _RemaindersState();
}

class _RemaindersState extends State<Remainders> {
  List<Remainder> remainders = [
    Remainder(title: "Grocery shopping for the week"),
    Remainder(title: "Finish the report for work"),
    Remainder(title: "Call Mom to check in"),
    Remainder(title: "Exercise for at least 30 minutes"),
    Remainder(title: "Read 20 pages of a new book"),
    Remainder(title: "Schedule a dentist appointment"),
    Remainder(title: "Clean and organize the workspace"),
    Remainder(title: "Plan next week's meals"),
    Remainder(title: "Watch the latest episode of my favorite show"),
    Remainder(title: "Meditate for 10 minutes"),
  ];

  final TextEditingController _title = TextEditingController();
  final TextEditingController _searched = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    _searched.addListener(
      () {
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    _searched.dispose();
    _searchFocusNode.unfocus();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Set the status bar and navigation bar colors based on the current theme
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Theme.of(context).scaffoldBackgroundColor,
      statusBarIconBrightness: Theme.of(context).brightness == Brightness.light
          ? Brightness.dark // For light theme, use dark icons
          : Brightness.light, // For dark theme, use light icons
      systemNavigationBarColor:
          Theme.of(context).scaffoldBackgroundColor, // Navigation bar color
      systemNavigationBarIconBrightness:
          Theme.of(context).brightness == Brightness.light
              ? Brightness.dark // Dark icons for light theme
              : Brightness.light, // Light icons for dark theme
    ));
  }

  void addToDo(String value) {
    setState(() {
      remainders.add(Remainder(title: value));
    });
  }

  void deleteToDo(Remainder re) {
    setState(() {
      remainders.remove(re);
    });
  }

  void toggleToDo(String id) {
    setState(() {
      for (var remainder in remainders) {
        if (remainder.id == id) {
          remainder.completed = !remainder.completed;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              searchBar(),
              const SizedBox(
                height: 5,
              ),
              Expanded(
                child: ListView(
                  children: remainders
                      .where((e) =>
                          _searched.text.isEmpty ||
                          e.title
                              .toLowerCase()
                              .contains(_searched.text.toLowerCase()))
                      .map((e) => Dismissible(
                            key: Key(e.id),
                            background: Container(
                              decoration: BoxDecoration(
                                  color: const Color(0xFFFF382B),
                                  borderRadius: BorderRadius.circular(10)),
                              // Background color when swiping
                              alignment: AlignmentDirectional.centerEnd,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Icon(
                                  CupertinoIcons.delete_solid,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {
                              deleteToDo(e);
                            },
                            child: Item(remainder: e, toggle: toggleToDo),
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height *
                            0.9, // Set max height to 90% of screen height
                      ),
                      isDismissible: true,
                      enableDrag: true,
                      elevation: 30,
                      builder: (BuildContext context) => bottomSheet());
                },
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    Icon(
                      Icons.add_circle_rounded,
                      size: 30,
                      color: Theme.of(context).hintColor,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "To-do",
                      style: TextStyle(
                          color: Theme.of(context).hintColor, fontSize: 18),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // bottomsheet
  Widget bottomSheet() {
    final FocusNode _focusNode = FocusNode();
    return StatefulBuilder(builder: (BuildContext context, StateSetter setter) {
      return Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          width: double.infinity,
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    FocusScope.of(context).unfocus();
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Theme.of(context).hintColor),
                  ),
                ),
                const Text("New To-Do"),
                GestureDetector(
                  onTap: () {
                    if (_title.text.isNotEmpty) {
                      addToDo(_title.text);
                      _title.text = '';
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    "Add",
                    style: TextStyle(
                        color: _title.text.isNotEmpty
                            ? Theme.of(context).hintColor
                            : Theme.of(context).highlightColor),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Theme.of(context)
                      .highlightColor, // Light background color
                  borderRadius:
                      BorderRadius.circular(12), // More rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(
                          0, 2), // Subtle shadow to mimic iOS style
                    ),
                  ],
                  border: _focusNode.hasFocus
                      ? Border.all(color: Theme.of(context).hintColor, width: 3)
                      : Border.all(color: Colors.transparent, width: 3)),
              child: TextField(
                focusNode: _focusNode,
                cursorColor: Theme.of(context).hintColor,
                cursorWidth: 2,
                controller: _title,
                onSubmitted: (String value) {
                  addToDo(value);
                  _title.clear();
                },

                style: TextStyle(
                  color: Theme.of(context).focusColor, // Dark text color
                  fontSize: 16,
                ),
                maxLines:
                    null, // Allows the TextField to expand vertically as needed
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: "Title",
                  border: InputBorder.none, // No visible border
                  hintStyle: TextStyle(
                    color: Colors.grey[500], // Softer hint color
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                ),
                onChanged: (String value) {
                  setter(() {}); // Rebuilds bottomSheet to update color
                },
              ),
            )
          ]));
    });
  }

  Widget searchBar() {
    return Container(
      height: 40,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: Theme.of(context).secondaryHeaderColor,
            size: 30,
          ),
          const SizedBox(
            width: 7,
          ),
          Expanded(
            flex: 1,
            child: TextField(
              focusNode: _searchFocusNode,
              autofocus: false,
              controller: _searched,
              style: TextStyle(
                color: Theme.of(context).secondaryHeaderColor,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                hintStyle: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontSize: 14,
                ),
                hintText: 'Search',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          )
        ],
      ),
    );
  }
}

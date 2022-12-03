import 'package:flutter/material.dart';
import 'package:hive_demo/boxes.dart';
import 'package:hive_demo/model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'create.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(DetailsAdapter());
  await Hive.openBox<Details>('details');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hive Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    Hive.box('details').close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateEntry(
                  editMode: false,
                  detailsValues: Details(
                    '',
                    '',
                    '',
                    0,
                  ),
                ),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: SafeArea(
          child: ValueListenableBuilder<Box<Details>>(
            valueListenable: Boxes.getDetailsBox().listenable(),
            builder: (context, box, _) {
              final detailsKeys = box.keys.toList().cast<int>();
              final detailsValues = box.values.toList().cast<Details>();
              return ListView.builder(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                reverse: true,
                itemCount: detailsValues.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                commonRichTextWidget(
                                    label: 'ID number',
                                    value: detailsKeys[index].toString()),
                                commonRichTextWidget(
                                    label: 'First name',
                                    value: detailsValues[index].firstName),
                                commonRichTextWidget(
                                    label: 'Last name',
                                    value: detailsValues[index].lastName),
                                commonRichTextWidget(
                                    label: 'Age',
                                    value: detailsValues[index].age.toString()),
                                commonRichTextWidget(
                                    label: 'Gender',
                                    value: detailsValues[index].gender),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CreateEntry(
                                    editMode: true,
                                    detailsValues: detailsValues[index],
                                  ),
                                ),
                              );
                            },
                            child: const Icon(Icons.edit),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            onTap: () => detailsValues[index].delete(),
                            child: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget commonRichTextWidget({
    required String label,
    required String value,
  }) {
    return RichText(
      overflow: TextOverflow.ellipsis,
      softWrap: true,
      maxLines: 1,
      text: TextSpan(
        text: '$label: ',
        style: Theme.of(context).textTheme.bodyMedium,
        children: <TextSpan>[
          TextSpan(
            text: value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

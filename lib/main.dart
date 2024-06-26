import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class SaveDataService {
  setData(String data) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setStringList("userData", [data]);
  }

  Future<List<String>> getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String> _str = sharedPreferences.getStringList("userData") ?? [];

    return _str;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('User Data'),
        ),
        body: MyForm(),
      ),
    );
  }
}

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  List<String> _str = [];

  DateFormat dateFormat = DateFormat("dd MMM, yy");

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      SaveDataService().setData(
          "User Name: ${_textController.text} , Date: ${_dateController.text}");
      _str = await SaveDataService().getData();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: TextFormField(
                controller: _textController,
                decoration: InputDecoration(labelText: 'Enter text'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Name';
                  }
                  return null;
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: TextFormField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Select date'),
                onTap: () async {
                  DateTime? _dateTime = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2012),
                      lastDate: DateTime(2024));
                  _dateController.text =
                      dateFormat.format(_dateTime!).toString();
                },
                /* validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Date';
                  }
                  return null;
                },*/
                readOnly: true,
              ),
            ),
            Expanded(
              flex: 1,
              child: ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ),
            Expanded(
                flex: 7,
                child: ListView.builder(
                    itemCount: _str.length,
                    itemBuilder: (context, index) {
                      return Text(_str[index]);
                    }))
          ],
        ),
      ),
    );
  }
}

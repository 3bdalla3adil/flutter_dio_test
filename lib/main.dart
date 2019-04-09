import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:path/path.dart' show basename;
import 'package:image_picker/image_picker.dart' show ImagePicker, ImageSource;
import 'package:dio/dio.dart'
  show Dio, DioError, Response, FormData, UploadFileInfo, LogInterceptor;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String name = 'Dio File Upload Test';

    return MaterialApp(
      title: name,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: name),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String endPoint;
  File myFile;
  TextEditingController nameController = TextEditingController();
  Dio dio = Dio();


  @override
  void initState() {
    super.initState();

    dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  }

  takeImage() async {
    myFile = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {});
  }

  uploadData() async {
    try {
      FormData data = FormData.from({
        'name': nameController.text,
        'image': UploadFileInfo(myFile, basename(myFile.path))
      });

      Response response = await dio.post(
        'http://192.168.1.10:8000/api/v1/catalog/stuff/',
        data: data
      );

      print('done');
      print(response.data);
    } on DioError catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Text('Name:'),
            title: TextField(
              controller: nameController,
            ),
          ),

          ListTile(
            title: Text(
              myFile != null ? basename(myFile.path) : ''
            ),
            trailing: RaisedButton.icon(
              label: Text('Image'),
              icon: Icon(Icons.image),
              onPressed: takeImage
            ),
          ),

          RaisedButton(
            child: Text('Upload'),
            onPressed: uploadData,
          )

        ],
      ),
    );
  }
}

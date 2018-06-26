import 'package:flutter/material.dart';

import 'package:rest_test/CARPCore.dart';

void main() {
  runApp(new MaterialApp(
    home: new HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  var authManager = new AuthManager();
  var datauploadManager = new DataUploadManager();

  void callLoginFromMain() {
    var mockCredentials = getMockCredentials(),
    username = mockCredentials[0],
    password = mockCredentials[1];

    authManager.login(username, password);
  }

  void callUploadDataFromMain() {
    var token = getMockToken();
    var mockData = getMockData();
    datauploadManager.uploadData(token, mockData);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new RaisedButton(
          child: new Text("Get data"),
          onPressed: callLoginFromMain,
        ),
      ),
    );
  }

  getMockData() {
    var mockData = {
    "carp_header": {
      "study_id": "flutter123",
      "device_role_name": "Flutter",
      "trigger_id": "Task123",
      "user_id": "thomas123",
      "data_format": "org.openmhealth",
      "upload_time": "312312312321",
      "start_time": "12312312312",
      "end_time": "312312312121"
    },
    "body": {
      "header": {
        "_id": "12312312-1231-1231-1231-426655440000",
        "creationDateTime": "2018-02-05T07:25:00Z",
        "schemaId": {
          "namespace": "omh",
          "name": "physical-activity",
          "version": "1.0",
          "additionalProperties": {}
        },
        "acquisitionProvenance": {
          "sourceName": "RunKeeper",
          "modality": "sensed",
          "additionalProperties": {}
        },
        "additionalProperties": {}
      },
      "body": {
        "effective_time_frame": {"date_time": "2018-02-05T07:25:00Z"},
        "blood_glucose": {"unit": "mg/dL", "value": 95},
        "body_mass_index": {"value": 16, "unit": "kg/m2"}
      }
    }
  };

  return mockData;
  }

  getMockToken() {
    String token = "848e438b-c72c-410b-ac0a-7b008735cf14";
    return token;
  }

  getMockCredentials() {
    var mockCredentials = ["thomas", "pass"];
    return mockCredentials;
  }
}




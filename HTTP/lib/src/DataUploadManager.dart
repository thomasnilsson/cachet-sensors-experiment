import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DataUploadManager {

  // Upload data function
  Future<String> uploadData(token, sampleData) async {
    String url =
        "https://sandbox.carp.cachet.dk/data-service/api/dataPoint?access_token=$token";
    var response = await http.post(Uri.encodeFull(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(sampleData));
    print(response.body);

    return "0";
  }
}

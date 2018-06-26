import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProtocolManager {

  // Upload data function
  Future<String> fetchProtocol(token) async {
    String url =
        "https://sandbox.carp.cachet.dk/data-service/api/dataPoint?access_token=$token";
    var response = await http.get(Uri.encodeFull(url),
        headers: {"Content-Type": "application/json"});
    print(response.body);

    return "0";
  }
}

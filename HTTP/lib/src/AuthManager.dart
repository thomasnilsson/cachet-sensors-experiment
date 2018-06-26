import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthManager {

    Future<String> login(username, password) async {
    var clientSecret = "webuisecret";
    var clientID = "webui";
    var authHeaderUTF8 = utf8.encode("$clientID:$clientSecret");
    var authHeaderBase64 = base64.encode(authHeaderUTF8);

    var loginHeader = {
      "Authorization": "Basic $authHeaderBase64",
      "Content-Type": "application/x-www-form-urlencoded",
      "Accept": "application/json"
    };

    var loginBody = {
      "client_id": "$clientID",
      "client_secret": "$clientSecret",
      "grant_type": "password",
      "scope": "read",
      "username": "$username",
      "password": "$password"
    };

    var loginUrl = "https://sandbox.carp.cachet.dk/auth-service/auth/oauth/token";

     var response = await http.post(
      Uri.encodeFull(loginUrl),
      headers: loginHeader,
      body: loginBody,
    );

    print(response.body);

    return "0";
  }
}

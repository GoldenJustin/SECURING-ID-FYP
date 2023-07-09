import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServices{

  final String url = 'http://192.168.1.161:8000';

  ///api used for POST request i.e (logon/logout)
  authenticationPostRequest(data, apiUrl, {context}) async {

    final fullUrl = url + apiUrl;
    try{
      final response = await http.post(
          Uri.parse(fullUrl),
          headers: _setHeaders(),
          body: jsonEncode(data)
      );

      return evaluatedResponseData(response, context);

    } catch (error) {
      print('>>>>>>>Error occurred while logging in: $error');
    }

  }

  ///api used for GET request
  authenticatedGetRequest(apiUrl, {context}) async {
    // await getToken(context);
    var fullUrl = url + apiUrl;
    try {
      var res = await http.get(Uri.parse(fullUrl), headers: {
        'Content-Type': 'application/json',
        'Vary': 'Accept'
      });
      return evaluatedResponseData(res, context);
    } catch (error) {
      print('>>>>>>>Error occurred while logging in: $error');
      return null;
    }
  }

  _setHeaders()=> {
    'Content-Type': 'application/json'

  };

  evaluatedResponseData(http.Response response, context) {

    if(response.statusCode == 200){
      print('--------------------YOUR REQUEST IS OKAY------------------------\n \n \n');
      print('${response.statusCode} CODE OK');
      print('\n \n \n-----------------------------------------------------------------');

      return response;
    }

  }




}


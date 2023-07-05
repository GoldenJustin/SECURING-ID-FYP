import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServices{

  final String url = 'http://192.168.1.161:8000';

  ///api used to sigin / out
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

  _setHeaders()=> {
'Content-Type': 'application/json'

};

  evaluatedResponseData(http.Response response, context) {

    if(response.statusCode == 200){
      print('--------------------SIGN/SIGN UP STATUS------------------------');
      print('${response.statusCode} CODE OK');
      print('--------------------SIGN/SIGN UP STATUS------------------------');

      return response;
    }

  }




  }



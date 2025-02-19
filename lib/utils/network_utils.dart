import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:stoneindia/contants.dart';
import 'package:stoneindia/widget/appcommon.dart';

Map<String, String> buildHeaderTokens() {
  Map<String, String> header = {
    HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
    HttpHeaders.cacheControlHeader: 'no-cache',
    HttpHeaders.acceptHeader: 'application/json; charset=utf-8',
  };

  log(jsonEncode(header));
  return header;
}

Uri buildBaseUrl(String endPoint) {
  Uri url = Uri.parse(endPoint);
  if (!endPoint.startsWith('http')) url = Uri.parse('$mBaseUrl$endPoint');

  log('URL: ${url.toString()}');

  return url;
}

Future<Response> buildHttpResponseFromSB(String endPoint,
    {HttpMethod method = HttpMethod.GET, Map? request}) async {
  if (await isNetworkAvailable()) {
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Basic aGFyc2hpdDplYXN5c3RvbmUxMjM='
    };
    Uri url = Uri.parse(endPoint);

    Response response;

    if (method == HttpMethod.POST) {
      log('Request: $request');

      response =
          await http.post(url, body: jsonEncode(request), headers: headers);
    } else if (method == HttpMethod.DELETE) {
      response = await delete(url, headers: headers);
    } else if (method == HttpMethod.PUT) {
      response = await put(url, body: jsonEncode(request), headers: headers);
    } else {
      response = await get(url, headers: headers);
    }

    log('Response ($method): ${response.statusCode} ${response.body}');

    return response;
  } else {
    throw errorInternetNotAvailable;
  }
}

Future<Response> buildHttpResponse(String endPoint,
    {HttpMethod method = HttpMethod.GET, Map? request}) async {
  if (await isNetworkAvailable()) {
    var headers = buildHeaderTokens();
    Uri url = buildBaseUrl(endPoint);

    Response response;

    if (method == HttpMethod.POST) {
      log('Request: $request');

      response =
          await http.post(url, body: jsonEncode(request), headers: headers);
    } else if (method == HttpMethod.DELETE) {
      response = await delete(url, headers: headers);
    } else if (method == HttpMethod.PUT) {
      response = await put(url, body: jsonEncode(request), headers: headers);
    } else {
      response = await get(url, headers: headers);
    }

    log('Response ($method): ${response.statusCode} ${response.body}');

    return response;
  } else {
    throw errorInternetNotAvailable;
  }
}

Future handleResponse(Response response) async {
  if (!await isNetworkAvailable()) {
    throw errorInternetNotAvailable;
  }
  if (response.statusCode == 401) {
    LiveStream().emit(tokenStream, true);
    throw const TokenException('Token Expired');
  }

  if (response.statusCode.isSuccessful()) {
    return jsonDecode(response.body);
  } else {
    try {
      var body = jsonDecode(response.body);
      throw parseHtmlString(body['message']);
    } on Exception catch (e) {
      log(e);
      throw errorSomethingWentWrong;
    }
  }
}

//region Common
enum HttpMethod { GET, POST, DELETE, PUT }

class TokenException implements Exception {
  final String message;

  const TokenException([this.message = ""]);

  @override
  String toString() => "FormatException: $message";
}
//endregion

Future<MultipartRequest> getMultiPartRequest(String endPoint) async {
  log('Url $mBaseUrl$endPoint');
  return http.MultipartRequest('POST', Uri.parse('$mBaseUrl$endPoint'));
}

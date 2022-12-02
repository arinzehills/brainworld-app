import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:brainworld/constants/api_utils_constants.dart';
import 'package:brainworld/constants/constant.dart';
import 'package:brainworld/models/models.dart';
import 'package:brainworld/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

typedef void OnDownloadProgressCallback(int receivedBytes, int totalBytes);
typedef void OnUploadProgressCallback(int sentBytes, int totalBytes);

class UploadService {
  final _logger = Logger();

  static bool trustSelfSigned = true;

  static HttpClient getHttpClient() {
    HttpClient httpClient = HttpClient()
      ..connectionTimeout = const Duration(seconds: 10)
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => trustSelfSigned);

    return httpClient;
  }

  static Future<String> fileUpload({
    required File file,
    required OnUploadProgressCallback onUploadProgress,
    required BookModel bookModel,
  }) async {
    final _logger = Logger();

    final url = '$generalUrl/upload/uploadBook';
    var user = await getuserFromStorage();
    final httpClient = getHttpClient();
    final request = await httpClient.postUrl(Uri.parse(url));
    try {
      var requestMultipart = http.MultipartRequest('POST', Uri.parse(url));
      var filemultipart = await http.MultipartFile.fromPath(
        'file',
        file.path,
      );
      int byteCount = 0;
      requestMultipart.fields['usersId'] = user.id;
      requestMultipart.headers['x-access-token'] = user.token!;
      requestMultipart.fields['category'] = bookModel.category!;
      requestMultipart.fields['filename'] = bookModel.filename!;
      requestMultipart.fields['createdAt'] = DateTime.now().toString();
      requestMultipart.files.add(filemultipart);
      var msStream = requestMultipart.finalize();
      var totalByteLength = requestMultipart.contentLength;
      request.contentLength = totalByteLength;
      Stream<List<int>> streamUpload = msStream.transform(
        // ignore: unnecessary_new
        new StreamTransformer.fromHandlers(
          handleData: (data, sink) {
            sink.add(data);
            byteCount += data.length;

            if (onUploadProgress != null) {
              onUploadProgress(byteCount, totalByteLength);
              // CALL STATUS CALLBACK;
            }
          },
          handleError: (error, stack, sink) {
            throw error;
          },
          handleDone: (sink) {
            sink.close();
            // UPLOAD DONE;
          },
        ),
      );

      await request.addStream(streamUpload);
      final httpResponse = await request.close();
      var statusCode = httpResponse.statusCode;
      var streamedResponse = await requestMultipart.send();

      var response = await http.Response.fromStream(streamedResponse);
      _logger.d(response.body);
      _logger.d(response.statusCode);
      if (statusCode ~/ 100 != 2) {
        throw Exception(
            'Error uploading file, Status code: ${httpResponse.statusCode}');
      } else {
        return await readResponseAsString(httpResponse);
      }
    } catch (e) {
      _logger.d(e.toString());
      throw Exception('Error uploading file, Status code: ${e.toString()}');
    }

    // if (statusCode ~/ 100 != 2) {
    //   throw Exception(
    //       'Error uploading file, Status code: ${httpResponse.statusCode}');
    // } else {
    // }
  }

  Future uploadToLocal(BookModel bookModel, File file) async {
    var user = await getuserFromStorage();
    var request = http.MultipartRequest(
        'POST', Uri.parse('$generalUrl/upload/uploadToLocalLibrary'));
    var filemultipart = await http.MultipartFile.fromPath(
      'file',
      file.path,
    );
    request.fields['usersId'] = user.id;
    request.headers['x-access-token'] = user.token!;
    request.fields['title'] = bookModel.title;
    request.fields['category'] = bookModel.category!;
    request.fields['filename'] = bookModel.filename!;
    request.fields['createdAt'] = DateTime.now().toString();
    request.files.add(filemultipart);
    var streamedResponse = await request.send();

    var response = await http.Response.fromStream(streamedResponse);
    _logger.d(response.body);
    // _logger.d(response.statusCode);
    return response;
  }

  Future uploadBook(BookModel bookModel, File file, imagePath) async {
    var user = await getuserFromStorage();
    var request = http.MultipartRequest(
        'POST', Uri.parse('$generalUrl/upload/uploadBook'));
    var imagemultipart = await http.MultipartFile.fromPath(
      'image',
      imagePath,
    );
    var filemultipart = await http.MultipartFile.fromPath(
      'file',
      file.path,
    );
    request.fields['usersId'] = user.id;
    request.headers['x-access-token'] = user.token!;
    request.fields['title'] = bookModel.title;
    request.fields['category'] = bookModel.category!;
    request.fields['price'] = bookModel.price;
    request.fields['filename'] = bookModel.filename!;
    request.fields['createdAt'] = DateTime.now().toString();
    request.files.add(imagemultipart);
    request.files.add(filemultipart);
    var streamedResponse = await request.send();

    var response = await http.Response.fromStream(streamedResponse);
    // _logger.d(response.body);
    // _logger.d(response.statusCode);
    return response;
  }

  Future getUserBooks() async {
    var user = await AuthService().getuserFromStorage();
    var data = {
      'token': user.token,
    };
    var response = await AuthService().postData(data, 'upload/getUserBooks');
    //var datar=jsonDecode(response);
    var responseData = json.decode(response.body);
    var postMap = responseData['books'];
    // _logger.d('responseData');
    _logger.d(responseData);
    List<BookModel> books = [];
    for (var data in postMap) {
      books.add(BookModel.fromJson(data));
      // postsController.allPost.add(books.fromJson(data));
    }

    // return books;
    return responseData;
  }

  Future getAllBooks() async {
    var user = await AuthService().getuserFromStorage();
    var data = {
      'token': user.token,
    };
    var response = await AuthService().postData(data, 'upload/getAllBooks');
    //var datar=jsonDecode(response);
    var responseData = json.decode(response.body);
    var postMap = responseData['books'];
    // _logger.d('responseData');
    // _logger.d(responseData);
    List<BookModel> books = [];
    for (var data in postMap) {
      books.add(BookModel.fromJson(data));
      // postsController.allPost.add(books.fromJson(data));
    }

    // return books;
    return responseData;
  }

  static Future<String> readResponseAsString(HttpClientResponse response) {
    var completer = Completer<String>();
    var contents = StringBuffer();
    response.transform(utf8.decoder).listen((String data) {
      contents.write(data);
    }, onDone: () => completer.complete(contents.toString()));
    return completer.future;
  }
}

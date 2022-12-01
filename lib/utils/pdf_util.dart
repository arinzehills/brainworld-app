import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class PdfUtil {
  static Future<File> loadNetwork(String url) async {
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;

    return _storeFile(url, bytes);
  }

  static Future<File> _storeFile(String url, List<int> bytes) async {
    final filename = basename(url);
    final dir = await getApplicationDocumentsDirectory();
    // final response = await Dio().get(url,
    //     options: Options(
    //       responseType: ResponseType.bytes,
    //       followRedirects: false,
    //       receiveTimeout: 0,
    //     ));
    final file = File('${dir.path}/$filename');
    // final raf = file.openSync(mode: FileMode.write);
    // raf.writeFromSync(response.data);
    // await raf.close();
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }
}

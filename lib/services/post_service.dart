import 'dart:convert';
import 'package:brainworld/constants/constant.dart';
import 'package:brainworld/controllers/post_controller.dart';
import 'package:brainworld/models/models.dart';
import 'package:brainworld/services/auth_service.dart';
import 'package:http/http.dart' as http;

class PostsService {
  // static final BuyService buyInstance= BuyService._init();
  // BuyService._init(

  // );
  PostsController postsController = PostsController();

  static final PostsService transactionInstance = PostsService._init();
  PostsService._init();

  //  Future<List<PostsModel>>
  Future<List<PostsModel>> getAllPosts() async {
    var user = await AuthService().getuserFromStorage();
    var data = {
      'token': user.token,
    };
    var response = await AuthService().postData(data, 'post/getAllPost');
    //var datar=jsonDecode(response);
    var responseData = json.decode(response.body);

    // var amount = responseData['total_amount'];
    // var units = responseData['total_units'];
    // var total_trx = responseData['total_transactions'];
    // var trx_list = responseData['transactions'];
    // var postsModel = PostsModel(caption: 'Hey');
    var postMap = responseData['posts'];
    List<PostsModel> postsModel = [];
    for (var data in postMap) {
      postsModel.add(PostsModel.fromJson(data));
      // postsController.allPost.add(PostsModel.fromJson(data));
    }

    return postsModel;
  }

  static addPost(PostsModel post) async {
    var user = await AuthService().getuserFromStorage();
    var data = {
      'token': user.token,
      'caption': post.caption,
      'title': post.title,
    };
    var request =
        http.MultipartRequest('POST', Uri.parse('$generalUrl/post/addPost'));
    var filemultipart;
    if (post.image != null) {
      var filemultipart = await http.MultipartFile.fromPath(
        'image',
        post.image!.path,
      );
      request.files.add(filemultipart);
    }
    request.fields['title'] = post.title!;
    request.fields['caption'] = post.caption!;
    request.headers['x-access-token'] = user.token!;
    request.fields['postedOn'] = DateTime.now().toString();
    // request.fields['postedOn'] = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 1).toString();

    var streamedResponse = await request.send();

    var response = await http.Response.fromStream(streamedResponse);

    // print(data);
    // var response = await AuthService().postData(data, 'post/addPost');
    // var responseData = json.decode(response.body);
    return response;
  }
}

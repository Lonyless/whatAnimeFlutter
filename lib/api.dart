import 'package:http/http.dart' as http;

class API {
  static Future getFacts() async {
    var url = "https://cat-fact.herokuapp.com/facts";
    return await http.get(url);
  }

  static Future getRandomFact() async {
    var url = "https://cat-fact.herokuapp.com/facts/random";
    return await http.get(url);
  }

  static Future getRandomPicture() async {
    var url = "https://api.thecatapi.com/v1/images/search";
    return await http.get(url);
  }
}

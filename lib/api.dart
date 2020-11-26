import 'package:http/http.dart' as http;

class API {
  static Future getPokemon() async {
    var url = "https://pokeapi.co/api/v2/pokemon?limit=100&offset=200";
    return await http.get(url);
  }
}

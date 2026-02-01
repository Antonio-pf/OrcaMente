import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class MotivationApi {
  static final _url = Uri.parse(
    'https://moraislucas.github.io/MeMotive/phrases.json',
  );

  static Future<String> fetchMotivationalPhrase() async {
    try {
      final response = await http.get(_url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        if (data.isEmpty) return 'Siga firme!';

        final random = Random();
        final randomIndex = random.nextInt(data.length);

        return data[randomIndex].toString();
      } else {
        throw Exception('Erro ao carregar frases');
      }
    } catch (e) {
      return 'Não foi possível carregar a motivação.';
    }
  }
}

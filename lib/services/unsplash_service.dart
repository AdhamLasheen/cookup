import 'dart:convert';
import 'package:http/http.dart' as http;

class UnsplashService {
  static const String _accessKey = '0jhJbvamWoBkXMnwXzWEy8QfO4T9Zn-a6lJ_vf0WBR4';
  static const String _baseUrl = 'https://api.unsplash.com';
  
  static Future<String?> getRecipeImage(String recipeName) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/search/photos?query=$recipeName food&per_page=1'),
        headers: {
          'Authorization': 'Client-ID $_accessKey',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'] != null && data['results'].isNotEmpty) {
          return data['results'][0]['urls']['regular'];
        }
      }
    } catch (e) {
      print('Error fetching image: $e');
    }
    return null;
  }
}

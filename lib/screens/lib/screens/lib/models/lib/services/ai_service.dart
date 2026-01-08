import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const String apiUrl = 'https://api.anthropic.com/v1/messages';
  
  Future<String> getHealthAdvice(String question) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'claude-sonnet-4-20250514',
          'max_tokens': 1000,
          'system': 'Anda adalah asisten kesehatan AI yang ramah dan informatif. Berikan saran kesehatan dalam bahasa Indonesia yang singkat dan praktis.',
          'messages': [
            {'role': 'user', 'content': question}
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['content'][0]['text'];
      } else {
        throw Exception('Failed to get AI response');
      }
    } catch (e) {
      return 'Maaf, terjadi kesalahan dalam menghubungi AI assistant. Error: $e';
    }
  }
}

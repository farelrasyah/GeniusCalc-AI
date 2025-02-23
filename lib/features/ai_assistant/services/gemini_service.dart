import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta';
  static const String _apiKey = 'AIzaSyARIKwnlrUeIxpGvTS5VhRxuR2HhWQCxoY';
  static const String _model = 'gemini-1.5-flash';

  Future<String> generateResponse(String prompt) async {
    try {
      final url =
          Uri.parse('$_baseUrl/models/$_model:generateContent?key=$_apiKey');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {
                  'text': '''You are a helpful math assistant. 
              Focus on providing clear mathematical explanations.
              Use numbers instead of asterisks for steps (1., 2., etc).
              Format the response to be clean and readable.
              Keep explanations concise and friendly.
              Question: $prompt'''
                }
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.7,
            'topK': 40,
            'topP': 0.95,
            'maxOutputTokens': 1024,
          },
          'safetySettings': [
            {
              'category': 'HARM_CATEGORY_HARASSMENT',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
            },
            {
              'category': 'HARM_CATEGORY_HATE_SPEECH',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
            },
            {
              'category': 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
            },
            {
              'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String rawResponse =
            data['candidates'][0]['content']['parts'][0]['text'];

        // Clean up the response text
        rawResponse = rawResponse
            .replaceAll('**', '') // Remove markdown bold syntax
            .replaceAll('*', '') // Remove any remaining asterisks
            .replaceAll('Step ', 'Step ') // Ensure consistent step formatting
            .replaceAll(RegExp(r'\n\s*\n'), '\n') // Remove extra newlines
            .trim();

        return rawResponse;
      } else {
        print('Error response: ${response.body}');
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Service error: $e');
      throw Exception('Failed to connect to Gemini API: $e');
    }
  }
}

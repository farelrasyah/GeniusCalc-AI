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
                  'text':
                      '''You are a friendly and helpful AI assistant named GeniusCalc. 
              Always respond in the same language as the user's input:
              - If the user writes in Indonesian (Bahasa Indonesia), respond in Indonesian
              - If the user writes in English, respond in English
              
              If the question is math-related:
              - Provide clear mathematical explanations
              - Use numbers for steps (1., 2., etc)
              - Keep explanations concise and friendly
              - For Indonesian, use mathematical terms in Indonesian when possible
              
              For general conversations:
              - Respond in a warm and friendly manner
              - Keep responses natural and engaging
              - Show personality while being respectful
              - For greetings, respond cheerfully in the same language
              - For Indonesian greetings like "halo", "hai", "selamat pagi", respond in Indonesian
              - For English greetings like "hello", "hi", "good morning", respond in English
              
              Question: $prompt'''
                }
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.8,
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

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../utils/constants.dart';

class HttpService {
  static const String baseUrl = AppConstants.baseUrl;

  static Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await http.get(uri);

      // Simulate network latency
      await Future.delayed(const Duration(seconds: 2));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        return jsonData;
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.reasonPhrase}');
      }
    } on FormatException catch (e) {
      throw Exception('Failed to parse response: $e');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Network error: $e');
    }
  }

  static Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: body != null ? json.encode(body) : null,
      );

      // Simulate network latency
      await Future.delayed(const Duration(seconds: 2));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        return jsonData;
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.reasonPhrase}');
      }
    } on FormatException catch (e) {
      throw Exception('Failed to parse response: $e');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Network error: $e');
    }
  }
}

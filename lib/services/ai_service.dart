import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'database_service.dart';

class AIService {
  final String? _apiKey = dotenv.env['GEMINI_API_KEY'];
  final DatabaseService _databaseService = DatabaseService();

  Future<String> processQuery(String userQuery) async {
    try {
      if (_apiKey == null) {
        throw Exception('Gemini API key not configured');
      }

      String schema = _getDatabaseSchema();
      String sqlQuery = await _generateSQLQuery(userQuery, schema);
      List<Map<String, dynamic>> results = await _databaseService.executeQuery(sqlQuery);
      String response = await _generateNaturalLanguageResponse(userQuery, results);
      return response;
    } catch (e) {
      return 'Sorry, I couldn’t process your request. Error: $e. Please try a different query or check your configuration.';
    }
  }

  String _getDatabaseSchema() {
    return '''
Database Schema:

Table: transactions
- id (INTEGER PRIMARY KEY AUTOINCREMENT)
- type (TEXT NOT NULL: 'sale' or 'purchase')
- itemName (TEXT NOT NULL)
- quantity (INTEGER NOT NULL)
- unitPrice (REAL NOT NULL)
- totalAmount (REAL NOT NULL)
- date (TEXT NOT NULL: ISO8601 format)
- notes (TEXT)
- customerName (TEXT)
- paymentMethod (TEXT)

Table: inventory
- id (INTEGER PRIMARY KEY AUTOINCREMENT)
- name (TEXT NOT NULL)
- currentStock (INTEGER NOT NULL)
- minStock (INTEGER NOT NULL)
- purchasePrice (REAL NOT NULL)
- sellingPrice (REAL NOT NULL)
- category (TEXT NOT NULL)
- description (TEXT)
- unit (TEXT)
- lastUpdated (TEXT NOT NULL: ISO8601 format)

Table: debts
- id (INTEGER PRIMARY KEY AUTOINCREMENT)
- personName (TEXT NOT NULL)
- type (TEXT NOT NULL: 'owed_to_me' or 'i_owe')
- amount (REAL NOT NULL)
- description (TEXT)
- date (TEXT NOT NULL: ISO8601 format)
- dueDate (TEXT)
- isPaid (INTEGER NOT NULL: 0 or 1)
- contactNumber (TEXT)
- paymentMethod (TEXT)

Table: categories
- id (INTEGER PRIMARY KEY AUTOINCREMENT)
- name (TEXT NOT NULL UNIQUE)
- description (TEXT)
- createdAt (TEXT NOT NULL: ISO8601 format)
''';
  }

  Future<String> _generateSQLQuery(String userQuery, String schema) async {
    final gemini = Gemini.instance;
    final response = await gemini.prompt(
      parts: [
        Part.text(
          'You are a SQL query generator for an inventory management system. Given a user query and SQLite database schema, generate a valid, secure SQLite query. Return only the SQL query without explanations or Markdown formatting (no ```sql or other code fences). Schema:\n$schema\n\nUser Query: $userQuery\n\nGenerate a secure SQLite query:',
        ),
      ],
      model: 'models/gemini-1.5-flash',
      generationConfig: GenerationConfig(
        temperature: 0.2,
        maxOutputTokens: 178,
      ),
    );

    if (response?.output != null) {
      String query = response!.output!.trim();
      // Remove Markdown code fences and any surrounding text
      query = query.replaceAll(RegExp(r'```sql\s*|\s*```'), '').trim();
      // Remove any non-SQL content (e.g., "sql" prefix or extra newlines)
      query = query.replaceAll(RegExp(r'^\s*sql\s*', caseSensitive: false), '').trim();
      // Ensure the query ends with a semicolon
      if (!query.endsWith(';')) {
        query = '$query;';
      }
      // Safety check for dangerous queries
      if (query.toLowerCase().contains('drop') ||
          query.toLowerCase().contains('delete') ||
          query.toLowerCase().contains('truncate')) {
        throw Exception('Potentially dangerous query detected');
      }
      return query;
    } else {
      throw Exception('Failed to generate SQL query');
    }
  }

  Future<String> _generateNaturalLanguageResponse(
      String userQuery, List<Map<String, dynamic>> results) async {
    final gemini = Gemini.instance;
    final response = await gemini.prompt(
      parts: [
        Part.text(
          'You are a helpful assistant for an inventory management system. Convert database query results into clear, concise, and natural language responses. If results are empty, provide an appropriate message. User asked: "$userQuery"\n\nDatabase results: ${jsonEncode(results)}\n\nProvide a natural language response(note- all amounts are in indian rupees ₹):',
        ),
      ],
      model: 'models/gemini-1.5-flash',
      generationConfig: GenerationConfig(
        temperature: 0.7,
        maxOutputTokens: 250,
      ),
    );

    if (response?.output != null) {
      return response!.output!.trim();
    } else {
      throw Exception('Failed to generate response');
    }
  }
}

// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'database_service.dart';

// class AIService {
//   static const String _baseUrl = 'https://api.openai.com/v1/chat/completions';
//   final String _apiKey;
//   final DatabaseService _databaseService = DatabaseService();

//   AIService() : _apiKey = dotenv.env['OPENAI_API_KEY'] ?? '' {
//     if (_apiKey.isEmpty) {
//       throw Exception('OpenAI API key not configured in .env file');
//     }
//   }

//   Future<String> processQuery(String userQuery) async {
//     try {
//       String schema = _getDatabaseSchema();
//       String sqlQuery = await _generateSQLQuery(userQuery, schema);
//       List<Map<String, dynamic>> results = await _databaseService.executeQuery(sqlQuery);
//       String response = await _generateNaturalLanguageResponse(userQuery, results);
//       return response;
//     } catch (e) {
//       return 'Sorry, I couldn’t process your request. Error: $e. Please check your configuration or try again.';
//     }
//   }

//   String _getDatabaseSchema() {
//     return '''
// Database Schema:

// Table: transactions
// - id (INTEGER PRIMARY KEY AUTOINCREMENT)
// - type (TEXT NOT NULL: 'sale' or 'purchase')
// - itemName (TEXT NOT NULL)
// - quantity (INTEGER NOT NULL)
// - unitPrice (REAL NOT NULL)
// - totalAmount (REAL NOT NULL)
// - date (TEXT NOT NULL: ISO8601 format)
// - notes (TEXT)
// - customerName (TEXT)
// - paymentMethod (TEXT)

// Table: inventory
// - id (INTEGER PRIMARY KEY AUTOINCREMENT)
// - name (TEXT NOT NULL)
// - currentStock (INTEGER NOT NULL)
// - minStock (INTEGER NOT NULL)
// - purchasePrice (REAL NOT NULL)
// - sellingPrice (REAL NOT NULL)
// - category (TEXT NOT NULL)
// - description (TEXT)
// - unit (TEXT)
// - lastUpdated (TEXT NOT NULL: ISO8601 format)

// Table: debts
// - id (INTEGER PRIMARY KEY AUTOINCREMENT)
// - personName (TEXT NOT NULL)
// - type (TEXT NOT NULL: 'owed_to_me' or 'i_owe')
// - amount (REAL NOT NULL)
// - description (TEXT)
// - date (TEXT NOT NULL: ISO8601 format)
// - dueDate (TEXT)
// - isPaid (INTEGER NOT NULL: 0 or 1)
// - contactNumber (TEXT)
// - paymentMethod (TEXT)

// Table: categories
// - id (INTEGER PRIMARY KEY AUTOINCREMENT)
// - name (TEXT NOT NULL UNIQUE)
// - description (TEXT)
// - createdAt (TEXT NOT NULL: ISO8601 format)
// ''';
//   }

//   Future<String> _generateSQLQuery(String userQuery, String schema) async {
//     final response = await http.post(
//       Uri.parse(_baseUrl),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $_apiKey',
//       },
//       body: jsonEncode({
//         'model': 'gpt-4o',
//         'messages': [
//           {
//             'role': 'system',
//             'content': 'You are a SQL query generator for an inventory management system. Given a user query and SQLite database schema, generate a valid, secure SQLite query. Return only the SQL query without explanations. Ensure the query is optimized and handles edge cases.'
//           },
//           {
//             'role': 'user',
//             'content': 'Schema:\n$schema\n\nUser Query: $userQuery\n\nGenerate a secure SQLite query:'
//           }
//         ],
//         'max_tokens': 178,
//         'temperature': 0.2,
//       }),
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       String query = data['choices'][0]['message']['content'].trim();
//       if (query.toLowerCase().contains('drop') || query.toLowerCase().contains('delete') || query.toLowerCase().contains('truncate')) {
//         throw Exception('Potentially dangerous query detected');
//       }
//       return query;
//     } else {
//       final errorData = jsonDecode(response.body);
//       throw Exception('Failed to generate SQL query: ${response.statusCode} - ${errorData['error']['message']}');
//     }
//   }

//   Future<String> _generateNaturalLanguageResponse(String userQuery, List<Map<String, dynamic>> results) async {
//     final response = await http.post(
//       Uri.parse(_baseUrl),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $_apiKey',
//       },
//       body: jsonEncode({
//         'model': 'gpt-4o',
//         'messages': [
//           {
//             'role': 'system',
//             'content': 'You are a helpful assistant for an inventory management system. Convert database query results into clear, concise, and natural language responses. If results are empty, provide an appropriate message.'
//           },
//           {
//             'role': 'user',
//             'content': 'User asked: "$userQuery"\n\nDatabase results: ${jsonEncode(results)}\n\nProvide a natural language response:'
//           }
//         ],
//         'max_tokens': 250,
//         'temperature': 0.7,
//       }),
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       return data['choices'][0]['message']['content'].trim();
//     } else {
//       final errorData = jsonDecode(response.body);
//       throw Exception('Failed to generate response: ${response.statusCode} - ${errorData['error']['message']}');
//     }
//   }
// }

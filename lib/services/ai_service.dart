import 'dart:convert';
import 'dart:developer';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'database_service.dart';

class AIService {
  final String? _apiKey = dotenv.env['GEMINI_API_KEY'];
  final DatabaseService _databaseService = DatabaseService();

  Future<String> processQuery(String userQuery, {String languageCode = 'en-US'}) async {
    log('--- Starting AI Query Process ---');
    log('User Query: $userQuery, Language: $languageCode');
    try {
      if (_apiKey == null) {
        throw Exception('Gemini API key not configured');
      }

      // 1. Intent Recognition
      String intent = await _recognizeIntent(userQuery);
      log('Recognized Intent: $intent');
      List<Map<String, dynamic>> results;
      String response;

      // 2. Route to appropriate handler
      switch (intent) {
        case 'get_best_seller':
          results = await _handleBestSellerQuery(userQuery);
          response = await _generateNaturalLanguageResponse(userQuery, results, languageCode: languageCode);
          break;
        case 'get_credit_transactions':
          results = await _handleCreditTransactionsQuery(userQuery);
          response = await _generateNaturalLanguageResponse(userQuery, results, languageCode: languageCode);
          break;
        case 'get_low_stock_items':
          results = await _handleLowStockItemsQuery();
          response = await _generateNaturalLanguageResponse(userQuery, results, languageCode: languageCode);
          break;
        case 'get_top_debtor':
          results = await _handleTopDebtorQuery(userQuery);
          response = await _generateNaturalLanguageResponse(userQuery, results, languageCode: languageCode);
          break;
        case 'get_sales_suggestions':
          response = await _handleSalesSuggestionsQuery(languageCode: languageCode);
          break;
        case 'general_query':
        default:
          log('Falling back to general query handler.');
          String schema = _getDatabaseSchema();
          String sqlQuery = await _generateSQLQuery(userQuery, schema);
          log('Generated SQL Query: $sqlQuery');
          results = await _databaseService.executeQuery(sqlQuery);
          log('Query Results: ${results.length} rows');
          response = await _generateNaturalLanguageResponse(userQuery, results, languageCode: languageCode);
          break;
      }
      log('--- Finished AI Query Process ---');
      return response;
    } catch (e) {
      log('Error in processQuery: $e', error: e);
      return 'Sorry, I couldn’t process your request. Error: $e. Please try a different query or check your configuration.';
    }
  }

  Future<String> _recognizeIntent(String userQuery) async {
    log('Recognizing intent...');
    final gemini = Gemini.instance;
    final response = await gemini.prompt(
      parts: [
        Part.text(
          'You are an intent recognition system for an inventory management app. Classify the user\'s query into one of the following categories and return only the category name:\n'
          '- get_best_seller: For queries about top-selling or most-sold items.\n'
          '- get_credit_transactions: For queries about credit, debt, or "udhaar" transactions.\n'
          '- get_low_stock_items: For queries about items that are low in stock or need reordering.\n'
          '- get_top_debtor: For queries about which customer has the most credit or debt.\n'
          '- get_sales_suggestions: For queries asking for advice or suggestions to improve sales.\n'
          '- general_query: For all other queries.\n\n'
          'User Query: "$userQuery"\n\n'
          'Intent:',
        ),
      ],
      model: 'models/gemini-1.5-flash',
      generationConfig: GenerationConfig(
        temperature: 0.0,
        maxOutputTokens: 50,
      ),
    );

    String intent = response?.output?.trim() ?? 'general_query';
    // Basic validation to ensure the output is one of the expected intents
    const validIntents = {
      'get_best_seller',
      'get_credit_transactions',
      'get_low_stock_items',
      'get_top_debtor',
      'get_sales_suggestions',
      'general_query'
    };
    if (validIntents.contains(intent)) {
      log('Intent recognized: $intent');
      return intent;
    }
    log('Intent recognition failed, falling back to general_query.');
    return 'general_query';
  }

  // --- Handlers for Specific Intents ---

  Future<List<Map<String, dynamic>>> _handleBestSellerQuery(String userQuery) {
    log('Handling best seller query...');
    String dateFilter = "date >= date('now', '-30 days')";
    if (userQuery.toLowerCase().contains('today')) {
      dateFilter = "date(date) = date('now')";
    }
    final query = """
      SELECT itemName, SUM(quantity) as total_quantity
      FROM transactions
      WHERE type = 'sale' AND $dateFilter
      GROUP BY itemName
      ORDER BY total_quantity DESC
      LIMIT 5;
    """;
    return _databaseService.executeQuery(query);
  }

  Future<List<Map<String, dynamic>>> _handleCreditTransactionsQuery(String userQuery) {
    log('Handling credit transactions query...');
    String dateFilter = "date >= date('now', '-30 days')";
    if (userQuery.toLowerCase().contains('today')) {
      dateFilter = "date(date) = date('now')";
    }
    final query = """
      SELECT COUNT(*) as credit_transactions_count, SUM(amount) as total_credit_amount
      FROM debts
      WHERE type = 'owed_to_me' AND $dateFilter;
    """;
    return _databaseService.executeQuery(query);
  }

  Future<List<Map<String, dynamic>>> _handleLowStockItemsQuery() {
    log('Handling low stock items query...');
    final query = """
      SELECT name, currentStock, minStock
      FROM inventory
      WHERE currentStock <= minStock
      ORDER BY currentStock ASC;
    """;
    return _databaseService.executeQuery(query);
  }

  Future<List<Map<String, dynamic>>> _handleTopDebtorQuery(String userQuery) {
    log('Handling top debtor query...');
    String dateFilter = "date >= date('now', '-30 days')";
    if (userQuery.toLowerCase().contains('today')) {
      dateFilter = "date(date) = date('now')";
    }
    final query = """
      SELECT personName, SUM(amount) as total_debt
      FROM debts
      WHERE type = 'owed_to_me' AND isPaid = 0 AND $dateFilter
      GROUP BY personName
      ORDER BY total_debt DESC
      LIMIT 5;
    """;
    return _databaseService.executeQuery(query);
  }

  Future<String> _handleSalesSuggestionsQuery({String languageCode = 'en-US'}) async {
    log('Handling sales suggestions query...');
    // 1. Get top 3 best sellers in the last 30 days
    final bestSellersQuery = """
      SELECT itemName, SUM(quantity) as total_quantity
      FROM transactions
      WHERE type = 'sale' AND date >= date('now', '-30 days')
      GROUP BY itemName
      ORDER BY total_quantity DESC
      LIMIT 3;
    """;
    final bestSellers = await _databaseService.executeQuery(bestSellersQuery);

    // 2. Get top 3 low-stock items
    final lowStockQuery = """
      SELECT name, currentStock
      FROM inventory
      WHERE currentStock <= minStock
      ORDER BY currentStock ASC
      LIMIT 3;
    """;
    final lowStockItems = await _databaseService.executeQuery(lowStockQuery);

    // 3. Get total sales trend for the last 7 days
    final salesTrendQuery = """
      SELECT date(date) as sale_date, SUM(totalAmount) as daily_sales
      FROM transactions
      WHERE type = 'sale' AND date >= date('now', '-7 days')
      GROUP BY sale_date
      ORDER BY sale_date ASC;
    """;
    final salesTrend = await _databaseService.executeQuery(salesTrendQuery);

    // 4. Generate suggestions using the gathered data
    final gemini = Gemini.instance;
    final languageInstruction = languageCode == 'hi-IN'
        ? 'The response must be in Hindi.'
        : 'The response must be in English.';

    final prompt = """
      You are an expert business analyst for an inventory management system. Based on the following data, provide actionable suggestions to increase sales. The response should be concise, easy to understand for a small business owner, and in Markdown format. The response should be around 100-150 words. $languageInstruction

      **Data Summary:**

      *   **Best Sellers (Last 30 Days):** ${jsonEncode(bestSellers)}
      *   **Low Stock Items:** ${jsonEncode(lowStockItems)}
      *   **Sales Trend (Last 7 Days):** ${jsonEncode(salesTrend)}

      **Suggestions:**
    """;
    log('Generating sales suggestions with prompt...');
    final response = await gemini.prompt(
      parts: [Part.text(prompt)],
      model: 'models/gemini-1.5-flash',
      generationConfig: GenerationConfig(
        temperature: 0.8,
        maxOutputTokens: 150,
      ),
    );

    return response?.output ?? "I couldn't generate any sales suggestions at the moment. Please try again later.";
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
    log('Generating SQL query...');
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
        maxOutputTokens: 150,
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
      log('Generated SQL: $query');
      return query;
    } else {
      throw Exception('Failed to generate SQL query');
    }
  }

  Future<String> _generateNaturalLanguageResponse(
      String userQuery, List<Map<String, dynamic>> results, {String languageCode = 'en-US'}) async {
    log('Generating natural language response...');
    final gemini = Gemini.instance;
    final languageInstruction = languageCode == 'hi-IN'
        ? 'The user wants the response in Hindi. Please provide the response in Hindi.'
        : 'The user wants the response in English. Please provide the response in English.';

    final response = await gemini.prompt(
      parts: [
        Part.text(
          'You are a helpful assistant for an inventory management system. Convert database query results into clear, concise, and natural language responses. The response should be around 100-150 words. If results are empty, provide an appropriate message. $languageInstruction\n\nUser asked: "$userQuery"\n\nDatabase results: ${jsonEncode(results)}\n\nProvide a natural language response (note- all amounts are in Indian Rupees ₹):',
        ),
      ],
      model: 'models/gemini-1.5-flash',
      generationConfig: GenerationConfig(
        temperature: 0.7,
        maxOutputTokens: 150,
      ),
    );

    if (response?.output != null) {
      log('Generated response successfully.');
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

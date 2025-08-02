import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../services/ai_service.dart';
import '../services/speech_service.dart';

class AIChatBottomSheet extends StatefulWidget {
  const AIChatBottomSheet({super.key});

  @override
  State<AIChatBottomSheet> createState() => _AIChatBottomSheetState();
}

class _AIChatBottomSheetState extends State<AIChatBottomSheet> {
  final TextEditingController _queryController = TextEditingController();
  final AIService _aiService = AIService();
  final SpeechService _speechService = SpeechService();

  bool _isLoading = false;
  bool _isListening = false;
  String _currentLanguage = 'en-US'; // Default language

  final List<Map<String, String>> _messages = [];

  final List<String> _suggestions = [
    'What is my total revenue this month?',
    'Show me low stock items',
    'What are my outstanding debts?',
    'How much profit did I make this week?',
    'Show me recent transactions',
    'Which items sell the most?',
    'इस महीने की कुल आय क्या है?', // Hindi suggestion
    'कम स्टॉक वाली वस्तुएं दिखाएं', // Hindi suggestion
  ];

  @override
  void dispose() {
    _queryController.dispose();
    _speechService.stop();
    super.dispose();
  }

  // Detect language based on input (basic heuristic)
  bool _isHindiInput(String text) {
    return RegExp(r'[\u0900-\u097F]').hasMatch(text); // Detects Devanagari script
  }

  void _updateLanguage(String text) {
    if (_isHindiInput(text)) {
      _speechService.setLanguage('hi-IN');
      setState(() => _currentLanguage = 'hi-IN');
    } else {
      _speechService.setLanguage('en-US');
      setState(() => _currentLanguage = 'en-US');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (_, __) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                // Handles
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 12),

                // Title
                const Text(
                  'AI Assistant',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                // Chat area
                Expanded(
                  child: ListView(
                    reverse: true,
                    children: [
                      if (_messages.isEmpty) ...[
                        const SizedBox(height: 32),
                        const Center(
                          child: Text(
                            'Ask anything about your inventory!',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ),
                      ],

                      // Chat Messages
                      ..._messages.reversed.map((message) {
                        final isUser = message['role'] == 'user';
                        final isAI = message['role'] == 'ai';

                        return Align(
                          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.75,
                            ),
                            decoration: BoxDecoration(
                              color: isUser
                                  ? Colors.blue[100]
                                  : colorScheme.surfaceContainerHighest.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                isAI
                                    ? MarkdownBody(
                                        data: message['content'] ?? '',
                                        styleSheet: MarkdownStyleSheet(
                                          p: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 14,
                                          ),
                                          strong: const TextStyle(fontWeight: FontWeight.bold),
                                          em: const TextStyle(fontStyle: FontStyle.italic),
                                          listBullet: const TextStyle(fontSize: 14),
                                        ),
                                      )
                                    : Text(
                                        message['content'] ?? '',
                                        style: TextStyle(
                                          color: Colors.blue[900],
                                          fontSize: 14,
                                        ),
                                      ),
                                if (isAI)
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: IconButton(
                                      icon: Icon(
                                        _speechService.isSpeaking && message['isSpeaking'] == 'true'
                                            ? Icons.volume_off
                                            : Icons.volume_up,
                                        size: 18,
                                      ),
                                      onPressed: () => _toggleSpeak(message),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }),

                      const SizedBox(height: 12),

                      // Suggestion Chips
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _suggestions.map((suggestion) {
                          return ActionChip(
                            label: Text(suggestion),
                            onPressed: () {
                              _queryController.text = suggestion;
                              _updateLanguage(suggestion);
                            },
                            backgroundColor: Colors.blue.withOpacity(0.1),
                            labelStyle: TextStyle(color: Colors.blue[800]),
                            shape: StadiumBorder(
                              side: BorderSide(color: Colors.blue.withOpacity(0.3)),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Input Row
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _queryController,
                        decoration: InputDecoration(
                          hintText: 'Type a question...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        ),
                        minLines: 1,
                        maxLines: 3,
                        enabled: !_isLoading,
                        onChanged: _updateLanguage, // Update language on text input
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        _isListening ? Icons.mic : Icons.mic_none,
                        color: _isListening ? Colors.red : Colors.blue,
                      ),
                      onPressed: _startVoiceInput,
                    ),
                    IconButton(
                      icon: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.send),
                      onPressed: _isLoading ? null : _sendQuery,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _startVoiceInput() async {
    if (_isListening) {
      await _speechService.stopListening();
      setState(() => _isListening = false);
    } else {
      setState(() => _isListening = true);
      try {
        await _speechService.startListening((result) {
          setState(() {
            _queryController.text = result;
            _isListening = false;
            _updateLanguage(result); // Update language based on recognized text
          });
        });
      } catch (e) {
        setState(() => _isListening = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Speech recognition error: $e')),
        );
      }
    }
  }

  void _toggleSpeak(Map<String, String> message) async {
    final isSpeaking = _speechService.isSpeaking && message['isSpeaking'] == 'true';
    if (isSpeaking) {
      await _speechService.stop();
      setState(() {
        message['isSpeaking'] = 'false';
      });
    } else {
      await _speechService.speak(message['content'] ?? '');
      setState(() {
        _messages.forEach((msg) => msg['isSpeaking'] = 'false'); // Reset others
        message['isSpeaking'] = 'true';
      });
    }
  }

  void _sendQuery() async {
    final input = _queryController.text.trim();
    if (input.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'content': input, 'isSpeaking': 'false'});
      _isLoading = true;
      _queryController.clear();
    });

    try {
      final response = await _aiService.processQuery(input);
      setState(() {
        _messages.add({'role': 'ai', 'content': response, 'isSpeaking': 'false'});
      });
      // Automatically speak AI response in the appropriate language
      _updateLanguage(response);
      await _speechService.speak(response);
      setState(() {
        _messages.last['isSpeaking'] = 'true';
      });
    } catch (e) {
      setState(() {
        _messages.add({'role': 'ai', 'content': 'Error: $e', 'isSpeaking': 'false'});
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }
}

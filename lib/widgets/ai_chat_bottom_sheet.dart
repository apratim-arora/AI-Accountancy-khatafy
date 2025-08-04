import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
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
  String _selectedVoiceLanguage = 'en-US'; // Selected voice input language

  final List<Map<String, String>> _messages = [];

final List<String> _suggestions = [
  'Which items sell the most?', // get_best_seller
  'Show me my top-selling products', // get_best_seller
  'What are my outstanding debts?', // get_credit_transactions
  'इस महीने की कुल आय क्या है?', // general_query (Hindi)
  'कम स्टॉक वाली वस्तुएं दिखाएं', // get_low_stock_items (Hindi)
  'किन उत्पादों को फिर से ऑर्डर करने की जरूरत है?', // get_low_stock_items (Hindi)
];

  // Language options for voice input
  final Map<String, String> _languageOptions = {
    'en-US': 'English',
    'hi-IN': 'हिंदी (Hindi)',
  };

  @override
  void dispose() {
    _queryController.dispose();
    _speechService.stop();
    super.dispose();
  }

  // Detect language based on input (improved heuristic)
  bool _isHindiInput(String text) {
    return RegExp(r'[\u0900-\u097F]')
        .hasMatch(text); // Detects Devanagari script
  }

  String _stripMarkdown(String text) {
    // Convert Markdown to HTML
    String html = md.markdownToHtml(text, inlineSyntaxes: [
      md.InlineHtmlSyntax(),
      md.StrikethroughSyntax(),
      md.EmphasisSyntax.asterisk(),
      md.EmphasisSyntax.underscore(),
      md.CodeSyntax(),
    ], blockSyntaxes: [
      md.FencedCodeBlockSyntax(),
      md.TableSyntax(),
      md.HeaderSyntax(),
      md.HorizontalRuleSyntax(),
      md.UnorderedListSyntax(),
      md.OrderedListSyntax(),
    ]);
    // Strip HTML tags and clean up
    String plainText = html
        .replaceAll(RegExp(r'<[^>]+>'), '') // Remove HTML tags
        .replaceAll(RegExp(r'\n\s*\n+'), '\n') // Remove extra newlines
        .replaceAll(RegExp(r'&nbsp;'), ' ') // Replace non-breaking spaces
        .replaceAll(RegExp(r'&(amp|lt|gt);'), '') // Remove HTML entities
        .trim();
    return plainText;
  }

  void _updateLanguage(String text) {
    if (_isHindiInput(text)) {
      setState(() => _currentLanguage = 'hi-IN');
    } else {
      setState(() => _currentLanguage = 'en-US');
    }
  }

  void _changeVoiceLanguage(String? language) {
    if (language != null) {
      setState(() {
        _selectedVoiceLanguage = language;
      });
      // Set language immediately when changed
      _speechService.setLanguage(language);
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
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
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

                // Title and Language Selector Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'AI Assistant',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    // Language Selector for Voice Input
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedVoiceLanguage,
                          icon: const Icon(Icons.mic, size: 16),
                          style: const TextStyle(fontSize: 12),
                          onChanged: _changeVoiceLanguage,
                          items: _languageOptions.entries.map((entry) {
                            return DropdownMenuItem<String>(
                              value: entry.key,
                              child: Text(
                                entry.value,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Chat area
                Expanded(
                  child: ListView(
                    reverse: true,
                    children: [
                      if (_messages.isEmpty) ...[
                        const SizedBox(height: 32),
                        Center(
                          child: Column(
                            children: [
                              const Text(
                                'Ask anything about your inventory!',
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Voice Language: ${_languageOptions[_selectedVoiceLanguage]}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      // Chat Messages
                      ..._messages.reversed.map((message) {
                        final isUser = message['role'] == 'user';
                        final isAI = message['role'] == 'ai';

                        return Align(
                          alignment: isUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.75,
                            ),
                            decoration: BoxDecoration(
                              color: isUser
                                  ? Colors.blue[100]
                                  : colorScheme.surfaceContainerHighest
                                      .withOpacity(0.6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                isAI
                                    ? MarkdownBody(
                                        data: message['content'] ?? '',
                                        styleSheet: MarkdownStyleSheet(
                                          p: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 14,
                                          ),
                                          strong: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                          em: const TextStyle(
                                              fontStyle: FontStyle.italic),
                                          listBullet:
                                              const TextStyle(fontSize: 14),
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
                                        _speechService.isSpeaking &&
                                                message['isSpeaking'] == 'true'
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
                              // Auto-switch voice language based on suggestion language
                              if (_isHindiInput(suggestion) &&
                                  _selectedVoiceLanguage != 'hi-IN') {
                                _changeVoiceLanguage('hi-IN');
                              } else if (!_isHindiInput(suggestion) &&
                                  _selectedVoiceLanguage != 'en-US') {
                                _changeVoiceLanguage('en-US');
                              }
                            },
                            backgroundColor: Colors.blue.withOpacity(0.1),
                            labelStyle: TextStyle(color: Colors.blue[800]),
                            shape: StadiumBorder(
                              side: BorderSide(
                                  color: Colors.blue.withOpacity(0.3)),
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
                          hintText: _selectedVoiceLanguage == 'hi-IN'
                              ? 'सवाल पूछें...'
                              : 'Type a question...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                        ),
                        minLines: 1,
                        maxLines: 3,
                        enabled: !_isLoading,
                        onChanged:
                            _updateLanguage, // Update language on text input
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Voice Input Button with Language Indicator
                    Container(
                      decoration: BoxDecoration(
                        color: _isListening
                            ? Colors.red.withOpacity(0.1)
                            : Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _isListening ? Colors.red : Colors.blue,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              _isListening ? Icons.mic : Icons.mic_none,
                              color: _isListening ? Colors.red : Colors.blue,
                            ),
                            onPressed: _startVoiceInput,
                          ),
                          Text(
                            _selectedVoiceLanguage == 'hi-IN' ? 'हिं' : 'EN',
                            style: TextStyle(
                              fontSize: 8,
                              color: _isListening ? Colors.red : Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
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

                // Voice language status indicator
                if (_isListening)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Listening in ${_languageOptions[_selectedVoiceLanguage]}...',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
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
      // Set the speech service to use the selected language
      await _speechService.setLanguage(_selectedVoiceLanguage);

      setState(() => _isListening = true);
      try {
        await _speechService.startListening((result) {
          if (result.isNotEmpty) {
            setState(() {
              _queryController.text = result;
              _isListening = false;
              _updateLanguage(
                  result); // Update response language based on recognized text
            });
          } else {
            setState(() => _isListening = false);
          }
        });
      } catch (e) {
        setState(() => _isListening = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_selectedVoiceLanguage == 'hi-IN'
                  ? 'बोलने में त्रुटि: $e'
                  : 'Speech recognition error: $e'),
            ),
          );
        }
      }
    }
  }

  void _toggleSpeak(Map<String, String> message) async {
    final isSpeaking =
        _speechService.isSpeaking && message['isSpeaking'] == 'true';
    if (isSpeaking) {
      await _speechService.stop();
      setState(() {
        message['isSpeaking'] = 'false';
      });
    } else {
      // Set speech language based on message content
      final cleanText = _stripMarkdown(message['content'] ?? '');
      final speechLang = _isHindiInput(cleanText) ? 'hi-IN' : 'en-US';
      _speechService.setLanguage(speechLang);

      await _speechService.speak(cleanText);
      setState(() {
        for (var msg in _messages) {
          msg['isSpeaking'] = 'false';
        } // Reset others
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
        _messages
            .add({'role': 'ai', 'content': response, 'isSpeaking': 'false'});
      });

      // Automatically speak AI response in the appropriate language
      _updateLanguage(response);
      final cleanText = _stripMarkdown(response);
      final speechLang = _isHindiInput(response) ? 'hi-IN' : 'en-US';
      _speechService.setLanguage(speechLang);

      await _speechService.speak(cleanText);
      setState(() {
        _messages.last['isSpeaking'] = 'true';
      });
    } catch (e) {
      setState(() {
        _messages
            .add({'role': 'ai', 'content': 'Error: $e', 'isSpeaking': 'false'});
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }
}

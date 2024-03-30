import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Importer denne pakke til at få adgang til Clipboard

class ShareDialog extends StatelessWidget {
  final String outputText;

  const ShareDialog({super.key, required this.outputText});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Share Pattern'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Vælgbar tekst widget til at vise outputtet
          SizedBox(
            width: 200, // Ønsket bredde
            child: Tooltip(
              message: outputText, // Den fulde tekst
              child: GestureDetector(
                onLongPress: () {
                  _copyToClipboard(outputText, context);
                },
                child: Text(
                  outputText.length > 20
                      ? '${outputText.substring(0, 20)}...'
                      : outputText, // Vis de første 20 tegn
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Knappen til kopiering af teksten til udklipsholderen
          ElevatedButton(
            onPressed: () {
              _copyToClipboard(outputText, context);
            },
            child: const Text('Kopier'),
          ),
        ],
      ),
    );
  }

  // Metode til at kopiere tekst til udklipsholderen
  void _copyToClipboard(String text, BuildContext context) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tekst kopieret'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

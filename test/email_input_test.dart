import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Email Input Formatter Test', () {
    test('should replace œ with @', () {
      final formatter = TextInputFormatter.withFunction((oldValue, newValue) {
        String text = newValue.text;
        // Replace common accented characters that might be used instead of @
        text = text.replaceAll('œ', '@');
        text = text.replaceAll('Œ', '@');
        
        // If the text has changed, return a new TextEditingValue
        if (text != newValue.text) {
          return TextEditingValue(
            text: text,
            selection: TextSelection.collapsed(offset: text.length),
          );
        }
        return newValue;
      });

      final oldValue = TextEditingValue.empty;
      final newValue = TextEditingValue(text: 'medhraœgmail.com');
      
      final result = formatter.formatEditUpdate(oldValue, newValue);
      
      expect(result.text, 'medhra@gmail.com');
    });

    test('should replace Œ with @', () {
      final formatter = TextInputFormatter.withFunction((oldValue, newValue) {
        String text = newValue.text;
        // Replace common accented characters that might be used instead of @
        text = text.replaceAll('œ', '@');
        text = text.replaceAll('Œ', '@');
        
        // If the text has changed, return new TextEditingValue
        if (text != newValue.text) {
          return TextEditingValue(
            text: text,
            selection: TextSelection.collapsed(offset: text.length),
          );
        }
        return newValue;
      });

      final oldValue = TextEditingValue.empty;
      final newValue = TextEditingValue(text: 'MEDHRAŒGMAIL.COM');
      
      final result = formatter.formatEditUpdate(oldValue, newValue);
      
      expect(result.text, 'MEDHRA@GMAIL.COM');
    });

    test('should not change normal email', () {
      final formatter = TextInputFormatter.withFunction((oldValue, newValue) {
        String text = newValue.text;
        // Replace common accented characters that might be used instead of @
        text = text.replaceAll('œ', '@');
        text = text.replaceAll('Œ', '@');
        
        // If the text has changed, return new TextEditingValue
        if (text != newValue.text) {
          return TextEditingValue(
            text: text,
            selection: TextSelection.collapsed(offset: text.length),
          );
        }
        return newValue;
      });

      final oldValue = TextEditingValue.empty;
      final newValue = TextEditingValue(text: 'medhra@gmail.com');
      
      final result = formatter.formatEditUpdate(oldValue, newValue);
      
      expect(result.text, 'medhra@gmail.com');
    });
  });
}

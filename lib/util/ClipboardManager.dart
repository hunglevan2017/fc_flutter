import 'package:flutter/services.dart';

copyTextToClipboard(String text){
  Clipboard.setData(ClipboardData(text: text));
}
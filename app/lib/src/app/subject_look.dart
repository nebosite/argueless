import 'package:argueless_core/argueless_core.dart';
import 'package:flutter/material.dart';

/// How a subject is drawn: its colour and icon from the content.
class SubjectLook {
  const SubjectLook._();

  static const _icons = <String, IconData>{
    'balance': Icons.balance_rounded,
    'help': Icons.help_outline_rounded,
    'favorite': Icons.favorite_border_rounded,
    'forum': Icons.forum_outlined,
  };

  static Color color(Subject subject) => Color(subject.color);

  /// The subject's icon; a speech bubble for a name the app doesn't know.
  static IconData icon(Subject subject) =>
      _icons[subject.icon] ?? Icons.chat_bubble_outline_rounded;
}

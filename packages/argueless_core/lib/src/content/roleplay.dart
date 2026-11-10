import 'json_fields.dart';

/// The closing role-play: the other person speaks, the user replies with
/// their favourite phrase, and the other person answers.
class Roleplay {
  const Roleplay({
    required this.partner,
    required this.opening,
    required this.partnerReply,
  });

  factory Roleplay.fromJson(JsonFields json) => Roleplay(
    partner: json.string('partner'),
    opening: json.string('opening'),
    partnerReply: json.string('partnerReply'),
  );

  /// Who the other person is, as "Dana, your manager".
  final String partner;

  /// What they say that the user replies to.
  final String opening;

  /// How they might answer a curious, cooperative reply.
  final String partnerReply;

  /// The partner's name alone, as "Dana".
  String get partnerName => partner.split(',').first.trim();
}

import 'package:hive/hive.dart';

part 'quote.g.dart';

@HiveType(typeId: 0)
class Quote extends HiveObject{
  @HiveField(0)
  int quoteId;

  @HiveField(1)
  String quoteBody;

  @HiveField(2)
  String quoteAuthor;

  @HiveField(3)
  List quoteTag;

  Quote({this.quoteId, this.quoteAuthor, this.quoteBody, this.quoteTag});

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
        quoteId: json['id'],
        quoteAuthor: json['author'],
        quoteBody: json['body'],
        quoteTag: json['tags']);
  }
}

import 'package:flutter_quote_app/util/quote.dart';

class QuoteList{

  bool lastPage;
  int pageNum;
  List<Quote> quotes;

  QuoteList({this.pageNum, this.lastPage, this.quotes});

  factory QuoteList.fromJson(Map<String, dynamic> json){
    return QuoteList(
      pageNum: json['page'],
      lastPage: json['last_page'],
      quotes: List<Quote>.from(
        json['quotes'].map((quote) => Quote.fromJson(quote))
      ),
    );
  }

}
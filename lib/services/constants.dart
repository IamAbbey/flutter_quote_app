import 'package:http/http.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_quote_app/util/quote.dart';
import 'package:flutter_quote_app/util/quotelist.dart';

class Constants{

  static const String API_KEY = "5f9d517dc0280021c27a8e3db3fb53f1";
  static const String BASE_URL = "https://favqs.com/api/";

  static const String ALL_QUOTES_URL = BASE_URL + 'quotes';

  static const String COPY_QUOTE_MSG = "Quote copied successfully";

  static const String QUOTE_BOX = 'favorite_quote';

  static const String SETTINGS_BOX = 'settings';
}

class FetchQuoteService{

  static Future<QuoteList> fetchQuotes(int pageNumber, [String tag]) async {
    Response response;
    if (tag == null){
      response = await get(
        Constants.ALL_QUOTES_URL + '/?page=${pageNumber.toString()}',
        headers: {HttpHeaders.authorizationHeader: "Token ${Constants.API_KEY}"},
      );
    }else{
      response = await get(
        Constants.ALL_QUOTES_URL + '/?filter=$tag&type=tag&page=${pageNumber.toString()}',
        headers: {HttpHeaders.authorizationHeader: "Token ${Constants.API_KEY}"},
      );
    }


    Map json = jsonDecode(response.body);

    QuoteList quotes = QuoteList.fromJson(json);

    return quotes;
  }

//  static Future<QuoteList> fetchQuotesByTag(String tag ,int pageNumber) async {
//
//    Response response = await get(
//      Constants.ALL_QUOTES_URL + '/?filter=$tag&type=tag&page=${pageNumber.toString()}',
//      headers: {HttpHeaders.authorizationHeader: "Token ${Constants.API_KEY}"},
//    );
//
//
//    Map json = jsonDecode(response.body);
//    print(json);
//    QuoteList quotes = QuoteList.fromJson(json);
//
//    return quotes;
//  }

}
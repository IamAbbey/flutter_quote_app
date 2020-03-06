import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_quote_app/services/constants.dart';
import 'package:flutter_quote_app/pages/home.dart';
import 'package:flutter_quote_app/util/quotelist.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  String apiKey = Constants.API_KEY;

  Future<void> fetchQuotes() async {
    QuoteList quotes = await FetchQuoteService.fetchQuotes(1);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => Home(),
          settings: RouteSettings(arguments: quotes)),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchQuotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: SafeArea(
          child: Center(child: SpinKitCubeGrid(color: Colors.white,))
      ),
    );
  }
}

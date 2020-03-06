import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quote_app/services/constants.dart';
import 'package:flutter_quote_app/util/quote.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FavoriteQuote extends StatefulWidget {
  @override
  _FavoriteQuoteState createState() => _FavoriteQuoteState();
}

class _FavoriteQuoteState extends State<FavoriteQuote> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text('Favorite Quotes'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ValueListenableBuilder(
          valueListenable: Hive.box<Quote>(Constants.QUOTE_BOX)
          .listenable(),
          builder: (context, Box<Quote>box, index){
            if(box.values.isEmpty){
              return Center(child: Text('No Favorite'));
            }
            return ListView.separated(
              itemCount: box.values.length,
                separatorBuilder: (context, index) => Divider(
                  height: 8.0,
                  thickness: 1.0,
                ),
                itemBuilder: (context, index){
                Quote currentQuote = box.getAt(index);
                return ListTile(
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(child: Icon(Icons.format_quote)),
                      Expanded(
                        child: IconButton(
                            icon: Icon(Icons.content_copy),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(
                                  text: currentQuote.quoteBody));
                              final snackBar = SnackBar(
                                content: Row(
                                  children: <Widget>[
                                    Icon(Icons.info_outline),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Text(Constants.COPY_QUOTE_MSG),
                                  ],
                                ),
                              );
                              Scaffold.of(context)
                                  .showSnackBar(snackBar);
                            }),
                      )
                    ],
                  ),
                  title: Text(currentQuote.quoteBody),
                  trailing: IconButton(
                    onPressed: () async{
                      await box.delete(currentQuote.quoteId);
                    },
                    icon: Icon(Icons.favorite, color: Colors.red,)
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.symmetric(vertical:6.0),
                    child: Text(
                        '- ${currentQuote.quoteAuthor}',
                      style: TextStyle(
                        fontFamily: 'BarlowCondensedBold',
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                );
              }
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quote_app/pages/favorite.dart';
import 'package:flutter_quote_app/services/constants.dart';
import 'package:flutter_quote_app/util/quote.dart';
import 'package:flutter_quote_app/util/quotelist.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
//import 'package:getflutter/getflutter.dart';
//import 'package:getflutter/components/button/gf_button.dart';
import 'package:flutter_quote_app/util/stringUtil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
//import 'package:flutter_quote_app/pages/favorite.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ScrollController scrollController = new ScrollController();
  QuoteList quoteList = new QuoteList();
  int pageNum = 0;
  bool lastPage = false;
  List<Quote> quotes;
  String pageTitle = 'Quotes';
  bool isLoading = false;
  String tagName;
  final String quoteBox = Constants.QUOTE_BOX;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (!lastPage) {
          quoteList = await FetchQuoteService.fetchQuotes(pageNum + 1, tagName);
          setState(() {
            lastPage = quoteList.lastPage;
            pageNum = quoteList.pageNum;
            quotes.addAll(quoteList.quotes);
          });
        }
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    quoteList =
        pageNum == 0 ? ModalRoute.of(context).settings.arguments : quoteList;

    lastPage = pageNum == 0 ? quoteList.lastPage : lastPage;
    quotes = pageNum == 0 ? quoteList.quotes : quotes;
    pageNum = pageNum == 0 ? quoteList.pageNum : pageNum;

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: <Widget>[_drawHeader()] + _buildDrawer() +
          <Widget>[Divider(), _buildNightMode()  ],
        ),
      ),
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => FavoriteQuote(),
                          settings: RouteSettings()));
                },
                icon: Icon(
                  Icons.favorite_border,
                  size: 30.0,
                ),
                ),
          ),
        ],
        centerTitle: true,
        title: Text(pageTitle),
      ),
      body: isLoading
          ? Center(
              child: SpinKitCircle(
              color: Colors.grey[800],
            ))
          : Container(
            color: Theme.of(context).primaryColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: <Widget>[
                    Flexible(
                      child: ListView.separated(
                        separatorBuilder: (context, index) => Divider(
                          height: 16.0,
                          thickness: 1.0,
                        ),
                        itemCount: quotes.length,
                        controller: scrollController,
                        itemBuilder: (context, index) {
                          return ListTile(
                            key: Key("${quotes[index].quoteId}"),
                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(child: Icon(Icons.format_quote)),
                                Expanded(
                                  child: IconButton(
                                      icon: Icon(Icons.content_copy),
                                      onPressed: () {
                                        Clipboard.setData(ClipboardData(
                                            text: quotes[index].quoteBody));
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
                            title: SelectableText(
                              quotes[index].quoteBody,
                            ),
                            subtitle: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    '- ${quotes[index].quoteAuthor}',
                                    style: TextStyle(
                                      fontFamily: 'BarlowCondensedBold',
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                  quotes[index].quoteTag.isEmpty
                                      ? Container(height: 16.0,)
                                      : Container(
                                          padding: EdgeInsets.only(top: 10.0),
                                          width: 1000,
                                          height: 40,
                                          child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount:
                                                  quotes[index].quoteTag.length,
                                              itemBuilder: (context, tagIndex) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 4.0),
                                                  child: _buildButton(
                                                      btnText: StringUtil
                                                          .capitalizeFirst(
                                                              text: quotes[
                                                                      index]
                                                                  .quoteTag[
                                                                      tagIndex]
                                                                  .toString()),
                                                      onTap: () {
                                                        onTapAction(StringUtil
                                                            .capitalizeFirst(
                                                                text: quotes[
                                                                        index]
                                                                    .quoteTag[
                                                                        tagIndex]
                                                                    .toString()));
                                                      }),
//                                                  child: GFButton(
//                                                    hoverColor: GFColor.info,
//                                                    onPressed: () {
//                                                      onTapAction(StringUtil
//                                                          .capitalizeFirst(
//                                                              text: quotes[
//                                                                      index]
//                                                                  .quoteTag[
//                                                                      tagIndex]
//                                                                  .toString()));
//                                                    },
//                                                    text: StringUtil
//                                                        .capitalizeFirst(
//                                                            text: quotes[index]
//                                                                .quoteTag[
//                                                                    tagIndex]
//                                                                .toString()),
//                                                    shape: GFButtonShape.pills,
//                                                    size: GFSize.small,
//                                                    type: GFButtonType.outline,
//                                                  ),
                                                );
                                              }),
                                        )
                                ],
//                            Row(
//                              children: quotes[index].quoteTag.map((tag) {
//                                return GFButton(
//                                  onPressed: (){},
//                                  text: tag,
//                                  shape: GFButtonShape.pills,
//                                  size: GFSize.small,
//                                  icon: Icon(Icons.tag_faces),
//                                  type: GFButtonType.outline,
//                                );
//                              }).toList(),
//                            )
                              ),
                            ),
                            trailing: ValueListenableBuilder(
                              valueListenable: Hive.box<Quote>(quoteBox)
                                  .listenable(keys: [quotes[index].quoteId]),
                              builder: (context, box, widget) {
                                return IconButton(
                                  onPressed: () {
                                    if (box
                                        .containsKey(quotes[index].quoteId)) {
                                      box.delete(quotes[index].quoteId);
                                      return;
                                    }
                                    box.put(
                                        quotes[index].quoteId, quotes[index]);
                                  },
                                  icon: Icon(
                                      box.containsKey(quotes[index].quoteId)
                                          ? Icons.favorite
                                          : Icons.favorite_border),
                                  color: Colors.red,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    lastPage
                        ? ListTile(
                            title: Text('This is last page...'),
                            leading: Icon(Icons.info_outline),
                          )
                        : Container()
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildQuote(Quote quote) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(quote.quoteBody),
            SizedBox(
              height: 5.0,
            ),
            Text('- ${quote.quoteAuthor}'),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({String btnText, Function onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3.0,),
      child: ButtonTheme(
        minWidth: 100.0,
        height: 100.0,
        child: RaisedButton(
          onPressed: onTap,
          child: Text(btnText),
          color: Theme.of(context).bottomAppBarColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
          )
        ),
      ),
    );
  }

  List<Widget> _buildDrawer() {
    List<Map> quoteTags = [
      {'title': 'Love', 'icon': Icons.device_hub},
      {'title': 'Truth', 'icon': Icons.security},
      {'title': 'Good', 'icon': Icons.hdr_strong},
      {'title': 'Programming', 'icon': Icons.computer},
      {'title': 'Life', 'icon': Icons.supervised_user_circle},
    ];

    return quoteTags
        .map((tag) => ListTile(
              title: Text(tag['title']),
              trailing: Icon(Icons.arrow_forward),
              leading: Icon(tag['icon']),
              onTap: () {
                onTapAction(tag['title'], true);
              },
            ))
        .toList();
  }

  Widget _drawHeader() {
    return DrawerHeader(
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.fill, image: AssetImage('assets/images/drawer_bg.jpg')),
      ),
      child: Stack(children: <Widget>[
        Positioned(
          left: 10.0,
          bottom: 20.0,
          child: Text(
            'TAGS',
            style: TextStyle(
                fontSize: 30.0,
                fontFamily: 'BarlowCondensedBold',
                color: Colors.grey[800]),
          ),
        )
      ]),
    );
  }

  void onTapAction(String tagTitle, [bool fromDrawer = false]) async {
    setState(() {
      isLoading = true;
    });
    if (fromDrawer) Navigator.pop(context);
    quoteList = await FetchQuoteService.fetchQuotes(1, tagTitle);

    setState(() {
      tagName = tagTitle;
      isLoading = false;
      pageTitle = '$tagTitle Quotes';
      lastPage = quoteList.lastPage;
      pageNum = quoteList.pageNum;
      quotes.clear();
      quotes.addAll(quoteList.quotes);
    });
  }

  Widget _buildNightMode(){

    final box = Hive.box(Constants.SETTINGS_BOX);

    var darkMode = box.get('darkMode', defaultValue: false);

    return ListTile(
      leading: Icon(FontAwesomeIcons.moon),
      title: Text('Night Mode'),
      trailing: Switch(
        value: darkMode,
        onChanged: (value){
          box.put('darkMode', !darkMode);
        },
      ),
    );
  }
}

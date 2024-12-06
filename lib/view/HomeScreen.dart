import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/Models/categoreis_news_model.dart';
import 'package:news_app/Models/news_channel_headlines_models.dart';
import 'package:news_app/view/categories_screen.dart';
import 'package:news_app/view/news_detail_screen.dart';
import 'package:news_app/view_model/news_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

enum FilterList { BBC_News, CNN, google_news }

class _HomescreenState extends State<Homescreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  FilterList? selectedMenu;
  String selectedSource = 'bbc-news'; // Default source
  Future<NewsChannelHeadLinesModel>? _futureHeadlines;

  final format = DateFormat('MMMM dd , yyyy');

  @override
  void initState() {
    super.initState();
    _futureHeadlines = newsViewModel.fetchNewsChannelHeadlinesApi(channelName: selectedSource);
  }

  void _updateNews(String source) {
    setState(() {
      selectedSource = source;
      _futureHeadlines = newsViewModel.fetchNewsChannelHeadlinesApi(channelName: selectedSource);
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => CategoriesScreen()));
          },
          icon: Image.asset('images/category_icon.png', height: 30, width: 30),
        ),
        title: Center(
          child: Text(
            'Headline Hub',
            style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700),
          ),
        ),
        actions: [
          PopupMenuButton<FilterList>(
            initialValue: selectedMenu,
            icon: Icon(Icons.more_vert, color: Colors.black),
            onSelected: (FilterList item) {
              switch (item) {
                case FilterList.BBC_News:
                  _updateNews('bbc-news');
                  break;
                case FilterList.CNN:
                  _updateNews('cnn');
                  break;
                case FilterList.google_news:
                  _updateNews('google-news');
                  break;
              }
              setState(() {
                selectedMenu = item;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<FilterList>>[
              const PopupMenuItem<FilterList>(
                value: FilterList.BBC_News,
                child: Text('BBC News'),
              ),
              const PopupMenuItem<FilterList>(
                value: FilterList.CNN,
                child: Text('CNN News'),
              ),
              const PopupMenuItem<FilterList>(
                value: FilterList.google_news,
                child: Text('Google News'),
              ),
            ],
          ),
        ],
      ),
      body: Flexible(
        child: ListView(
          children: [
            SizedBox(
              height: height * 0.55,
              width: width,
              child: FutureBuilder<NewsChannelHeadLinesModel>(
                future: _futureHeadlines,
                builder: (BuildContext context, AsyncSnapshot<NewsChannelHeadLinesModel> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SpinKitSpinningLines(
                        size: 50,
                        color: Colors.blueAccent,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.articles!.isEmpty) {
                    return Center(child: Text('No articles found'));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.articles!.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                        return InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetailScreen(
                                newsImage: snapshot.data!.articles![index].urlToImage.toString(),
                                newsTitle: snapshot.data!.articles![index].title.toString(),
                                newsDate: snapshot.data!.articles![index].publishedAt.toString(),
                                author: snapshot.data!.articles![index].author.toString(),
                                description: snapshot.data!.articles![index].description.toString(),
                                content: snapshot.data!.articles![index].content.toString(),
                                source: snapshot.data!.articles![index].source!.name.toString())));
                          },
                          child: SizedBox(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: height * 0.6,
                                  width: width * 0.9,
                                  padding: EdgeInsets.symmetric(horizontal: height * 0.02),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(child: spinKit2),
                                      errorWidget: (context, url, error) => Icon(Icons.error_outline, color: Colors.red),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 20,
                                  child: Card(
                                    elevation: 5,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(15),
                                      alignment: Alignment.bottomCenter,
                                      height: height * 0.22,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: width * 0.7,
                                            child: Text(
                                              snapshot.data!.articles![index].title.toString(),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          Spacer(),
                                          Container(
                                            width: width * 0.7,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  snapshot.data!.articles![index].source!.name.toString(),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
                                                ),
                                                Text(
                                                  format.format(dateTime),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: FutureBuilder<CategoriesNewsModel>(
                future: newsViewModel.fetchCategoriesNewsApi(category: 'General'),
                builder: (BuildContext context, AsyncSnapshot<CategoriesNewsModel> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SpinKitSpinningLines(
                        size: 50,
                        color: Colors.blueAccent,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.articles!.isEmpty) {
                    return Center(child: Text('No articles found'));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.articles!.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
        
                        return InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetailScreen(
                                newsImage: snapshot.data!.articles![index].urlToImage.toString(),
                                newsTitle: snapshot.data!.articles![index].title.toString(),
                                newsDate: snapshot.data!.articles![index].publishedAt.toString(),
                                author: snapshot.data!.articles![index].author.toString(),
                                description: snapshot.data!.articles![index].description.toString(),
                                content: snapshot.data!.articles![index].content.toString(),
                                source: snapshot.data!.articles![index].source!.name.toString())));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                    fit: BoxFit.cover,
                                    height: height * .18,
                                    width: width * .3,
                                    placeholder: (context, url) => Container(child: spinKit2),
                                    errorWidget: (context, url, error) => Icon(Icons.error_outline, color: Colors.red),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: height * 0.18,
                                    padding: EdgeInsets.only(left: 15),
                                    child: Column(
                                      children: [
                                        Text(
                                          snapshot.data!.articles![index].title.toString(),
                                          maxLines: 3,
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Spacer(),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              snapshot.data!.articles![index].source!.name.toString(),
                                              maxLines: 3,
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                color: Colors.black54,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              format.format(dateTime),
                                              maxLines: 3,
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/Models/categoreis_news_model.dart';
import 'package:news_app/view/HomeScreen.dart';
import 'package:news_app/view_model/news_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  FilterList? selectedMenu;
  final format = DateFormat('MMMM dd, yyyy');
  String categoryName = 'general';

  List<String> CategoriesList = [
    'General',
    'Entertainment',
    'Health',
    'Sports',
    'Business',
    'Technology'
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: CategoriesList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      categoryName = CategoriesList[index];
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: categoryName == CategoriesList[index] ? Colors.blue : Colors.blueGrey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        CategoriesList[index].toString(),
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: FutureBuilder<CategoriesNewsModel>(
              future: newsViewModel.fetchCategoriesNewsApi(category: categoryName),
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
                    itemBuilder: (context, index) {
                      DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: CachedNetworkImage(
                                imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                fit: BoxFit.cover,
                                height : height * .18,
                                width : width * .3,

                                placeholder: (context, url) => Container(child: spinKit2),
                                errorWidget: (context, url, error) => Icon(Icons.error_outline, color: Colors.red),
                              ),
                            ),
                            Expanded(child: Container(
                              height: height * 0.18,
                              padding: EdgeInsets.only(left : 15),
                              child: Column(
                                children: [
                                  Text(snapshot.data!.articles![index].title.toString(),
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
                                      Text(snapshot.data!.articles![index].source!.name.toString(),
                                        maxLines: 3,
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w600,


                                        ),
                                      ),

                                      Text(format.format(dateTime),
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
                            ))
                          ],
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
    );
  }
}

const spinKit2 = SpinKitSpinningLines(
  color: Colors.red,
  size: 50,
);

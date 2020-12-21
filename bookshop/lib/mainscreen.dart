import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'books.dart';
import 'detailscreen.dart';

void main() => runApp(MaterialApp(
      home: MainScreen(),
    ));

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List booklist;

  double screenHeight, screenWidth;
  String titlecenter = "Loading Book Data...";

  @override
  void initState() {
    super.initState();
    _loadBook();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text('Book List'),
      ),
      body: Column(
        children: [
          booklist == null
              ? Flexible(
                  child: Container(
                      child: Center(
                          child: Text(titlecenter,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              )))))
              : Flexible(
                  child: GridView.count(
                    crossAxisCount: 2,
                    children: List.generate(
                      booklist.length,
                      (index) {
                        return Padding(
                            padding: EdgeInsets.all(1),
                            child: Card(
                                child: InkWell(
                              onTap: () => _loadBookDetail(index),
                              child: SingleChildScrollView(
                                  child: Column(
                                children: [
                                  Container(
                                      height: 100,
                                      width: 100,
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "http://slumberjer.com/bookdepo/bookcover/${booklist[index]['cover']}.jpg",
                                        placeholder: (context, url) =>
                                            new CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            new Icon(
                                          Icons.broken_image,
                                          size: screenWidth / 2,
                                        ),
                                      )),
                                  Text(booklist[index]['booktitle'],
                                      textAlign: TextAlign.center),
                                  Text("Author："+booklist[index]['author'],
                                      textAlign: TextAlign.center),
                                  Text("RM：" + booklist[index]['price'],
                                      textAlign: TextAlign.center),
                                  Text("Rating："+booklist[index]['rating'],
                                      textAlign: TextAlign.center),
                                ],
                              )),
                            )));
                      },
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  void _loadBook() {
    print("Load Books Data");
    http.post("http://slumberjer.com/bookdepo/php/load_books.php",
        body: {}).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        booklist = null;
      } else {
        setState(() {
          var jsondata = json.decode(res.body); //decode json data
          booklist = jsondata["books"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  _loadBookDetail(int index) {
    print(booklist[index]['cover']);
    Books b = new Books(
        bookid: booklist[index]['bookid'],
        booktitle: booklist[index]['booktitle'],
        author: booklist[index]['author'],
        price: booklist[index]['price'],
        description: booklist[index]['description'],
        rating: booklist[index]['rating'],
        publisher: booklist[index]['publisher'],
        isbn: booklist[index]['isbn'],
        cover: booklist[index]['cover']);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => DetailScreen(books: b)));
  }
}

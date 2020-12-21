import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'books.dart';

class DetailScreen extends StatefulWidget {
  final Books books;

  const DetailScreen({Key key, this.books}) : super(key: key);
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  List bookList;
  String titlecenter = "Loading Books...";
  @override
  void initState() {
    super.initState();
    _loadbooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text(
          widget.books.booktitle,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        color: Colors.yellowAccent,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  child: CachedNetworkImage(
                imageUrl:
                    "http://slumberjer.com/bookdepo/bookcover/${widget.books.cover}.jpg",
                fit: BoxFit.none,
                placeholder: (context, url) => new CircularProgressIndicator(),
                errorWidget: (context, url, error) => new Icon(
                  Icons.broken_image,
                ),
              )),
              SizedBox(height: 10),
              Container(
                color: Colors.white70,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10.0, 15.0, 15.0, 10.0),
                  child: Column(
                    children: [
                      Text("Book ID: " + widget.books.bookid),
                      Text("Author: " + widget.books.author),
                      Text("Price: RM " + widget.books.price),
                      Text("Description: " + widget.books.description),
                      Text("Rating: " + widget.books.rating),
                      Text("Publisher: " + widget.books.publisher),
                      Text("ISBN: " + widget.books.isbn),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _loadbooks() {
    print("Load Books Data");
    http.post("http://slumberjer.com/bookdepo/php/load_books.php",
        body: {}).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        bookList = null;
      } else {
        setState(() {
          var jsondata = json.decode(res.body); //decode json data
          bookList = jsondata["books"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }
}

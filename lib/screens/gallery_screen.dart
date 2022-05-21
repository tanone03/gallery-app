import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:photo_app/screens/image_screen.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {

  List? galleryList;

  @override
  void initState() {
    super.initState();
    fetchImages();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Unsplash gallery'),
        elevation: 0,
      ),
      body: Container(
        child: galleryList == null ? const Center(child: CircularProgressIndicator()) : ListView.separated(
          itemBuilder: (context, index) => GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                String imageUrl = galleryList![index]['urls']['regular'];
                return ImageScreen(image: imageUrl);
              }));
            },
            child: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 250,
                  child: Image.network(
                    galleryList![index]['urls']['regular'],
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black.withOpacity(0.4),
                    child: Text(
                      galleryList![index]['user']['name'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          separatorBuilder: (_, index) => const SizedBox(height: 10),
          itemCount: galleryList!.length,
        )
      ),
    );
  }

  void fetchImages() async {
    final response = await http.get(
      Uri.parse('https://api.unsplash.com/photos/?client_id=ab3411e4ac868c2646c0ed488dfd919ef612b04c264f3374c97fff98ed253dc9'),
    );
    var unsplashData = json.decode(response.body);
    setState(() {
      galleryList = unsplashData;
    });
  }
}
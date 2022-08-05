// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jutta_ghar/tiles/review_tile.dart';

class ReviewPage extends StatefulWidget {
  final productId;
  const ReviewPage({Key? key, this.productId}) : super(key: key);

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.5,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Text(
          "REVIEW",
          style: TextStyle(
              fontSize: 15.5, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body:
          //----Review Comments-----
          Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("products")
                .doc(widget.productId)
                .collection("review")
                .snapshots(),
            builder: ((context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: Text("Loading..."));
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: Text("Loading..."));
              } else {
                List<QueryDocumentSnapshot<Object?>> fireStoreReviews =
                    snapshot.data!.docs;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: fireStoreReviews.length,
                  itemBuilder: ((context, index) => ReviewTile(
                        reviewText: fireStoreReviews[index]["comment"],
                        userName: fireStoreReviews[index]["name"],
                        timeStamp:
                            fireStoreReviews[index]["timestamp"].toString(),
                      )),
                );
              }
            })),
      ),
    );
  }
}

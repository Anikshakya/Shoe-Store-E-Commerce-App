import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jutta_ghar/tiles/following_tile.dart';
import 'package:jutta_ghar/views/brand_page.dart';
import 'package:jutta_ghar/widgets/custom_refresher_widget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FollowingPage extends StatefulWidget {
  const FollowingPage({Key? key}) : super(key: key);

  @override
  State<FollowingPage> createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
  var user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "FOLLOWED STORES",
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        elevation: 2.0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: CustomRefreshWidget(
        widget: const Padding(
          padding: EdgeInsets.only(top: 40),
          child: SpinKitThreeBounce(
            color: Colors.black,
            size: 24.0,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("following")
                      .doc(user?.email)
                      .collection('pages')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      List<QueryDocumentSnapshot<Object?>> firestoreitems =
                          snapshot.data!.docs;
                      return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: firestoreitems.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return FollowingTile(
                                logo: firestoreitems[index]['page_logo'],
                                name: firestoreitems[index]['page_name'],
                                website: firestoreitems[index]['page_website'],
                                id: firestoreitems[index]['page_id'].toString(),
                                pageEmail: firestoreitems[index]['page_email'],
                                ontap: () {
                                  Get.to(() => BrandPage(
                                       logo: firestoreitems[index]['page_logo'],
                                brandName: firestoreitems[index]['page_name'],
                                website: firestoreitems[index]['page_website'],
                                id: firestoreitems[index]['page_id'],
                                image: firestoreitems[index]['page_image'],
                                pageEmail: firestoreitems[index]['page_email'],
                                      ));
                                });
                          });
                    }
                  }),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jutta_ghar/views/order_history_tile.dart';
import 'package:jutta_ghar/widgets/custom_refresher_widget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({Key? key}) : super(key: key);

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  var user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "ORDER HISTORY",
          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),),
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
                      .collection("order_requests")
                      .doc(user?.email)
                      .collection('products')
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
                            return OrderHistoryTile(
                              image: firestoreitems[index]['image'],
                              productName: firestoreitems[index]['productName'],
                              productId: firestoreitems[index]['productID'],
                            );
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

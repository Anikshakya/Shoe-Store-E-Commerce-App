// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jutta_ghar/tiles/products_tiles.dart';
import 'package:jutta_ghar/views/order_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class BusinessPage extends StatefulWidget {
  final pageName, image, logo, website, id, description, pageEmail;
  const BusinessPage({
    Key? key,
    this.pageName,
    this.image,
    this.logo,
    this.website,
    required this.pageEmail,
    this.id, this.description,
  }) : super(key: key);

  @override
  State<BusinessPage> createState() => _BusinessPageState();
}

class _BusinessPageState extends State<BusinessPage> {
  final user = FirebaseAuth.instance.currentUser;
  var searchKey = "";
  final clearSearchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          widget.pageName.toUpperCase(),
          style: const TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Brand Image & logo
              Stack(
                children: [
                  widget.image == ''
                  ?Image.asset(
                    "images/profile.png",
                    width: MediaQuery.of(context).size.width,
                    height: 182,
                      fit: BoxFit.cover,
                    )
                  : CachedNetworkImage(
                    fadeInDuration: const Duration(milliseconds: 0),
                    fadeOutDuration: const Duration(milliseconds: 0),
                    imageUrl: widget.image,
                    width: MediaQuery.of(context).size.width,
                    height: 182,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 182,
                    decoration: const BoxDecoration(color: Color.fromARGB(131, 185, 185, 185)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                child: Container(
                                  height: 84,
                                  width: 84,
                                  color: Colors.white,
                                  child: widget.logo == ''
                                  ?Image.asset(
                                      "images/profile.png",
                                      height: 80,
                                      width: 80,
                                      fit: BoxFit.cover,
                                    )
                                    :CachedNetworkImage(
                                    imageUrl: widget.logo,
                                    fit: BoxFit.cover,
                                    height: 75,
                                    width: 75,
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.pageName,
                                    style:  const TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    widget.description,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                   Row(
                                     children:[
                                      const Text('Followers: ', style: TextStyle(color: Colors.white),),
                                      //Followers
                                      StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection("pages")
                                      .doc(widget.pageEmail)
                                      .collection("followers")
                                      .snapshots(),
                                  builder: ((context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const SizedBox();
                                    } else if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const SizedBox();
                                    } else {
                                      List<QueryDocumentSnapshot<Object?>>
                                          firestoreData = snapshot.data!.docs;
                                      return Container(
                                        height: 17,
                                        width: 17,
                                        decoration: const BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 255, 217, 193),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text( firestoreData.length.toString(),
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 11),
                                          ),
                                        ),
                                      );
                                    }
                                  }),
                                ),
                                     ],
                                   ),
                                ],
                              ),
                             StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance.collection('following').doc(user!.email).collection('pages').where('page_id', isEqualTo: widget.id.toString()).snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                      return const SizedBox();
                                    } else if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const SizedBox();
                                    }else{
                                      List<QueryDocumentSnapshot<Object?>> firestoreData =snapshot.data!.docs;
                                      return ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      onPrimary: Colors.white,
                                      primary: Colors.black87,
                                    ),
                                    onPressed: (){
                                     firestoreData.isNotEmpty ? unfollow(): follow();
                                    },
                                    child:
                                    firestoreData.isNotEmpty? const Text('Unfollow'): const Text ('Follow'),
                                  );
                                }
                               }
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          widget.website == ''
                          ?const SizedBox()
                          :GestureDetector(
                            onTap: (){
                              launchUrlString(widget.website.toString());
                            },
                            child: Row(
                              children: const [
                                Text(
                                  "Visit our website:",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.link,
                                  color: Colors.white,
                                  size: 28,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              //Posts
              ElevatedButton(
                style: ElevatedButton.styleFrom(onPrimary: Colors.white, primary: Colors.black87,),
                  onPressed: () {},
                  child: const Text("Posts"),
              ),
              //Body
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 216, 216, 216),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: TextField(
                    textCapitalization: TextCapitalization.words,
                    onChanged: ((value) {
                      setState(() {
                        searchKey = value;
                      });
                    }),
                    controller: clearSearchController,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color.fromARGB(255, 75, 75, 75),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            clearSearchController.clear();
                          },
                          child: const Icon(
                            Icons.clear,
                            color: Color.fromARGB(255, 136, 136, 136),
                          ),
                        ),
                        hintText: 'Search Products...',
                        hintStyle: const TextStyle(
                          color: Colors.white,
                        ),
                        border: InputBorder.none),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 7),
                child: StreamBuilder<QuerySnapshot>(
                  stream: (searchKey != "")
                      ? FirebaseFirestore.instance
                          .collection('products')
                          .where("productName",
                              isGreaterThanOrEqualTo: searchKey)
                          .where("productName", isLessThan: searchKey + 'z')
                          .snapshots()
                      : FirebaseFirestore.instance
                          .collection("products")
                          .snapshots(),
                  builder: (BuildContext context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      List<QueryDocumentSnapshot<Object?>> firestoreProducts =
                          snapshot.data!.docs;
                      return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Wrap(
                          children: List.generate(
                            firestoreProducts.length,
                            (index) => firestoreProducts[index]
                                        ['brand_store'] ==
                                    widget.pageName
                                ? ProductTile(
                                    name: firestoreProducts[index]
                                        ["productName"],
                                    description: firestoreProducts[index]
                                        ["description"],
                                    discount: firestoreProducts[index]
                                            ["discount"]
                                        .toString(),
                                    price: firestoreProducts[index]["price"]
                                        .toString(),
                                    image: firestoreProducts[index]["image"],
                                    ontap: () => Get.to(
                                      () => OrderPage(
                                        image: firestoreProducts[index]
                                            ['image'],
                                        price: firestoreProducts[index]
                                            ['price'],
                                        name: firestoreProducts[index]
                                            ['productName'],
                                        brand: firestoreProducts[index]
                                            ['brand_store'],
                                        description: firestoreProducts[index]
                                            ["description"],
                                        discount: firestoreProducts[index]
                                                ['discount']
                                            .toString(),
                                        category: firestoreProducts[index]
                                            ['category'],
                                        offer: firestoreProducts[index]
                                            ['offer'],
                                        productID: firestoreProducts[index]
                                            ['productID'],
                                        type: firestoreProducts[index]['type'],
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //
  Future follow() async {
    final user = FirebaseAuth.instance.currentUser;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {

      //followers count of page
       Map<String, dynamic> pageFollowerCount = {
        'folower_email': user!.email,
      };

      DocumentReference pageFollowerCountRef = FirebaseFirestore.instance
          .collection("pages")
          .doc(widget.pageEmail)
          .collection("followers")
          .doc(user.email);
      pageFollowerCountRef.set(pageFollowerCount);

      //following count of user
      DocumentReference documentReferencer = FirebaseFirestore.instance
          .collection("following")
          .doc(user.email)
          .collection("pages")
          .doc(widget.id);
      Map<String, dynamic> data = {
        'page_name': widget.pageName,
        'page_id': widget.id,
        'page_logo': widget.logo,
        'page_image': widget.image,
        'page_website': widget.website,
        'page_email':widget.pageEmail,
      };
      documentReferencer.set(data).then((value) => Navigator.pop(context)).then(
          (value) => Get.snackbar("Following", "Succesfully followed",
              backgroundColor: const Color.fromARGB(115, 105, 240, 175)));
    } on FirebaseException catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.redAccent);
    }
  }

  unfollow() {
    var user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection("following")
        .doc(user!.email)
        .collection("pages")
        .doc(widget.id)
        .delete()
        .then((value) => Get.snackbar("Unfollowed","You have unfollowed the page",duration: const Duration(seconds: 1),));
    
    FirebaseFirestore.instance
        .collection("pages")
        .doc(widget.pageEmail)
        .collection("followers")
        .doc(user.email)
        .delete();
  }
}

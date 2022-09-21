import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jutta_ghar/utils/utils.dart';
import 'package:jutta_ghar/views/edit_business_page.dart';
import 'package:url_launcher/url_launcher_string.dart';

class BusinssPageAdmin extends StatefulWidget {
  const BusinssPageAdmin({Key? key}) : super(key: key);

  @override
  State<BusinssPageAdmin> createState() => _BusinssPageAdminState();
}

class _BusinssPageAdminState extends State<BusinssPageAdmin> {
  var user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //Head
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("pages")
                  .where('email', isEqualTo: user!.email.toString())
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Text("No data found....");
                } else {
                  List<QueryDocumentSnapshot<Object?>> fireStoreItems =
                      snapshot.data!.docs;
                  return
                      //Brand Image & logo
                    Stack(
                    children: [
                      fireStoreItems[0]['image'] != ""
                          ? CachedNetworkImage(
                              fadeInDuration: const Duration(milliseconds: 0),
                              fadeOutDuration: const Duration(milliseconds: 0),
                              imageUrl: fireStoreItems[0]['image'],
                              width: MediaQuery.of(context).size.width,
                              height: 182,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              "images/profile.png",
                              fit: BoxFit.cover,
                            ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 182,
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(131, 185, 185, 185)),
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
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    child: Container(
                                      height: 84,
                                      width: 84,
                                      color: Colors.white,
                                      child: fireStoreItems[0]['logo'] != ""
                                          ? CachedNetworkImage(
                                              imageUrl: fireStoreItems[0]['logo'],
                                              height: 80,
                                              width: 80,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset(
                                              "images/profile.png",
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        fireStoreItems[0]['name'],
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        fireStoreItems[0]['description'],
                                        maxLines: 5,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                      const Text(
                                        'asdfg',
                                        style:TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      onPrimary: Colors.white,
                                      primary: Colors.black87,
                                    ),
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>EditBusinessPage(editName: fireStoreItems[0]['name'], editWebsite: fireStoreItems[0]['website'], editDescription: fireStoreItems[0]['description'], editContact: fireStoreItems[0]['contact'],)));
                                    },
                                    child: const Text("Edit Page"),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Row(
                                  children:  [
                                    const Text(
                                      "Visit our website:",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        launchUrlString(fireStoreItems[0]['website']);
                                      },
                                      child: const Icon(
                                        Icons.link,
                                        color: Colors.white,
                                        size: 28,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
            
            //Body
            Container(
              width: double.infinity,
              height:MediaQuery.of(context).size.height * 0.08,
              margin: const EdgeInsets.only(top: 5.0),
              decoration: Utils.containerShadow(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                const Icon(Icons.post_add_rounded),
                ElevatedButton(onPressed: (){}, child: const Text("Create a new Post"))
              ],),
            ),
          ],
        ),
      ),
    );
  }
}



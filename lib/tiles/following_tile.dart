// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FollowingTile extends StatelessWidget {
  final logo, name, id, website, pageEmail;
  final VoidCallback ontap;
  const FollowingTile(
      {Key? key,
      required this.ontap,
      this.logo,
      this.name,
      this.id,
      this.website, 
      required this.pageEmail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(232, 186, 187, 187),
              offset: Offset(2, 2),
              blurRadius: 3,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Container(
                  height: 84,
                  width: 84,
                  color: Colors.white,
                  child: CachedNetworkImage(
                    imageUrl: logo,
                    height: 75,
                    width: 75,
                  ),
                ),
              ),
              Text(name),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.white,
                  primary: Colors.black87,
                ),
                onPressed: () => unfollow(),
                child: const Text("Unfollow"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  unfollow() {
    var user = FirebaseAuth.instance.currentUser;

    //For users unfollow count
    FirebaseFirestore.instance
        .collection("following")
        .doc(user!.email)
        .collection("pages")
        .doc(id)
        .delete()
        .then((value) => Get.snackbar(
              "Unfollowed",
              "",
              duration: const Duration(seconds: 1),
            ));
    //For brand unfollow count
    FirebaseFirestore.instance
        .collection("brand")
        .doc(name)
        .collection("followers")
        .doc(user.email)
        .delete();

   //For page unfollow count
   FirebaseFirestore.instance
        .collection("pages")
        .doc(pageEmail)
        .collection("followers")
        .doc(user.email)
        .delete();
  }
}

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';

class EditBusinessPage extends StatefulWidget {
  final String? editName, editWebsite, editDescription, editContact;
  const EditBusinessPage({Key? key, this.editName, this.editWebsite, this.editDescription, this.editContact})
      : super(key: key);

  @override
  State<EditBusinessPage> createState() => _EditBusinessPageState();
}

class _EditBusinessPageState extends State<EditBusinessPage> {
  @override
  void initState() {
    nameController.text = widget.editName!;
    websiteLinkController.text = widget.editWebsite!;
    contactController.text = widget.editContact!;
    descriptionController.text = widget.editDescription!;
    super.initState();
  }

  File? _imageFile;
  File? _logoFile;
  final user = FirebaseAuth.instance.currentUser;
  final box = GetStorage();
  var nameController = TextEditingController();
  final websiteLinkController = TextEditingController();
  final contactController = TextEditingController();
  final descriptionController = TextEditingController();

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      setState(() {
        _imageFile =
            File(image.path); //saves image in a file and files location
        box.write("a", _imageFile); //saves image path location to box storage "a"
      });
    } on PlatformException catch (e) {
      // ignore: avoid_print
      print("Failed to pick image: $e");
    }
  }

  Future pickLogo(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      setState(() {
        _logoFile = File(image.path); //saves image in a file and files location
        box.write("logo", _logoFile); //saves image path location to box storage "a"
      });
    } on PlatformException catch (e) {
      // ignore: avoid_print
      print("Failed to pick image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: const Text("Edit Page", style: TextStyle(color: Colors.black,),),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black,),
        leading: IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (conext) {
                return AlertDialog(
                  title: const Text("Unsaved changes"),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: const <Widget>[
                        Text('Are you sure you want to cancel?'),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('No'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      child: const Text('Yes'),
                      onPressed: () {
                        setState(
                          () {
                            box.write("a", null);
                          },
                        );
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              },
            );
          },
          icon: const Icon(Icons.clear),
        ),
        actions: [
          IconButton(
            onPressed: () {
              uploadFile(context);
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("pages")
                    .where('email', isEqualTo: user!.email)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Text("No data found....");
                  } else {
                    List<QueryDocumentSnapshot<Object?>> fireStoreItems =
                        snapshot.data!.docs;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //Edit Logo
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: InteractiveViewer(
                                            child: AlertDialog(
                                              titlePadding: const EdgeInsets.all(0),
                                              title: box.read("logo") != null
                                                  ? Image.file(
                                                      box.read("logo"),
                                                      fit: BoxFit.cover,
                                                    )
                                                  : fireStoreItems[0]['logo'] == ""
                                                      ? Image.asset(
                                                          "images/profile.png",
                                                          fit: BoxFit.cover,
                                                        )
                                                      : CachedNetworkImage(
                                                          imageUrl: fireStoreItems[0]['logo'],
                                                          fit: BoxFit.cover,
                                                        ),
                                            ),
                                          ),
                                        ));
                                        },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: box.read("logo") != null
                                    ? Image.file(
                                        box.read("logo"),
                                        height: 80,
                                        width: 80,
                                        fit: BoxFit.cover,
                                      )
                                    : fireStoreItems[0]['logo'] == ""
                                        ? Image.asset(
                                            "images/profile.png",
                                            height: 80,
                                            width: 80,
                                            fit: BoxFit.cover,
                                          )
                                        : CachedNetworkImage(
                                            imageUrl: fireStoreItems[0]['logo'],
                                            height: 80,
                                            width: 80,
                                            fit: BoxFit.cover,
                                          ),
                              ),
                            ),
                            const SizedBox(height: 20,),
                            SizedBox(
                            height: 45,
                              // width: MediaQuery.of(context).size.width / 2,
                              child: ElevatedButton(
                                child: const Text('Edit Logo'),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  primary: Colors.white,
                                  onPrimary: Colors.black,
                                ),
                                onPressed: () {
                                  showModalBottomSheet<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Container(
                                        height: 160,
                                        color: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  pickLogo(ImageSource.camera).then(
                                                      (value) => Navigator.pop(context));
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    primary: Colors.white,
                                                    onPrimary: Colors.black,
                                                    padding: const EdgeInsets.all(20)),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: const [
                                                    Icon(
                                                      Icons.camera_alt,
                                                      color: Colors.teal,
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Text(
                                                      'Upload image from Camera',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    primary: Colors.white,
                                                    onPrimary: Colors.black,
                                                    padding: const EdgeInsets.all(20)),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: const [
                                                    SizedBox(
                                                      width: 4,
                                                    ),
                                                    Icon(
                                                      Icons.image,
                                                      color: Colors.teal,
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Text(
                                                      'Upload image from Gallery',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.w500),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                  ],
                                                ),
                                                onPressed: () {
                                                  pickLogo(ImageSource.gallery).then(
                                                    (value) => Navigator.pop(context),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        //Edit Cover Photo
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: InteractiveViewer(
                                            child: AlertDialog(
                                              titlePadding: const EdgeInsets.all(0),
                                              title: box.read("a") != null
                                                  ? Image.file(
                                                      box.read("a"),
                                                      fit: BoxFit.cover,
                                                    )
                                                  : fireStoreItems[0]['image'] ==
                                                          ""
                                                      ? Image.asset(
                                                          "images/profile.png",
                                                          fit: BoxFit.cover,
                                                        )
                                                      : CachedNetworkImage(
                                                          imageUrl: fireStoreItems[0]['image'],
                                                          fit: BoxFit.cover,
                                                        ),
                                            ),
                                          ),
                                        ));
                                        },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: box.read("a") != null
                                    ? Image.file(
                                        box.read("a"),
                                        height: 80,
                                        width: 80,
                                        fit: BoxFit.cover,
                                      )
                                    : fireStoreItems[0]['image'] == ""
                                        ? Image.asset(
                                            "images/profile.png",
                                            height: 80,
                                            width: 80,
                                            fit: BoxFit.cover,
                                          )
                                        : CachedNetworkImage(
                                            imageUrl: fireStoreItems[0]['image'],
                                            height: 80,
                                            width: 80,
                                            fit: BoxFit.cover,
                                          ),
                              ),
                            ),
                            const SizedBox(height: 20,),
                            SizedBox(
                            height: 45,
                              // width: MediaQuery.of(context).size.width / 2,
                              child: ElevatedButton(
                                child: const Text('Edit Cover Image'),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  primary: Colors.white,
                                  onPrimary: Colors.black,
                                ),
                                onPressed: () {
                                  showModalBottomSheet<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Container(
                                        height: 160,
                                        color: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  pickImage(ImageSource.camera).then(
                                                      (value) => Navigator.pop(context));
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    primary: Colors.white,
                                                    onPrimary: Colors.black,
                                                    padding: const EdgeInsets.all(20)),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: const [
                                                    Icon(
                                                      Icons.camera_alt,
                                                      color: Colors.teal,
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Text(
                                                      'Upload image from Camera',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    primary: Colors.white,
                                                    onPrimary: Colors.black,
                                                    padding: const EdgeInsets.all(20)),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: const [
                                                    SizedBox(
                                                      width: 4,
                                                    ),
                                                    Icon(
                                                      Icons.image,
                                                      color: Colors.teal,
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Text(
                                                      'Upload image from Gallery',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.w500),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                  ],
                                                ),
                                                onPressed: () {
                                                  pickImage(ImageSource.gallery).then(
                                                    (value) => Navigator.pop(context),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              const Divider(
                thickness: 1,
                indent: 10,
                endIndent: 10,
                color: Color.fromARGB(255, 37, 37, 37),
              ),
              //------Form------
              Container(
                padding: const EdgeInsets.only(
                    top: 15, left: 20, right: 20, bottom: 40),
                child: Column(
                  children: [
                    Form(
                      // key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            controller: nameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                              ),
                              prefixIcon: const Icon(
                                Icons.person,
                                size: 18,
                              ),
                              iconColor: Colors.grey,
                              hintText: 'Enter your page name',
                              labelText: 'Page Name',
                              labelStyle: const TextStyle(
                                color: Color.fromARGB(255, 102, 102, 102),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            controller: websiteLinkController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                              ),
                              prefixIcon: const Icon(
                                Icons.link,
                                size: 18,
                              ),
                              iconColor: Colors.grey,
                              hintText: 'Enter your Website Link',
                              labelText: 'Website',
                              labelStyle: const TextStyle(
                                color: Color.fromARGB(255, 102, 102, 102),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            controller: contactController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                              ),
                              prefixIcon: const Icon(
                                Icons.call,
                                size: 18,
                              ),
                              iconColor: Colors.grey,
                              hintText: 'Enter your Contact',
                              labelText: 'Contact',
                              labelStyle: const TextStyle(
                                color: Color.fromARGB(255, 102, 102, 102),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            controller: descriptionController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                              ),
                              prefixIcon: const Icon(
                                Icons.person,
                                size: 18,
                              ),
                              iconColor: Colors.grey,
                              hintText: 'Your Description',
                              labelText: 'Description',
                              labelStyle: const TextStyle(
                                color: Color.fromARGB(255, 102, 102, 102),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

Future uploadFile(context) async {
  if (_imageFile == null && _logoFile == null) {
    var user = FirebaseAuth.instance.currentUser;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
      //update file without image upload
      try {
        DocumentReference documentReferencer = FirebaseFirestore.instance.collection("pages").doc(user!.email);
        Map<String, dynamic> data = {
          'name': nameController.text.trim(),
          'website': websiteLinkController.text.trim(),
          'contact': contactController.text.trim(),
          'description': descriptionController.text.trim(),
        };
        await documentReferencer
            .update(data)
            .then((value) => Navigator.pop(context))
            .then((value) => Navigator.pop(context))
            .then((value) => Get.snackbar(
            "Successful", "Editeed Succcesfully",
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.greenAccent));
      } on FirebaseException catch (e) {
        Get.snackbar("Error", e.toString(),
          duration: const Duration(seconds: 2),
          backgroundColor: const Color.fromARGB(176, 255, 82, 82));
      }
    }else {
      var user = FirebaseAuth.instance.currentUser;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      //For Image
      if(_logoFile == null){
        final fileName = basename(_imageFile!.path);
      String destination = "images/$fileName";
         //-----Upload image File and update-----
      try {
        final ref = FirebaseStorage.instance.ref(destination);
        UploadTask uploadTask = ref.putFile(_imageFile!);
        uploadTask.whenComplete(() async {
          //download and update the file
          String imageUrl = await ref.getDownloadURL();
          if (imageUrl != '') {
            DocumentReference documentReferencer = FirebaseFirestore.instance.collection("pages").doc(user!.email);
            Map<String, dynamic> data = {
              'image': imageUrl,
              'name': nameController.text.trim(),
              'website': websiteLinkController.text.trim(),
              'description': descriptionController.text.trim(),
            };
            await documentReferencer
                .update(data)
                .then((value) => Navigator.pop(context))
                .then((value) => Navigator.pop(context))
                .then((value) =>Get.snackbar(
            "Successful", "Editeed Succcesfully",
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.greenAccent))
                .then((value) => setState(() {
                      box.write("a", null);
                    }));
          }
        });
      } on FirebaseException catch (e) {
        Get.snackbar("Error", e.toString(),
          duration: const Duration(seconds: 2),
          backgroundColor: const Color.fromARGB(176, 255, 82, 82));
      }
      } else if(_imageFile == null){ //-------------------For edit Logo------------------------
        final fileName = basename(_logoFile!.path);
       String destination = "images/$fileName";
      try {
        final ref = FirebaseStorage.instance.ref(destination);
        UploadTask uploadTask = ref.putFile(_logoFile!);
        uploadTask.whenComplete(() async {
          //download and update the file
          String logoUrl = await ref.getDownloadURL();
          if (logoUrl != '') {
            DocumentReference documentReferencer = FirebaseFirestore.instance.collection("pages").doc(user!.email);
            Map<String, dynamic> data = {
              'logo': logoUrl,
              'name': nameController.text.trim(),
              'website': websiteLinkController.text.trim(),
              'description': descriptionController.text.trim(),
            };
            await documentReferencer
                .update(data)
                .then((value) => Navigator.pop(context))
                .then((value) => Navigator.pop(context))
                .then((value) =>Get.snackbar(
            "Successful", "Editeed Succcesfully",
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.greenAccent))
                .then((value) => setState(() {
                      box.write("a", null);
                    }));
          }
        });
      } on FirebaseException catch (e) {
        Get.snackbar("Error", e.toString(),
          duration: const Duration(seconds: 2),
          backgroundColor: const Color.fromARGB(176, 255, 82, 82));
      }
     }
    }
}
}
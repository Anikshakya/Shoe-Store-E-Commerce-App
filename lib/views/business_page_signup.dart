import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jutta_ghar/utils/utils.dart';
import 'package:jutta_ghar/views/business_page.dart';

class BusinessPageSignUp extends StatefulWidget {
  const BusinessPageSignUp({Key? key}) : super(key: key);

  @override
  State<BusinessPageSignUp> createState() => _BusinessPageSignUpState();
}

class _BusinessPageSignUpState extends State<BusinessPageSignUp> {
  var date = DateTime.now();
  //Validator Key
  final formKey = GlobalKey<FormState>();

  //Text controllers
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final contactController = TextEditingController();
  final locationController = TextEditingController();
  final websiteController = TextEditingController();

  final descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "BUSINESS PAGE",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20),
          // color: Colors.white,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(45),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(232, 186, 187, 187),
                offset: Offset(1, 8),
                blurRadius: 10,
              ),
            ],
          ),
          padding:
              const EdgeInsets.only(left: 25, right: 25, top: 40, bottom: 50),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (name) =>
                      name!.isEmpty ? "Name field cannot be empty." : null,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  controller: nameController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.person,
                      size: 18,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    iconColor: Colors.teal,
                    hintText: 'Enter your Store Name',
                    labelText: 'Store Name',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    labelStyle: const TextStyle(
                      color: Color.fromARGB(255, 102, 102, 102),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email) =>
                      email != null && !EmailValidator.validate(email)
                          ? "Enter a valid email"
                          : null,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.email,
                      size: 18,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    iconColor: Colors.teal,
                    hintText: 'Enter your Email',
                    labelText: 'Email',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    labelStyle: const TextStyle(
                      color: Color.fromARGB(255, 102, 102, 102),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (name) =>
                      name!.isEmpty ? "Web Site field cannot be empty." : null,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  controller: websiteController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.person,
                      size: 18,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    iconColor: Colors.teal,
                    hintText: 'Enter your website',
                    labelText: 'Website',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    labelStyle: const TextStyle(
                      color: Color.fromARGB(255, 102, 102, 102),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (contact) =>
                      contact!.isEmpty ? "Contact cannot be empty." : null,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  controller: contactController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.phone,
                      size: 18,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    iconColor: Colors.teal,
                    hintText: 'Enter your Contact',
                    labelText: 'Contact',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    labelStyle: const TextStyle(
                      color: Color.fromARGB(255, 102, 102, 102),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (name) =>
                      name!.isEmpty ? "Address field cannot be empty." : null,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  controller: locationController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.person,
                      size: 18,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    iconColor: Colors.teal,
                    hintText: 'Enter your Address',
                    labelText: 'Address',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    labelStyle: const TextStyle(
                      color: Color.fromARGB(255, 102, 102, 102),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (name) => name!.isEmpty
                      ? "Description field cannot be empty."
                      : null,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  controller: descriptionController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.person,
                      size: 18,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    iconColor: Colors.teal,
                    hintText: 'Enter your Store Description',
                    labelText: 'Description',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    labelStyle: const TextStyle(
                      color: Color.fromARGB(255, 102, 102, 102),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: createPage,
                    child: const Text(
                      "Create Profile",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        fixedSize: const Size(350, 45),
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                        primary: const Color.fromARGB(255, 255, 255, 255),
                        onPrimary: Colors.black),
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("By creating a business profile you accept our"),
                      Text(
                        "Terms of Services and Privacy Policy",
                        style: TextStyle(fontWeight: FontWeight.w500),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future createPage() async {
    var user = FirebaseAuth.instance.currentUser;
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      //sends page info to firebase
      var docId =
                FirebaseFirestore.instance.collection("products").doc().id;
      await FirebaseFirestore.instance
          .collection("brand")
          .doc(emailController.text.trim())
          .set(
        {
          'email': emailController.text.trim().toLowerCase(),
          'name': nameController.text.trim(),
          'contact': contactController.text.trim(),
          'location': locationController.text.trim(),
          'website': websiteController.text.trim(),
          'description': descriptionController.text.trim(),
          'created_time': date.toLocal().toString(),
          'logo': '',
          'image': '',
          'id': docId.trim(),
        },
      );

      Map<String, dynamic> data = {
        'role': 'vendor',
        'admin_role': nameController.text.trim(),
      };
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.email)
          .update(data)
          .then((value) => Get.snackbar("Business page created Sucessfully",
              "Business Profile created Sucessfully",
              backgroundColor: const Color.fromARGB(115, 105, 240, 175)))
          .then((value) => Navigator.push(context,
              MaterialPageRoute(builder: ((context) => const BusinessPage()))));
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message.toString(), false);
      Navigator.pop(context);
    }
  }
}

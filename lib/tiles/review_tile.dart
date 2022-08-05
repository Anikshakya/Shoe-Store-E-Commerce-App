import 'package:flutter/material.dart';

class ReviewTile extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final userName, reviewText, timeStamp;
  const ReviewTile({Key? key, this.userName, this.reviewText, this.timeStamp})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding:
              const EdgeInsets.only(top: 16, bottom: 16, left: 20, right: 20),
          decoration: const BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                color: Color.fromARGB(255, 235, 233, 233),
                offset: Offset(2, 2),
                blurRadius: 10)
          ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(userName,
                      style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  const Spacer(),
                  Text(timeStamp,
                      style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                reviewText,
                style: const TextStyle(
                    fontWeight: FontWeight.w400, fontSize: 13.5),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        )
      ],
    );
  }
}

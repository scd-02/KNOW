import 'package:flutter/material.dart';

class ShowPopup extends StatelessWidget {
  final String btn1;
  final String btn2;
  const ShowPopup({
    Key? key,
    required this.btn1,
    required this.btn2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 50),
        child: AlertDialog(
          //elevation: 0,
          alignment: Alignment.bottomLeft,
          shadowColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                30.0), // Adjust the border radius as needed
            // side: const BorderSide(
            //     color: Colors.black, width: 0.5), // Border color and width
          ),
          content: SizedBox(
            height: 150,
            width: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 25),
                    //side: const BorderSide(color: Colors.black, width: 0.8),
                  ),
                  child: Text(
                    btn1,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 25),
                  ),
                  child: Text(
                    btn2,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

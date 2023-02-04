// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Image logoWidget(String imageName) {
  return Image.asset(
    imageName,
    fit: BoxFit.fitWidth,
    width: 240,
    height: 240,
    color: null,
  );
}

Future reusableDialogOK(String title, String content, BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            backgroundColor: Colors.pink[100],
            title: Text(title),
            content: Text(content),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Ok'),
              )
            ] // MaterialButton
            );
      });
}

TextField reusableTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.white,
    style: TextStyle(color: Colors.white.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.white70,
      ),
      labelText: text,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white.withOpacity(0.3),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}

Container firebaseUIButton(BuildContext context, String title, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      child: Text(
        title,
        style: const TextStyle(
            color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black26;
            }
            return Colors.white;
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
    ),
  );
}

Shimmer shimmerLoading(BuildContext context) {
  var size = MediaQuery.of(context).size;
  return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: EdgeInsets.only(top: 20, right: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: (size.width - 40) * 0.7,
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.withOpacity(0.1),
                        ),
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              color: Colors.white,
                            ),
                            width: 60,
                            height: 60,
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      SizedBox(
                        width: (size.width - 90) * 0.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 15,
                              color: Colors.white,
                            ),
                            SizedBox(height: 5),
                            Container(height: 18, color: Colors.white),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: (size.width - 100) * 0.3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 80,
                        height: 15,
                        color: Colors.white,
                      ),
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 0, top: 8),
              child: Divider(
                thickness: 0.8,
              ),
            )
          ],
        ),
      ));
}

ListView teste(BuildContext context) {
  var size = MediaQuery.of(context).size;
  return ListView.builder(
      shrinkWrap: true,
      itemCount: 8,
      itemBuilder: (_, __) => Padding(
            padding: EdgeInsets.only(top: 20, right: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: (size.width - 40) * 0.7,
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.withOpacity(0.1),
                            ),
                            child: Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                  color: Colors.white,
                                ),
                                width: 60,
                                height: 60,
                              ),
                            ),
                          ),
                          SizedBox(width: 15),
                          SizedBox(
                            width: (size.width - 90) * 0.5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 15,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 5),
                                Container(height: 18, color: Colors.white),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: (size.width - 100) * 0.3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 80,
                            height: 15,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 0, top: 8),
                  child: Divider(
                    thickness: 0.8,
                  ),
                )
              ],
            ),
          ));
}

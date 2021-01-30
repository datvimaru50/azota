import 'package:flutter/material.dart';

class Codetest1 extends StatefulWidget {
  @override
  _CodeFormState createState() => _CodeFormState();
}

class _CodeFormState extends State<Codetest1> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio:
                4, // Tỉ lệ chiều-ngang/chiều-rộng của một item trong grid, ở đây width = 1.6 * height
            crossAxisCount: 2, // Số item trên một hàng ngang
            crossAxisSpacing: 16, // Khoảng cách giữa các item trong hàng ngang
            mainAxisSpacing: 16,
          ),
        )
      ],
    );
  }
}

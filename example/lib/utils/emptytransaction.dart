import 'package:flutter/material.dart';

class Emptytransaction extends StatefulWidget {
  final String desc;
  const Emptytransaction({Key? key, this.desc = "No recent transaction"})
      : super(key: key);

  @override
  _EmptytransactionState createState() => _EmptytransactionState();
}

class _EmptytransactionState extends State<Emptytransaction> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "asset/image/emptytransaction.png",
            height: 150,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            widget.desc,
            style: TextStyle(color: Theme.of(context).primaryColor),
          )
        ],
      ),
    );
  }
}

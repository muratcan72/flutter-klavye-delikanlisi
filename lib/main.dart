import 'dart:async';

import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyAppHome(),
    );
  }
}

class MyAppHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppHomeState();
  }
}

class _MyAppHomeState extends State<MyAppHome> {
  String userName = "";
  int typedCharLength = 0;
  String lorem =
      '                       Nunc mi ipsum faucibus vitae aliquet nec ullamcorper sit amet. Lectus quam id leo in. Sed nisi lacus sed viverra tellus in hac habitasse. Molestie nunc non blandit massa enim. Urna molestie at elementum eu. Nunc vel risus commodo viverra maecenas accumsan lacus. Accumsan tortor posuere ac ut. Nulla aliquet porttitor lacus luctus accumsan tortor posuere ac. Porttitor eget dolor morbi non arcu risus quis varius. Lectus nulla at volutpat diam ut venenatis tellus in metus. Integer vitae justo eget magna. Et sollicitudin ac orci phasellus egestas tellus rutrum tellus pellentesque. In iaculis nunc sed augue lacus viverra. Tellus molestie nunc non blandit massa enim nec. Arcu cursus euismod quis viverra nibh cras pulvinar mattis nunc. Faucibus in ornare quam viverra.'
          .toLowerCase()
          .replaceAll(',', '')
          .replaceAll('.', '');

  int step = 0;
  int lastTypedAt;

  void updateLastTypedAt() {
    this.lastTypedAt = DateTime.now().millisecondsSinceEpoch;
  }

  void onType(String value) {
    updateLastTypedAt();
    String trimmedValue = lorem.trimLeft();
    setState(() {
      if (trimmedValue.indexOf(value) != 0) {
        step = 2;
      } else {
        typedCharLength = value.length;
      }
    });
  }

  void onuserNameType(String value) {
    setState(() {
      this.userName = value.substring(0, 3);
    });
  }

  void resetgame() {
    setState(() {
      typedCharLength = 0;
      step = 0;
    });
  }

  void onStartClick() {
    setState(() {
      updateLastTypedAt();
      step++;
    });
    var timer = Timer.periodic(new Duration(seconds: 1), (timer) {
      int now = DateTime.now().millisecondsSinceEpoch;

      // Game Over
      setState(() {
        if (step == 1 && now - lastTypedAt > 4000) {
          step++;
        }
        if (step != 1) {
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var shownWidget;

    if (step == 0)
      shownWidget = <Widget>[
        Text('merhaba, ne kadar klavye delikanlısısın?'),
        Container(
          padding: EdgeInsets.only(left: 15, right: 15, top: 30),
          child: TextField(
            onChanged: onuserNameType,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'klavye delikanlısı adınızı yazınız ?',
            ),
          ),
        ),
        Padding(
            padding: EdgeInsets.only(top: 30),
            child: RaisedButton(
              child: Text('Basla!'),
              onPressed: userName.length == 0 ? null : onStartClick,
            ))
      ];
    else if (step == 1)
      shownWidget = <Widget>[
        Container(
          height: 40,
          child: Marquee(
            text: lorem,
            style: TextStyle(fontSize: 24, letterSpacing: 1.5),
            scrollAxis: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            blankSpace: 20.0,
            velocity: 75,
            startPadding: 0,
            accelerationDuration: Duration(seconds: 20),
            accelerationCurve: Curves.ease,
            decelerationDuration: Duration(milliseconds: 500),
            decelerationCurve: Curves.easeOut,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 30),
          child: TextField(
            autofocus: true,
            onChanged: onType,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Lütfen Yazınız',
            ),
          ),
        ),
        Text('Skorunuz : $typedCharLength'),
      ];
    else
      shownWidget = <Widget>[
        Text('senden klavye delikanlısı olmazzzz skorun : $typedCharLength'),
        RaisedButton(
          child: Text('Yeniden dene!'),
          onPressed: resetgame,
        ),
      ];
    return Scaffold(
      appBar: AppBar(
        title: Text('klavye delikanlısı'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: shownWidget,
        ),
      ),
    );
  }
}

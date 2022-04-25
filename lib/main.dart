import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin{

  bool isValid = true;
  bool showError = false;

  late final TextEditingController _textEditingController;
  late final FocusNode _focusNode;

  late double kDeviceLogicalHeight;
  late double kDeviceLogicalWidth;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final BorderRadius _borderRadius = BorderRadius.circular(10.0);

  late AnimationController animationController;
  late Animation<double> animation;


  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this);
    animation = Tween<double>(begin: 0.0, end: 120.0,).animate(animationController);
    _textEditingController = TextEditingController();
    _focusNode = FocusNode();
    super.initState();
  }

  String validateUsername(String value) {
    if (value.isEmpty) {
      return 'Username cannot be empty';
    } else {
      if (RegExp(r'^[\_a-zA-Z0-9\.]+$').hasMatch(value)) {
        if (value.length > 30) {
          return 'Username should be no longer than 30 characters';
        }
        return '';
      } else {
        return 'Username cannot contain special characters';
      }
    }
  }

  math.Vector3 calc(){
    double progress = animationController.value;
    double offset = sin(progress * pi * 3.0);
    return math.Vector3(offset * 10, 0.0,0.0);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    kDeviceLogicalHeight = MediaQuery.of(context).size.height;
    kDeviceLogicalWidth = MediaQuery.of(context).size.width;
    if(validateUsername(_textEditingController.text) == ''){
      showError = false;
    }
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => _focusNode.unfocus(),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //Spacing to top
                  SizedBox(height: kDeviceLogicalHeight * 0.3,),
                  Stack(
                    children: [
                      // TextFormField
                      Column(
                        children: [
                          // This sized box will dictate the distance between the
                          // icon and the error message placement
                          const SizedBox(height: 23,),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: _borderRadius,
                            ),
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              focusNode: _focusNode,
                              controller: _textEditingController,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                focusedBorder: !isValid ? const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red, width: 1),
                                ) : const OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
                                // border: InputBorder.none,
                                labelText: 'Username',
                                prefixIcon: const Icon(Icons.person),
                                suffixIcon: !isValid
                                    ? GestureDetector(
                                      child: const Icon(Icons.info, color: Colors.red,),
                                      onTap: (){
                                        setState(() {
                                          showError = !showError;
                                        });
                                      },
                                    )
                                    : const Icon(Icons.check, color: Colors.green,)
                              ),
                              onChanged: (String value){
                                setState(() {
                                  isValid = validateUsername(value).isEmpty;
                                });
                              },
                              inputFormatters: <TextInputFormatter>[LengthLimitingTextInputFormatter(30)],
                            ),
                          ),
                        ],
                      ),

                      // Error text
                      Positioned(
                        top: 0,
                        right: 8,
                        child: AnimatedBuilder(
                          animation: animationController,
                          builder: (BuildContext context, Widget? child) {
                            return Transform(
                              transform: Matrix4.translation(calc()),
                              child: AnimatedOpacity(
                                opacity: showError ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: _borderRadius,
                                      ),
                                      child: Text(validateUsername(_textEditingController.text), style: const TextStyle(color: Colors.white),),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(right: 15),
                                      child: CustomPaint(
                                        painter: Triangle(Colors.red),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20,),

                  // Submit Button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: _borderRadius,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: TextButton(
                      onPressed: () {
                        if(showError == true){
                          animationController.forward(from: 0.0);
                        }
                        _focusNode.unfocus();
                        setState(() {
                          isValid = validateUsername(_textEditingController.text).isEmpty;
                          showError = true;
                        });
                      },
                      child: const FractionallySizedBox(
                        widthFactor: 1.0,
                        child: Center(child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Submit'),
                        )),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Triangle extends CustomPainter {
  final Color backgroundColor;
  Triangle(this.backgroundColor);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = backgroundColor;

    var path = Path();
    path.lineTo(-4, 0);
    path.lineTo(0, 7);
    path.lineTo(4, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

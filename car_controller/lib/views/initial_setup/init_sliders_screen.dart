import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:camera/camera.dart';
import 'package:car_controller/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:native_opencv/native_opencv.dart';

class InitSliderScreen extends StatefulWidget {
  const InitSliderScreen({super.key});

  @override
  State<InitSliderScreen> createState() => _InitSliderScreenState();
}

class _InitSliderScreenState extends State<InitSliderScreen> {
  int _threshold = 180;
  bool initial = false;
  int _filterLargeContours_threshold = 10000;
  int _RefixThreholds_binary_threshold = 180;
  int _RefixThreholds_size_theshold = 10000;
  int _detectStraightLines_dilation_iterations = 5;
  int _detectStraightLines_horizontal_iterations = 17;
  int _detectStraightLines_diagonal1_iterations = 17;
  int _detectStraightLines_diagonal2_iterations = 17;
  int _detectStraightLines_area_threshold = 1000;
  int _detectStraightLines_width_threshold = 100;
  int _detectStraightLines_line_width = 25;
  late Uint8List image;
  late Uint8List processedImage;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    image = ModalRoute.of(context)!.settings.arguments as Uint8List;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: const Text(
          'Sliders',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 22.0,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.question,
                  animType: AnimType.leftSlide,
                  title:
                      'Are you sure you want to proceed with these settings?',
                  desc:
                      '\nThreshold = $_threshold\n\nFilter Large Contours Threshold = $_filterLargeContours_threshold\n\nRefixThreholds Binary Threshold = $_RefixThreholds_binary_threshold\n\nRefixThreholds Size Theshold = $_RefixThreholds_size_theshold\n\nDetectStraightLines Dilation Iterations = $_detectStraightLines_dilation_iterations\n\nDetectStraightLines Horizontal Iterations = $_detectStraightLines_horizontal_iterations\n\nDetectStraightLines Diagonal1 Iterations = $_detectStraightLines_diagonal1_iterations\n\nDetectStraightLines Diagonal2 Iterations = $_detectStraightLines_diagonal2_iterations\n\nDetectStraightLines Area Threshold = $_detectStraightLines_area_threshold\n\nDetectStraightLines Width Threshold = $_detectStraightLines_width_threshold\n\nDetectStraightLines Line Width = $_detectStraightLines_line_width',
                  descTextStyle: const TextStyle(
                      fontWeight: FontWeight.normal, fontSize: 15),
                  btnOkOnPress: () async {
                    var openCv = getIt.get<NativeOpencv>();
                    if (!initial) {
                      var b = openCv.initImage(image, threshold: _threshold);
                      print(b);
                      initial = true;
                    }

                    // print('Image = $image');
                    // if (initialization) {
                    //   print('Initialized Successfully..');
                    // }

                    var processedImage = openCv.preprocessImage(
                        _filterLargeContours_threshold,
                        _RefixThreholds_binary_threshold,
                        _RefixThreholds_size_theshold,
                        _detectStraightLines_dilation_iterations,
                        _detectStraightLines_horizontal_iterations,
                        _detectStraightLines_diagonal1_iterations,
                        _detectStraightLines_diagonal2_iterations,
                        _detectStraightLines_area_threshold,
                        _detectStraightLines_width_threshold,
                        _detectStraightLines_line_width);
                    // if (processedImage.length != image.length) {
                    //   print('Not Equal');
                    // } else {
                    //   print('Equal');
                    // }
                    // int count = 0;
                    // for (var i = 0; i < processedImage.length; i++) {
                    //   if (processedImage.elementAt(i) != image.elementAt(i)) {
                    //     count++;
                    //   }
                    // }
                    print(processedImage);
                    // var x = await p.readAsBytes();
                    Navigator.pushReplacementNamed(context, kInitImagePreviewScreen,
                        arguments: processedImage);
                  },
                  btnCancelOnPress: () {},
                ).show();
              },
              icon: const Icon(Icons.check))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: Text(
                  'Sliders',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.blueGrey[800],
                    fontWeight: FontWeight.w600,
                    fontSize: 28.0,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              FlutterSlider(
                  values: [_threshold.toDouble()],
                  min: 0,
                  tooltip: FlutterSliderTooltip(
                      textStyle: const TextStyle(fontSize: 14)),
                  max: 255,
                  onDragging: (handlerIndex, lowerValue, upperValue) {
                    _threshold = lowerValue.toInt();
                    setState(() {});
                  }),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text(
                  "Threshold = $_threshold",
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              const Divider(
                height: 20,
                thickness: 2,
                indent: 15,
                endIndent: 15,
              ),
              ////////////////////////////////////////////////////////////////
              ////////////////////////////////////////////////////////////////
              ////////////////////////////////////////////////////////////////
              FlutterSlider(
                  values: [_RefixThreholds_binary_threshold.toDouble()],
                  min: 0,
                  tooltip: FlutterSliderTooltip(
                      textStyle: const TextStyle(fontSize: 14)),
                  max: 255,
                  onDragging: (handlerIndex, lowerValue, upperValue) {
                    _RefixThreholds_binary_threshold = lowerValue.toInt();
                    setState(() {});
                  }),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text(
                  "RefixThreholds Binary Threshold = $_RefixThreholds_binary_threshold",
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              const Divider(
                height: 20,
                thickness: 2,
                indent: 15,
                endIndent: 15,
              ),
              ////////////////////////////////////////////////////////////////
              ////////////////////////////////////////////////////////////////
              ////////////////////////////////////////////////////////////////
              FlutterSlider(
                  values: [_detectStraightLines_dilation_iterations.toDouble()],
                  min: 0,
                  tooltip: FlutterSliderTooltip(
                      textStyle: const TextStyle(fontSize: 14)),
                  max: 25,
                  onDragging: (handlerIndex, lowerValue, upperValue) {
                    _detectStraightLines_dilation_iterations =
                        lowerValue.toInt();
                    setState(() {});
                  }),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text(
                  "DetectStraightLines Dilation Iterations = $_detectStraightLines_dilation_iterations",
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              const Divider(
                height: 20,
                thickness: 2,
                indent: 15,
                endIndent: 15,
              ),
              ////////////////////////////////////////////////////////////////
              ////////////////////////////////////////////////////////////////
              ////////////////////////////////////////////////////////////////
              FlutterSlider(
                  values: [
                    _detectStraightLines_horizontal_iterations.toDouble()
                  ],
                  min: 0,
                  tooltip: FlutterSliderTooltip(
                      textStyle: const TextStyle(fontSize: 14)),
                  max: 25,
                  onDragging: (handlerIndex, lowerValue, upperValue) {
                    _detectStraightLines_horizontal_iterations =
                        lowerValue.toInt();
                    setState(() {});
                  }),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text(
                  "DetectStraightLines Horizontal Iterations = $_detectStraightLines_horizontal_iterations",
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              const Divider(
                height: 20,
                thickness: 2,
                indent: 15,
                endIndent: 15,
              ),
              ////////////////////////////////////////////////////////////////
              ////////////////////////////////////////////////////////////////
              ////////////////////////////////////////////////////////////////
              FlutterSlider(
                  values: [
                    _detectStraightLines_diagonal1_iterations.toDouble()
                  ],
                  min: 0,
                  tooltip: FlutterSliderTooltip(
                      textStyle: const TextStyle(fontSize: 14)),
                  max: 25,
                  onDragging: (handlerIndex, lowerValue, upperValue) {
                    _detectStraightLines_diagonal1_iterations =
                        lowerValue.toInt();
                    setState(() {});
                  }),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text(
                  "DetectStraightLines Diagonal1 Iterations = $_detectStraightLines_diagonal1_iterations",
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              const Divider(
                height: 20,
                thickness: 2,
                indent: 15,
                endIndent: 15,
              ),
              ////////////////////////////////////////////////////////////////
              ////////////////////////////////////////////////////////////////
              ////////////////////////////////////////////////////////////////
              FlutterSlider(
                  values: [
                    _detectStraightLines_diagonal2_iterations.toDouble()
                  ],
                  min: 0,
                  tooltip: FlutterSliderTooltip(
                      textStyle: const TextStyle(fontSize: 14)),
                  max: 25,
                  onDragging: (handlerIndex, lowerValue, upperValue) {
                    _detectStraightLines_diagonal2_iterations =
                        lowerValue.toInt();
                    setState(() {});
                  }),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text(
                  "DetectStraightLines Diagonal2 Iterations = $_detectStraightLines_diagonal2_iterations",
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              const Divider(
                height: 20,
                thickness: 2,
                indent: 15,
                endIndent: 15,
              ),
              ////////////////////////////////////////////////////////////////
              ////////////////////////////////////////////////////////////////
              ////////////////////////////////////////////////////////////////
              FlutterSlider(
                  values: [_detectStraightLines_line_width.toDouble()],
                  min: 0,
                  tooltip: FlutterSliderTooltip(
                      textStyle: const TextStyle(fontSize: 14)),
                  max: 35,
                  onDragging: (handlerIndex, lowerValue, upperValue) {
                    _detectStraightLines_line_width = lowerValue.toInt();
                    setState(() {});
                  }),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text(
                  "DetectStraightLines Line Width = $_detectStraightLines_line_width",
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              const Divider(
                height: 20,
                thickness: 2,
                indent: 15,
                endIndent: 15,
              ),
              ////////////////////////////////////////////////////////////////
              ////////////////////////////////////////////////////////////////
              ////////////////////////////////////////////////////////////////
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: Text(
                  'TextBoxes',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.blueGrey[800],
                    fontWeight: FontWeight.w600,
                    fontSize: 28.0,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ////////////////////////////////////////////////////////////////
              ////////////////////////////////////////////////////////////////
              ////////////////////////////////////////////////////////////////
              Form(
                child: Column(
                  children: [
                    const SizedBox(
                      width: double.infinity,
                      height: 30,
                      child: Text(
                        'Filter Large Contours Threshold',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 17.0,
                        ),
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      onFieldSubmitted: (value) {
                        _filterLargeContours_threshold = int.parse(value);
                        setState(() {});
                      },
                      initialValue: '$_filterLargeContours_threshold',
                      maxLines: 1,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '',
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    ////////////////////////////////////////////////////////////////
                    ////////////////////////////////////////////////////////////////
                    ////////////////////////////////////////////////////////////////
                    const SizedBox(
                      width: double.infinity,
                      height: 30,
                      child: Text(
                        'RefixThreholds Size Theshold ',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 17.0,
                        ),
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      onFieldSubmitted: (value) {
                        _RefixThreholds_size_theshold = int.parse(value);
                        setState(() {});
                      },
                      initialValue: '$_RefixThreholds_size_theshold ',
                      maxLines: 1,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '',
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    ////////////////////////////////////////////////////////////////
                    ////////////////////////////////////////////////////////////////
                    ////////////////////////////////////////////////////////////////
                    const SizedBox(
                      width: double.infinity,
                      height: 30,
                      child: Text(
                        'DetectStraightLines Area Threshold ',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 17.0,
                        ),
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      onFieldSubmitted: (value) {
                        _detectStraightLines_area_threshold = int.parse(value);
                        setState(() {});
                      },
                      initialValue: '$_detectStraightLines_area_threshold',
                      maxLines: 1,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '',
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    ////////////////////////////////////////////////////////////////
                    ////////////////////////////////////////////////////////////////
                    ////////////////////////////////////////////////////////////////
                    const SizedBox(
                      width: double.infinity,
                      height: 30,
                      child: Text(
                        'DetectStraightLines Width Threshold ',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 17.0,
                        ),
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      onFieldSubmitted: (value) {
                        _detectStraightLines_width_threshold = int.parse(value);
                        setState(() {});
                      },
                      initialValue: '$_detectStraightLines_width_threshold ',
                      maxLines: 1,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '',
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    ////////////////////////////////////////////////////////////////
                    ////////////////////////////////////////////////////////////////
                    ////////////////////////////////////////////////////////////////
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

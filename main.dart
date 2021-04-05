import 'package:flutter/material.dart';
import 'package:smart_bulb/flutter_circle_color_picker.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(MyApp());
}

class MyApp  extends StatelessWidget{
  @override
  // ignore: missing_return
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Light Bulb',
        theme: ThemeData(
        primarySwatch: Colors.blue,
    ),
    home: ColorPicker(),
    );
  }
}

class AppBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: _currentColor,
        title: const Text('Circle color picker sample'),
      ),
      body: Scrollable(

      ),
    );
  }
}


class ColorPicker extends StatefulWidget {
  final channel = IOWebSocketChannel.connect('wss://echo.websocket.org');
  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  Color _currentColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: _currentColor,
          title: const Text('Circle color picker sample'),
        ),
        body: Column(
            children: <Widget>[
              Center(
                child: Column(
                    children: [
                      CircleColorPicker(
                        initialColor: _currentColor,
                        strokeWidth: 8,
                        onChanged: _onColorChanged,
                        colorCodeBuilder: (context, color) {
                          return Text(
                            'rgb(${color.red}, ${color.green}, ${color.blue})',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                      );
                    },
                  ),
                      ElevatedButton(
                          //onPressed: _sendData,
                          child: Text("Set Colour")
                      ),
                      StreamBuilder(
                        stream: widget.channel.stream,
                        builder: (context, snapshot) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24.0),
                            child: Text(snapshot.hasData ? '${snapshot.data}' : ''),
                          );
                        },
                      )
                ],
                )
              ),

            ],
          ),
        ),

      );
  }

  void _sendData(Color color){
    widget.channel.sink.add("${color.red},${color.green},${color.blue}");
  }

  void _onColorChanged(Color color) {
    setState(() => _currentColor = color);
    _sendData(color);
  }

}

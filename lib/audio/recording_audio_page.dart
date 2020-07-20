import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:app_motor/audio/recording_audio_bloc.dart';
import 'package:app_motor/home/home_page.dart';
import 'package:app_motor/vehicle/search_vehicle_page.dart';
import 'package:app_motor/vehicle/vehicle_register_page.dart';
import 'package:app_motor/widgets/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'dart:async';
import 'dart:io' as io;
import 'package:audioplayers/audioplayers.dart';
import 'package:file/local.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../style.dart';

class RecordingAudioPage extends StatefulWidget {
  final LocalFileSystem localFileSystem;
  final String plate;

  RecordingAudioPage({localFileSystem, this.plate})
      : this.localFileSystem = localFileSystem ?? LocalFileSystem();

  @override
  _RecordingAudioPageState createState() => _RecordingAudioPageState();
}

class _RecordingAudioPageState extends State<RecordingAudioPage> {
  FlutterAudioRecorder _recorder;
  var bloc = new RecordingAudioBloc();
  //String fp = '';
  Recording _current;
  AudioPlayer _currentAudio = AudioPlayer();
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  Duration _position;
  Duration _duration;
  double _result;
  String encode;
  var encodeBinary;
  String encodeResult;
  var encodeBinaryResult;
  File file2;

  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Vistoria do véiculo " + widget.plate,
          style: AppBarStyle,
        ),
        backgroundColor: PrimaryBlue3,
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            child: Text(
              "Grave o áudio da sua vistoria:",
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Gray3,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: FontNameDefaultBody,
              ),
            ),
            padding: const EdgeInsets.only(top: 30, left: 25),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new Container(
                  child: Padding(
                    padding: const EdgeInsets.all(70.0),
                    child: FlatButton(
                      onPressed: () {
                        switch (_currentStatus) {
                          case RecordingStatus.Initialized:
                            {
                              _start();
                              break;
                            }
                          case RecordingStatus.Recording:
                            {
                              _stop();
                              break;
                            }
                          case RecordingStatus.Stopped:
                            {
                              _init();
                              break;
                            }
                          default:
                            break;
                        }
                      },
                      child: Column(
                        children: <Widget>[
                          _buildIcon(_currentStatus),
                          _buildTextRecord(_currentStatus),
                        ],
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: PrimaryBlue1,
                        width: 2.0,
                      )),
                ),
                SizedBox(
                  height: 70.0,
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new FlatButton(
                      onPressed: _currentAudio.state != AudioPlayerState.PLAYING
                          ? _onPlayAudio
                          : _pauseAudio,
                      child: new Row(children: <Widget>[_buildIconPlay()]),
                    )
                  ],
                ),
                new SizedBox(
                  height: 20.0,
                ),
                new ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    height: 10,
                    child: LinearProgressIndicator(
                      value:
                          _position != null ? _result : 0.0, // percent filled
                      valueColor: AlwaysStoppedAnimation<Color>(Gray4),
                      backgroundColor: Gray5,
                    ),
                  ),
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      _varPosition(),
                      style: TextStyle(
                          color: Gray3,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: FontNameDefaultBody),
                    ),
                    Text(
                      _varDuration(),
                      style: TextStyle(
                          color: Gray3,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: FontNameDefaultBody),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
            child: Builder(
              builder: (context) => FlatButton(
                color: PrimaryBlue3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Enviar ",
                          style: TextStyle(
                              color: Gray6,
                              fontWeight: FontWeight.w600,
                              fontFamily: FontNameDefaultBody,
                              fontSize: 18),
                        ),
                        WidgetSpan(
                          child: Icon(
                            Icons.check_circle_outline,
                            size: 18,
                            color: Gray6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                onPressed: () async {
                  var audio = {};
                  audio["audio"] = bloc.audioCtrl;
                  print("audio" + audio["audio"]);
                  var body = jsonEncode(audio);
                  print("body" + body.toString());
                  var result = await bloc.registerAudio("2", body);
                  print(result.body);
                  print(result.statusCode);
                  if (result.statusCode == 201) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  } else {
                    final message = SnackBar(content: Text("Tente novamente"));
                    Scaffold.of(context).showSnackBar(message);
                  }
                },
              ),
            ),
          ),
          ProgressBar(0.70),
        ],
      ),
    );
  }

  _init() async {
    try {
      if (await FlutterAudioRecorder.hasPermissions) {
        String customPath = '/flutter_audio_recorder_';
        io.Directory appDocDirectory;
//        io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
        if (io.Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = await getExternalStorageDirectory();
        }

        // can add extension like ".mp4" ".wav" ".m4a" ".aac"
        customPath = appDocDirectory.path +
            customPath +
            DateTime.now().millisecondsSinceEpoch.toString();

        // .wav <---> AudioFormat.WAV
        // .mp4 .m4a .aac <---> AudioFormat.AAC
        // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
        _recorder =
            FlutterAudioRecorder(customPath, audioFormat: AudioFormat.WAV);

        await _recorder.initialized;
        // after initialization
        var current = await _recorder.current(channel: 0);
        print(current);

        // should be "Initialized", if all working fine
        setState(() {
          _current = current;
          _currentStatus = current.status;
          print(_currentStatus);
        });
      } else {
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text("You must accept permissions")));
      }
    } catch (e) {
      print(e);
    }
  }

  _start() async {
    try {
      await _recorder.start();
      var recording = await _recorder.current(channel: 0);
      setState(() {
        _current = recording;
      });

      const tick = const Duration(milliseconds: 50);
      new Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder.current(channel: 0);
        print("start: ${current.status}");
        setState(() {
          _current = current;
          _currentStatus = _current.status;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  _startRecord() async {
    try {
      await _recorder.start();
      var recording = await _recorder.current(channel: 0);
      setState(() {
        _current = recording;
      });

      const tick = const Duration(milliseconds: 50);
      new Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder.current(channel: 0);
        print("start: ${current.status}");
        setState(() {
          _current = current;
          _currentStatus = _current.status;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  _stopRecord() async {
    var result = await _recorder.stop();
    print(result.runtimeType);
    print("Stop recording: ${result.path}");
    print("Stop recording: ${result.duration}");
    File file = widget.localFileSystem.file(result.path);
    //File file = File("/storage/emulated/0/Android/data/com.example.imc/files/file123423.wav");
    print("File length: ${await file.length()}");
    await _encode(result.path);
    var fileBytes = await file.readAsBytesSync();
    print('$fileBytes');
    //var fileBytes = _filebyte(file);
    String encodedFile = base64Encode(fileBytes);
    print('$encodedFile');
    await _write(encodedFile);

    //await _encodeBytes(result.path);
    /*file2.openRead();
    var contents = await file2.readAsBytes();
    var base64File = base64.encode(contents);*/
    //print("File length: ${await file.length()}");
    //File file = File("${result.path}");
    //file.openRead();
    //List<int> fileBytes = await file.readAsBytes();
    //print('$fileBytes');
    //String base64String = base64Encode(fileBytes);
    //print('$base64String');
    //List fileBytes = new File("${result.path}").readAsBytesSync();
    //print('$fileBytes');
    //String fileBytes2 = new File("${result.path}").readAsString();
    //print('$fileBytes2');

    /*List fileBytesResult = await new File(result.path).readAsBytesSync();
    String encodedFileResult = base64Encode(fileBytesResult);*/

    setState(() {
      _current = result;
      _currentStatus = _current.status;
      //encode = encodedFile;
      //encodeBinary = fileBytes;
    });
  }

  _resume() async {
    await _recorder.resume();
    setState(() {});
  }

  _pause() async {
    await _recorder.pause();
    setState(() {});
  }

  _stop() async {
    var result = await _recorder.stop();
    print(result.runtimeType);
    print("Stop recording: ${result.path}");
    print("Stop recording: ${result.duration}");
    File file = widget.localFileSystem.file(result.path);
    //File file = File("/storage/emulated/0/Android/data/com.example.imc/files/file123423.wav");
    print("File length: ${await file.length()}");
    //await _encode(result.path);
    var fileBytes = await file.readAsBytesSync();
    print('$fileBytes');
    //var fileBytes = _filebyte(file);
    String encodedFile = base64Encode(fileBytes);
    print('$encodedFile');
    bloc.audioCtrl = encodedFile;
    //await _write(encodedFile);

    //await _encodeBytes(result.path);
    /*file2.openRead();
    var contents = await file2.readAsBytes();
    var base64File = base64.encode(contents);*/
    //print("File length: ${await file.length()}");
    //File file = File("${result.path}");
    //file.openRead();
    //List<int> fileBytes = await file.readAsBytes();
    //print('$fileBytes');
    //String base64String = base64Encode(fileBytes);
    //print('$base64String');
    //List fileBytes = new File("${result.path}").readAsBytesSync();
    //print('$fileBytes');
    //String fileBytes2 = new File("${result.path}").readAsString();
    //print('$fileBytes2');

    /*List fileBytesResult = await new File(result.path).readAsBytesSync();
    String encodedFileResult = base64Encode(fileBytesResult);*/

    setState(() {
      _current = result;
      _currentStatus = _current.status;
      //encode = encodedFile;
      //encodeBinary = fileBytes;
    });
  }

  _write(String text) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File(
        '/storage/emulated/0/Android/data/com.example.imc/files/my_file.txt');
    print('${directory.path}');
    print('$text');
    await file.writeAsString(text);
  }

  /*_encodeBytes(String s) async {
      /*File file = File("${s}");
      file.openRead();
      String fileBytes = await file.readAsString();
      print('fileBytes');
      print('$fileBytes');*/
      var encodedString = utf8.encode(s);
      print('encodedString');
      print('$encodedString');
      var encodedLength = encodedString.length;
      print('encodedLength');
      print('$encodedLength');
      var data = ByteData(encodedLength + 4);
      print('data');
      print('$data');
      data.setUint32(0, encodedLength, Endian.big);
      var bytes = data.buffer.asUint8List();
      print('bytes8list');
      print('$bytes');
      bytes.setRange(4, encodedLength + 4, encodedString);
      print('bytes');
      print('$bytes');
      String encodedFile = base64Encode(bytes);
      print('encodedFile');
      print('$encodedFile');
  */
  _encode(path) async {
    //File file = widget.localFileSystem.file(path);
    /*ByteData audioByteData = await rootBundle.load(path);
    print('$audioByteData');
    Uint8List audioUint8List = audioByteData.buffer.asUint8List(audioByteData.offsetInBytes, audioByteData.lengthInBytes);
    print('$audioUint8List');
    List<int> audioListInt = audioUint8List.cast<int>();
    print('$audioListInt');*/
    File file = File("${path}");
    file.openRead(0, 200);
    /*String fileBytesStringSync = await file.readAsStringSync();
    print('Sycn');
    print('$fileBytesStringSync');
    String fileBytesString = await file.readAsString();
    print('String');
    print('$fileBytesString');*/
    file.copy(
        "/storage/emulated/0/Android/data/com.example.imc/flutter_audio_recorder_1593093606318.wav");
    print('${file.length()}');
    var fileBytes;
    fileBytes = await file.readAsBytes();
    print('$fileBytes');
    //var fileBytes = _filebyte(file);
    String encodedFile = base64Encode(fileBytes);
    print('$encodedFile');
    setState(() {
      //encodeBinary = fileBytes;
    });
  }

  Future<List<int>> _filebyte(file) async {
    Uint8List fileBytes;
    fileBytes = await file.readAsBytes();
    print('$fileBytes');
    return fileBytes;
  }

  Widget _buildIconPlay() {
    Icon icon;
    _currentAudio.state == AudioPlayerState.PLAYING
        ? icon = new Icon(Icons.pause, color: Gray4, size: 50.0)
        : icon = new Icon(Icons.play_arrow, color: Gray4, size: 50.0);
    return icon;
  }

  Widget _buildTextRecord(RecordingStatus status) {
    var text = "";
    switch (_currentStatus) {
      case RecordingStatus.Initialized:
        {
          text = 'Gravar';
          break;
        }
      case RecordingStatus.Recording:
        {
          text = 'Parar';
          break;
        }
      case RecordingStatus.Paused:
        {
          text = 'Resume';
          break;
        }
      case RecordingStatus.Stopped:
        {
          text = 'Regravar';
          break;
        }
      case RecordingStatus.Unset:
        {
          text = 'Parar';
          break;
        }
      default:
        break;
    }
    return Text(
      text,
      style: TextStyle(
          color: PrimaryBlue1,
          fontSize: 24,
          fontWeight: FontWeight.w400,
          fontFamily: FontNameDefaultBody),
    );
  }

  Widget _buildIcon(RecordingStatus status) {
    Icon icon;
    switch (_currentStatus) {
      case RecordingStatus.Initialized:
        {
          icon = new Icon(
            Icons.mic,
            color: PrimaryRed3,
            size: 150,
          );
          break;
        }
      case RecordingStatus.Recording:
        {
          icon = new Icon(
            Icons.mic_none,
            color: PrimaryRed3,
            size: 150,
          );
          break;
        }
      case RecordingStatus.Paused:
        {
          icon = new Icon(
            Icons.pause,
            color: PrimaryRed3,
            size: 150,
          );
          break;
        }
      case RecordingStatus.Stopped:
        {
          icon = new Icon(
            Icons.refresh,
            color: PrimaryRed3,
            size: 150,
          );
          break;
        }
      default:
        break;
    }
    return icon;
  }

  _onPlayAudio() async {
    print("CAMINHO"+_current.path);
    print("STATUS"+_currentStatus.toString());
    if (_currentStatus != RecordingStatus.Initialized) {
      File file = File(
        "${_current.path}",
      );
      file.openRead();
      await _currentAudio.play(file.path, isLocal: true);
    } else {
      debugPrint("File is null");
    }

    setState(() {
      (_currentStatus != RecordingStatus.Initialized)
          ? _currentAudio.state = AudioPlayerState.PLAYING
          : AudioPlayerState.PAUSED;
      //encode = encodedFile;
      //encodeBinary = fileBytes;
    });

    _currentAudio.onPlayerCompletion.listen((event) {
      setState(() {
        _currentAudio.state = AudioPlayerState.COMPLETED;
        _result = 1.0;
      });
    });

    _currentAudio.onDurationChanged.listen((Duration d) {
      print('Max duration: $d');
      setState(() => _duration = d);
    });

    _currentAudio.onAudioPositionChanged.listen((Duration p) {
      print('Current position: $p');
      setState(() {
        _position = p;
        double d = _duration.inMilliseconds.toDouble();
        double x = _position.inMilliseconds.toDouble() * 100;
        _result = (x / d) / 100;
      });
    });
  }

  _pauseAudio() async {
    // int result = await _currentAudio.pause();
    // var resultAudio = await _currentAudio.state;
    // print("PAUSE: ${_currentAudio.state}");
    await _currentAudio.pause();
    setState(() {
      _currentAudio.state = AudioPlayerState.PAUSED;
      //encode = encodedFile;
      //encodeBinary = fileBytes;
    });
  }

  _stopPlayAudio() async {
    await _currentAudio.stop();
    setState(() {
      _currentAudio.state = AudioPlayerState.STOPPED;
      //encode = encodedFile;
      //encodeBinary = fileBytes;
    });
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  String _varPosition() {
    String result = '';
    (_position != null)
        ? result = "${_printDuration(_position)}"
        : result = "00:00";
    return result;
  }

  String _varDuration() {
    String result = '';
    (_duration != null)
        ? result = "${_printDuration(_duration)}"
        : (_current?.duration == 0)
            ? result = "00:00"
            : result = "${_printDuration(_current?.duration)}";
    return result;
  }
}

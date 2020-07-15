import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:app_motor/audio/recording_audio_bloc.dart';
import 'package:app_motor/home/home_page.dart';
import 'package:app_motor/vehicle/search_vehicle_page.dart';
import 'package:app_motor/vehicle/vehicle_register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'dart:async';
import 'dart:io' as io;
import 'package:audioplayers/audioplayers.dart';
import 'package:file/local.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class RecordingAudioPage extends StatefulWidget {
  final LocalFileSystem localFileSystem;

  RecordingAudioPage({localFileSystem})
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
        title: Text("Gravação de Áudio"),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: new EdgeInsets.all(8.0),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new FlatButton(
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
                                //_pause();
                                break;
                              }
                            /*case RecordingStatus.Paused:
                              {
                                _resume();
                                break;
                              }*/
                            case RecordingStatus.Stopped:
                              {
                                _init();
                                break;
                              }
                            default:
                              break;
                          }
                        },
                        child: new Row(
                          children: <Widget>[
                            _buildIcon(_currentStatus),
                            _buildTextRecord(_currentStatus),
                          ],
                        ),
                        color: Colors.lightBlue,
                      ),
                    ),
                    new FlatButton(
                      onPressed: _currentStatus != RecordingStatus.Recording
                          ? _stopPlayAudio
                          : _stop,
                      color: Colors.blueAccent.withOpacity(0.5),
                      child: new Row(
                        children: <Widget>[
                          new Icon(Icons.stop),
                          new Text("Stop",
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    new FlatButton(
                      onPressed: _currentAudio.state != AudioPlayerState.PLAYING
                          ? _onPlayAudio
                          : _pauseAudio,
                      // onPressed: _onPlayAudio,
                      color: Colors.blueAccent.withOpacity(0.5),
                      child: new Row(children: <Widget>[
                        _buildIconPlay(),
                        _buildTextRecordPlays(),
                      ]),
                    )
                  ],
                ),
                //new Text("Status : $_currentStatus"),
                //new Text("AudioStatus : ${_currentAudio.state}"),
                new Text(
                    "Duração da gravação : ${_current?.duration.toString()}"),
                new Text(" "),
                LinearProgressIndicator(value: _position != null ? _result : 0.0),
                new Text(" "),
                new Text("Reproduzindo : $_position/$_duration"),

                //new Text('Avg Power: ${_current?.metering?.averagePower}'),
                //new Text('Peak Power: ${_current?.metering?.peakPower}'),
                //new Text("File path of the record: ${_current?.path}"),
                //new Text("Format: ${_current?.audioFormat}"),
                //new Text(
                //    "isMeteringEnabled: ${_current?.metering?.isMeteringEnabled}"),
                //new Text("Extension : ${_current?.extension}"),

                //new Text("Encode Stop : $encode"),
                //new Text("EncodeBinary Stop : $encodeBinary"),
              ],
            ),
          ),



          Padding(
            padding: EdgeInsets.all(20),
            child: Builder(
              builder: (context) => FlatButton(
                color: Theme.of(context).primaryColor,
                child: Text("Enviar",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
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
                       MaterialPageRoute(
                           builder: (context) => HomePage()),
                     );
                   } else {
                     final message =
                         SnackBar(content: Text("Tente novamente"));
                     Scaffold.of(context).showSnackBar(message);
                   }
                },
              ),
            ),
          ),
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

  Widget _buildTextRecordPlays() {
    var text = '';
    _currentAudio.state == AudioPlayerState.PLAYING
        ? text = "Pausar"
        : text = "Play";
    return Text(text, style: TextStyle(color: Colors.white));
  }

  Widget _buildIconPlay() {
    Icon icon;
    _currentAudio.state == AudioPlayerState.PLAYING
        ? icon = new Icon(Icons.pause, size: 20.0)
        : icon = new Icon(Icons.play_arrow, size: 20.0);
    return icon;
  }

  Widget _buildTextRecord(RecordingStatus status) {
    var text = "";
    switch (_currentStatus) {
      case RecordingStatus.Initialized:
        {
          text = 'Começar';
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
          text = 'Novo Áudio';
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
    return Text(text, style: TextStyle(color: Colors.white));
  }

  Widget _buildIcon(RecordingStatus status) {
    Icon icon;
    switch (_currentStatus) {
      case RecordingStatus.Initialized:
        {
          icon = new Icon(Icons.mic);
          break;
        }
      case RecordingStatus.Recording:
        {
          icon = new Icon(Icons.mic_none);
          break;
        }
      case RecordingStatus.Paused:
        {
          icon = new Icon(Icons.pause);
          break;
        }
      case RecordingStatus.Stopped:
        {
          icon = new Icon(Icons.refresh);
          break;
        }
      default:
        break;
    }
    return icon;
  }

  _onPlayAudio() async {
    File file = File(
      "${_current.path}",
    );
    file.openRead();
    await _currentAudio.play(file.path, isLocal: true);

    setState(() {
      _currentAudio.state = AudioPlayerState.PLAYING;
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
}
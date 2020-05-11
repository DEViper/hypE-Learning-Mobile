import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hype_learning/providers/topics.dart';
import 'package:hype_learning/screens/courses_overview_screen.dart';
import 'package:provider/provider.dart';


class AddSolutionScreen extends StatefulWidget {
  static const routeName = '/add-Solution';
  @override
  _AddSolutionScreenState createState() => _AddSolutionScreenState();
}

class _AddSolutionScreenState extends State<AddSolutionScreen> {
  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _announcementFocusNode = FocusNode();

  final _form = GlobalKey<FormState>();

  var _isInit = true;
  var _isLoading = false;
  int _topicId;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _topicId = ModalRoute.of(context).settings.arguments as int;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _titleFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _announcementFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<Topics>(context, listen: false).addSolution(_topicId, _fileName);
    } catch (error) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An error occurred!'),
          content: Text('Something went wrong.'),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pushNamed(Navigator.defaultRouteName);
              },
            )
          ],
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).popAndPushNamed(Navigator.defaultRouteName);
  }

  bool _loadingPath = false;
  String _path;
  Map<String, String> _paths;
  FileType _pickingType = FileType.any;
  String _extension;
  String _fileName;

  void _openFileExplorer() async {
    setState(() => _loadingPath = true);
    try {
      _paths = null;
      _path = await FilePicker.getFilePath(
          type: _pickingType,
          allowedExtensions: (_extension?.isNotEmpty ?? false)
              ? _extension?.replaceAll(' ', '')?.split(',')
              : null);
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (!mounted) return;
    setState(() {
      _loadingPath = false;
      _fileName = _path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dodaj rozwiązanie'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                  
                    RaisedButton(
                      onPressed: () => _openFileExplorer(),
                      child: new Text("Przeglądaj..."),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

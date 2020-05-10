import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hype_learning/helpers/shared_preferences_decoder.dart';
import 'package:hype_learning/main.dart';
import 'package:hype_learning/providers/auth.dart';
import 'package:hype_learning/providers/profile.dart';
import 'package:hype_learning/providers/profiles.dart';
import 'package:hype_learning/screens/user_profile_screen.dart';
import 'package:provider/provider.dart';

import 'courses_overview_screen.dart';

class EditProfileScreen extends StatefulWidget {
  static const routeName = '/edit-profile';

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProfile = Profile(
    id: SharedPreferencesDecoder.getField("userId"),
    email: SharedPreferencesDecoder.getField("email"),
    password: '',
  );
  var _initValues = {
    'email': '',
    'password': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (_editedProfile.id != null) {
        _initValues = {
          'email': _editedProfile.email,
          'password': _editedProfile.password,
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();

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
      await Provider.of<Profiles>(context, listen: false)
          .updateProfile(_editedProfile.id, _editedProfile, _fileName);
          await Provider.of<Auth>(context, listen: false).logout();
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
                Navigator.of(ctx).pushNamed(UserProfileScreen.routeName);
              },
            )
          ],
        ),
      );
    }
    // finally {
    //   setState(() {
    //     _isLoading = false;
    //   });
    //   Navigator.of(context).pop();
    // }

    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).popAndPushNamed(
        Navigator.defaultRouteName); // Navigator.of(context).pop()
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
    // final EditProfileArguments args = ModalRoute.of(context).settings.arguments;
    // int ProfileId = args.id;
    // Profile Profile = args.Profile;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edytuj profil'),
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
                    TextFormField(
                      initialValue: _initValues['email'],
                      decoration: InputDecoration(labelText: 'Email'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_passwordFocusNode);
                      },
                    
                      onSaved: (value) {
                        _editedProfile = Profile(
                          email: value,
                          password: _editedProfile.password,
                          id: _editedProfile.id,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['password'],
                      decoration: InputDecoration(labelText: 'Hasło'),
                      textInputAction: TextInputAction.next,
                  obscureText: true,
                      onSaved: (value) {
                        _editedProfile = Profile(
                          email: _editedProfile.email,
                          password: value,
                          id: _editedProfile.id,
                        );
                      },
                    ),
                    RaisedButton(
                      onPressed: () => _openFileExplorer(),
                      child: new Text("Open file picker"),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

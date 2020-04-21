library repositories.user;

import 'package:hype_learning_flutter/api.dart';
import 'package:hype_learning_flutter/api/model/login_user.dart';
import 'package:hype_learning_flutter/api/model/new_user.dart';
import 'package:hype_learning_flutter/api/model/request/login_user_request.dart';
import 'package:hype_learning_flutter/api/model/request/new_user_request.dart';
import 'package:hype_learning_flutter/api/model/request/update_user_request.dart';
import 'package:hype_learning_flutter/api/model/update_user.dart';
import 'package:hype_learning_flutter/api/profile_api.dart';
import 'package:hype_learning_flutter/api/user_and_authentication_api.dart';
import 'package:hype_learning_flutter/event_emitter.dart';
import 'package:hype_learning_flutter/model/profile.dart';
import 'package:hype_learning_flutter/model/user.dart';
import 'package:hype_learning_flutter/repositories/key_value_repository/key_value_repository.dart';
import 'package:hype_learning_flutter/repositories/user/parse_jwt.dart';

part 'user_events.dart';
part 'user_repository.dart';
library blocs.user;

import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:jaguar_retrofit/jaguar_retrofit.dart';
import 'package:meta/meta.dart';
import 'package:hype_learning_flutter/api/model/login_user.dart';
import 'package:hype_learning_flutter/api/model/new_user.dart';
import 'package:hype_learning_flutter/api/model/update_user.dart';
import 'package:hype_learning_flutter/blocs/auth/bloc.dart';
import 'package:hype_learning_flutter/model/user.dart';
import 'package:hype_learning_flutter/repositories/user/repository.dart';

part 'user_bloc.dart';
part 'user_events.dart';
part 'user_state.dart';
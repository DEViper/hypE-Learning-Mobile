import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;
final storage = new FlutterSecureStorage();

void setupLocator(){
locator.registerSingleton<FlutterSecureStorage>(storage, signalsReady: true);

}


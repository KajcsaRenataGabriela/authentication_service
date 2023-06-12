import 'package:uuid/uuid.dart';

import '../models/user_model.dart';

String generateAuthToken(UserModel user) {
  final token = Uuid().v4();
  return token;
}

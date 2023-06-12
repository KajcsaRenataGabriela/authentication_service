import '../services/authentication_service.dart';
import '../utils/auth_utils.dart';
import '../utils/response.dart';
import '../utils/status_code.dart';
import '../utils/validation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class AuthenticationController {
  final AuthenticationService _authenticationService;

  AuthenticationController(this._authenticationService);

  Future<AppResponse> signUp(Map<String, dynamic> requestData) async {
    // Extract required fields from requestData
    final email = requestData['email'];
    final password = requestData['password'];

    // Validate input fields
    final validationErrors = Validation.validateSignUpFields(email, password);
    if (validationErrors.isNotEmpty) {
      return AppResponse(
        status: StatusCode.badRequest,
        message: 'Validation error',
        data: {'errors': validationErrors},
      );
    }

    // Call the authentication service to sign up the user
    try {
      final UserCredential userCredential = await _authenticationService
          .signUpWithEmailAndPassword(email, password);
      final UserModel user = UserModel(
        id: userCredential.user!.uid,
        email: userCredential.user!.email!,
      );
      // Optionally, perform additional operations like saving the user to a database
      return AppResponse(
        status: StatusCode.created,
        message: 'User registered successfully',
        data: {'user': user.toMap()},
      );
    } catch (e) {
      return AppResponse(
        status: StatusCode.internalServerError,
        message: 'Error signing up',
        data: {'error': e.toString()},
      );
    }
  }

  Future<AppResponse> signIn(Map<String, dynamic> requestData) async {
    // Extract required fields from requestData
    final email = requestData['email'];
    final password = requestData['password'];

    // Validate input fields
    final validationErrors = Validation.validateSignInFields(email, password);
    if (validationErrors.isNotEmpty) {
      return AppResponse(
        status: StatusCode.badRequest,
        message: 'Validation error',
        data: {'errors': validationErrors},
      );
    }

    // Call the authentication service to sign in the user
    try {
      final UserCredential userCredential = await _authenticationService
          .signInWithEmailAndPassword(email, password);
      final UserModel user = UserModel(
        id: userCredential.user!.uid,
        email: userCredential.user!.email!,
      );
      // Optionally, generate an authentication token or session ID
      final token = generateAuthToken(user);
      return AppResponse(
        status: StatusCode.ok,
        message: 'User signed in successfully',
        data: {'user': user.toMap(), 'token': token},
      );
    } catch (e) {
      return AppResponse(
        status: StatusCode.unauthorized,
        message: 'Invalid credentials',
        data: {'error': e.toString()},
      );
    }
  }
}

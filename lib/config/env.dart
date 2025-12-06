import 'package:flutter_dotenv/flutter_dotenv.dart';

String kBaseApiUrl = dotenv.env['BASE_API_URL']!;

String kBaseImageUrl = dotenv.env['BASE_IMAGE_URL']!;   

String kBaseSocketUrl = dotenv.env['BASE_SOCKET_URL']!;

String kAppName = dotenv.env['APP_NAME']!;

String kAppTag = dotenv.env['APP_TAG']!;

String kAppId = dotenv.env['APP_ID']!;

String kAppStoreId = dotenv.env['APP_STORE_ID']!;

String kAppWebsite = dotenv.env['APP_WEBSITE']!;

String kPolicyUrl = dotenv.env['POLICY_URL']!;

String kTermsUrl = dotenv.env['TERMS_URL']!;

String kGoogleApiKey = dotenv.env['GOOGLE_API_KEY']!;

String kProxyBaseUrl =
    '${kBaseApiUrl}proxy/https://maps.googleapis.com/maps/api';

String kFirebaseSignInWithAppleCallbackUrl =
    dotenv.env['FIREBASE_SIGN_IN_WITH_APPLE_CALLBACK_URL']!;

String kFirebaseSignInWithAppleClientId =
    dotenv.env['FIREBASE_SIGN_IN_WITH_APPLE_CLIENT_ID']!;

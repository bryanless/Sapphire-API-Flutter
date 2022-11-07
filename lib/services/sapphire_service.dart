part of 'services.dart';

class SapphireService {
  static Future<http.Response> sendMail(String email, String name) {
    return http.post(
      Uri.https(Const.baseUrl, '/week5/api/student/sendmail'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=utf-8',
        'Connection': 'Keep-Alive',
        'API-KEY': dotenv.env[Const.varApiKey]!
      },
      body: jsonEncode(
        <String, dynamic>{
          'email': email,
          'name': name,
        },
      ),
    );
  }
}

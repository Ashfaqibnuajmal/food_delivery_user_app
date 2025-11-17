import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class CloudinaryService {
  static const cloudName = "dsuwmcmw4";
  static const cloudPreset = "flutter_uploads";
  static const cloudApiKey = "837695524881733";
  static const cloudApiSecretKey = "BMxWLGuxc0qhl2QAlwmLsXXS3k0";

  static Future<String?> uploadImage(Uint8List image) async {
    try {
      final url =
          Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");

      final request = http.MultipartRequest("POST", url)
        ..fields['upload_preset'] = cloudPreset
        ..files.add(http.MultipartFile.fromBytes(
          "file",
          image,
          filename: "user_profile",
        ));

      final response = await request.send();
      if (response.statusCode == 200) {
        final res = await http.Response.fromStream(response);
        final data = jsonDecode(res.body);
        return data["secure_url"];
      } else {
        log("Failed to upload image: ${response.statusCode}");
      }
    } catch (e) {
      log("Cloudinary upload error: $e");
    }
    return null;
  }
}

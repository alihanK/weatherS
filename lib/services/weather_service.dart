import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weathers/models/weather_model.dart';

class WeatherService {
  static const BASE_URL = 'API URL HERE';

  final String apiKey;
  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final response = await http
        .get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('ERROR');
    }
  }

  Future<String> getCurrentCity() async {
    // kullanıcıdan izin alma
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    //son yeri alma
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    //bulunan konumu plaemark nesnelerine çevirme
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    //ilk placemark nesnesinden şehir adını çıkartma
    String? city = placemarks[0].locality;
    return city ?? "";
  }
}

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weathers/models/weather_model.dart';
import 'package:weathers/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  //api key
  final _weatherService = WeatherService('YOUR API KEY HERE');
  Weather? _weather;

  //hava durmunu çekme
  _fetchWeather() async {
    //son şehri çekme
    String cityName = await _weatherService.getCurrentCity();

    //şehrin hava durumu çekme
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }
    //herhangi bir hata durmunda
    catch (e) {
      print(e);
    }
  }

  //hava durumu animasyonları
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null)
      return 'assets/images/sunny.json'; //default değer

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/images/cloud.json';
      case 'rain':
      case 'shower rain':
        return 'assets/images/rain.json';
      case 'thunderstorm':
        return 'assets/images/thunder.json';
      case 'clear':
        return 'assets/images/sunny.json';
      case 'clouds':
      default:
        return 'assets/images/sunny.json';
    }
  }

  //başlangıç durumunda olacaklar
  @override
  void initState() {
    super.initState();
    //başlangıç durumndaki hava durumunu çekme
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.lightBlue,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //şehir adı
              Text(_weather?.cityName ?? "city loading"),

              //animasyon
              Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

              //sıcaklık
              Text("${_weather?.temperature.round()}Degree"),

              //hava durumu şartları
              Text(_weather?.mainCondition ?? ""),
            ],
          ),
        ));
  }
}

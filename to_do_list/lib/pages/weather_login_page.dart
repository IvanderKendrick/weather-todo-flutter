import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:to_do_list/models/weather_model.dart';
import 'package:to_do_list/pages/home_page.dart';
import 'package:to_do_list/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // api key
  final _weatherService = WeatherService('aa82cc4f6cbcbbc6c752b11fa2110010');
  Weather? _weather;

  // fetch weather
  _fetchWeather() async {
    // get current city
    String cityName = await _weatherService.getCurrentCity();

    // get weather for city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }

    // any errors
    catch (e) {
      print(e);
    }
  }

  // weather animations
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json'; // default to sunny

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  // init state
  @override
  void initState() {
    super.initState();

    // fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Image.asset('assets/logo.png'),
          title: Column(
            children: [
              // city name
              Text(
                _weather?.cityName ?? "Loading City ...",
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),

              // weather condition
              // Text(
              //   _weather?.mainCondition ?? "",
              //   style: TextStyle(
              //     fontSize: 12.0,
              //   ),
              // ),
            ],
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [Color(0xff003940), Color(0xff005b66)],
            stops: [0.25, 0.75],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          )),
          // height: MediaQuery.of(context).size.height,
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // animation
                  Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

                  // temperature
                  Text(
                    '${_weather?.temperature.round()}℃',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                    ),
                  ),
                ],
              ),

              // Email & Password
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextField(
                      controller: _emailController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Color(0xff004e9b), width: 2)),
                          labelStyle: TextStyle(color: Colors.white)),
                    ),

                    SizedBox(height: 20),

                    TextField(
                      controller: _passwordController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Color(0xff004e9b), width: 2)),
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      obscureText: true,
                    ),

                    SizedBox(height: 20),

                    // Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {},
                            child: Text('Cancel',
                                style: TextStyle(color: Colors.white))),
                        ElevatedButton(
                          onPressed: () {
                            _login();
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(color: Color(0xff26747e)),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _login() {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (_validate(email, password)) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      print("Login Gagal");
    }
  }

  bool _validate(String email, String password) {
    if (email.isEmpty || !email.contains('@')) {
      return false;
    }
    if (password.isEmpty) {
      return false;
    }
    return true;
  }
}

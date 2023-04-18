import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

const apiKey = 'ba1a0d9cbd9a181dd1cc6255f42cfb6c';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const String _title = 'Application';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Application'),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.games_outlined),
              ),
              Tab(
                icon: Icon(Icons.rocket),
              ),
              Tab(
                icon: Icon(Icons.cloud_outlined),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Center(
              child: Text("There's nothing here."),
            ),
            Center(
              child: Text("There is nothing here either."),
            ),
            WeatherReport(),
          ],
        ),
      ),
    );
  }
}

class WeatherReport extends StatefulWidget {
  const WeatherReport({super.key});

  @override
  State<WeatherReport> createState() => _WeatherReportState();
}

class _WeatherReportState extends State<WeatherReport> {
  String city = 'Almaty';
  String temperature = '';
  String weatherIcon = '';

  Future<void> fetchWeatherData() async {
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      print(data);

      setState(() {
        temperature = data['main']['temp'].toStringAsFixed(1);

        weatherIcon = data['weather'][0]['icon'];
      });
    }
  }

  @override
  void initState() {
    super.initState();

    fetchWeatherData();
  }

  String _dropdownValue = 'Almaty';

  void dropdownCallback(String? selectedValue) {
    if (selectedValue is String) {
      setState(() {
        city = selectedValue;
        _dropdownValue = selectedValue;
        fetchWeatherData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 20),
        DropdownButton(
          isExpanded: true,
          items: [
            DropdownMenuItem(
                child: Center(child: Text('Almaty')), value: 'Almaty'),
            DropdownMenuItem(
                child: Center(child: Text('Astana')), value: 'Astana'),
            DropdownMenuItem(child: Center(child: Text('Kair')), value: 'Kair'),
            DropdownMenuItem(
                child: Center(child: Text('New York')), value: 'New York'),
            DropdownMenuItem(
                child: Center(child: Text('Tokio')), value: 'Tokio'),
            DropdownMenuItem(
                child: Center(child: Text('Madrid')), value: 'Madrid'),
          ],
          value: _dropdownValue,
          onChanged: dropdownCallback,
        ),
        const SizedBox(height: 20),
        TextField(
          onChanged: (value) => city = value,
          style: const TextStyle(color: Colors.green),
          decoration: InputDecoration(
            hintText: 'Enter city name',
            border: OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: fetchWeatherData,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              city,
              style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightBlue),
            ),
            weatherIcon.isEmpty
                ? CircularProgressIndicator()
                : Image.network(
                    'https://openweathermap.org/img/w/$weatherIcon.png',
                    height: 100.0,
                    width: 100.0,
                  ),
            Text(
              '$temperature°C',
              style: const TextStyle(
                  fontSize: 48.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange),
            ),
          ],
        )
      ],
    );
  }
}

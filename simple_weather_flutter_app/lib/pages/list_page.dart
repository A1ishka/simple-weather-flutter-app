import 'package:flutter/material.dart';

import '../models/weather_model.dart';
import '../services/weather_service.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final _weatherService = WeatherService();
  bool _loading = true;
  bool _isHovered = false;

  List<Weather> cities = [];

  void _removeCity(int index) {
    cities.removeAt(index);
  }

  Future<void> _fetchWeatherByCity(String cityName) async {
    setState(() {
      _loading = true;
    });

    try {
      var weather = await _weatherService.getWeather(cityName);
      setState(() {
        cities.add(weather);
        _loading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[200],
        title: Center(child: Text('Weather observing list')),
      ),
      body: ListView.builder(
        itemCount: cities.length,
        itemBuilder: (context, index) {
          final cityWeather = cities[index];

          return ListTile(
              title: Text(cityWeather.cityName),
              subtitle: Text(cityWeather.mainCondition),
              tileColor: cityWeather.temperature > 0 ? Colors.red[100] : Colors.blue[100],
              trailing: MouseRegion(
                onEnter: (event) {
                  setState(() {
                    _isHovered = true;
                  });
                  },
                onExit: (event) {
                  setState(() {
                    _isHovered = false;
                  });
                  },
                child: IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: _isHovered ? Colors.red : null,
                  ),
                  onPressed: () {
                    setState(() {
                      _removeCity(index);
                    });
                    },
                ),
              )
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final cityName = await showDialog(
            context: context,
            builder: (context) => AddCityDialog(),
          );

          if (cityName != null) {
            setState(() {
              _fetchWeatherByCity(cityName);
            });
          }
        },
      ),
    );
  }
}

class AddCityDialog extends StatefulWidget {
  @override
  _AddCityDialogState createState() => _AddCityDialogState();
}

class _AddCityDialogState extends State<AddCityDialog> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add City'),
      content: TextField(
        controller: _textEditingController,
        decoration: InputDecoration(
          labelText: 'City Name',
        ),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Add'),
          onPressed: () {
            final cityName = _textEditingController.text.trim();
            if (cityName.isNotEmpty) {
              Navigator.of(context).pop(cityName);
            }
          },
        ),
      ],
    );
  }
}

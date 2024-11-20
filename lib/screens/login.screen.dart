import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'City Search and Favorites',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CitySearchPage(),
    );
  }
}

class CitySearchPage extends StatefulWidget {
  @override
  _CitySearchPageState createState() => _CitySearchPageState();
}

class _CitySearchPageState extends State<CitySearchPage> {
  final List<String> cities = [
    'Hanoi',
    'Ho Chi Minh City',
    'Da Nang',
    'Hue',
    'Nha Trang'
  ];
  final List<String> favoriteCities = [];
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('City Search and Favorites'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search City',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView(
              children: cities
                  .where((city) =>
                      city.toLowerCase().contains(searchQuery.toLowerCase()))
                  .map((city) => ListTile(
                        title: Text(city),
                        trailing: IconButton(
                          icon: Icon(
                            favoriteCities.contains(city)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: favoriteCities.contains(city)
                                ? Colors.red
                                : null,
                          ),
                          onPressed: () {
                            setState(() {
                              if (favoriteCities.contains(city)) {
                                favoriteCities.remove(city);
                              } else {
                                favoriteCities.add(city);
                              }
                            });
                          },
                        ),
                      ))
                  .toList(),
            ),
          ),
          Divider(),
          Text(
            'Favorite Cities',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: favoriteCities.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(favoriteCities[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        favoriteCities.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

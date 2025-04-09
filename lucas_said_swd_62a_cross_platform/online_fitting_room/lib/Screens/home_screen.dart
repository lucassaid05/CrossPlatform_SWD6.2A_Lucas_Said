import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _countryInfo = 'Loading country info...';

  @override
  void initState() {
    super.initState();
    _fetchCountryInfo();
  }

  Future<void> _fetchCountryInfo() async {
    const country = 'Malta';
    final url = Uri.parse('https://restcountries.com/v3.1/name/$country');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final countryData = data[0];

        final name = countryData['name']['common'];
        final capital = (countryData['capital'] as List).first;
        final region = countryData['region'];
        final language = (countryData['languages'] as Map).values.first;

        setState(() {
          _countryInfo =
              '$name - Capital: $capital\nRegion: $region, Language: $language';
        });
      } else {
        setState(() {
          _countryInfo = 'Failed to load country info';
        });
      }
    } catch (e) {
      setState(() {
        _countryInfo = 'Error loading country info';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'AR Online Fitting Room',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'The app where you can try on clothes in the comfort of your home',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  _countryInfo,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.white60),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              },
              icon: const Icon(Icons.person),
              label: const Text("Profile"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white12,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

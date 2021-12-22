import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:weather_app/helpers/constants.dart';
import 'package:weather_app/helpers/navigation.dart';
import 'package:weather_app/models/weather_info.dart';
import 'package:weather_app/widgets/main_weather_widget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of my application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: const WeatherApi(),
    );
  }
}

class WeatherApi extends StatefulWidget {
  final String? myCity;
  const WeatherApi({
    Key? key,
    this.myCity,
  }) : super(key: key);
  @override
  _WeatherApiState createState() => _WeatherApiState();
}

class _WeatherApiState extends State<WeatherApi> {
  Future<WeatherInfo> getWeather() async {
    final requestUrl = widget.myCity == null
        ? "https://api.openweathermap.org/data/2.5/weather?q=Mumbai&units=metric&appid=aced80f19beb9f4cc372d5c96edadc8a"
        : "https://api.openweathermap.org/data/2.5/weather?q=${widget.myCity.toString()}&units=metric&appid=aced80f19beb9f4cc372d5c96edadc8a";

    final response = await http.get(Uri.parse(requestUrl));
    if (response.statusCode == 200) {
      return WeatherInfo.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Error loading request URL info.");
    }
  }

  late Future<WeatherInfo> futureWeather;

  @override
  void initState() {
    super.initState();
    futureWeather = getWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showBottomDialog();
        },
        child: const Icon(
          Icons.location_on,
          color: white,
        ),
        backgroundColor: myBlue,
      ),
      body: FutureBuilder<WeatherInfo>(
        future: futureWeather,
        builder: (BuildContext context, AsyncSnapshot<WeatherInfo> snapshot) {
          if (snapshot.hasData) {
            return MainWeatherWidget(
              location: snapshot.data!.location,
              weather: snapshot.data!.weather,
              temperature: snapshot.data!.temperature,
              tempMin: snapshot.data!.tempMin,
              tempMax: snapshot.data!.tempMax,
              windSpeed: snapshot.data!.windSpeed,
              humidity: snapshot.data!.humidity,
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                children: [
                  Text('${snapshot.error}'),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      navigateWithReplacement(
                        context,
                        const WeatherApi(),
                      );
                    },
                    child: Text(
                      "Retry",
                      style: TextStyle(
                        color: myBlue,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return SpinKitSpinningLines(
            size: 100,
            color: myBlue,
          );
        },
      ),
    );
  }

  TextEditingController cityController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  late String enteredCity;
  showBottomDialog() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: SingleChildScrollView(
          child: SizedBox(
            height: 240,
            child: Form(
              key: _formKey,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                child: Column(
                  children: <Widget>[
                    CSCPicker(
                      ///Enable disable state dropdown [OPTIONAL PARAMETER]
                      showStates: true,

                      /// Enable disable city drop down [OPTIONAL PARAMETER]
                      showCities: true,

                      defaultCountry: DefaultCountry.India,

                      ///Enable (get flag with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
                      // flagState: CountryFlag.DISABLE,
                      flagState: CountryFlag.ENABLE,

                      ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
                      dropdownDecoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        color: myBlue,
                        border: Border.all(color: myBlue, width: 1.5),
                      ),

                      ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                      disabledDropdownDecoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        color: myBlue,
                        border: Border.all(color: myBlue, width: 1.5),
                      ),

                      ///placeholders for dropdown search field
                      countrySearchPlaceholder: "Country",
                      stateSearchPlaceholder: "State",
                      citySearchPlaceholder: "City",

                      ///labels for dropdown
                      countryDropdownLabel: "Country",
                      stateDropdownLabel: "State",
                      cityDropdownLabel: "City",

                      ///selected item style [OPTIONAL PARAMETER]
                      selectedItemStyle: const TextStyle(
                        color: white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),

                      ///DropdownDialog Heading style [OPTIONAL PARAMETER]
                      dropdownHeadingStyle: const TextStyle(
                        color: white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),

                      ///DropdownDialog Item style [OPTIONAL PARAMETER]
                      dropdownItemStyle: const TextStyle(
                        color: white,
                        fontSize: 14,
                      ),

                      ///Dialog box radius [OPTIONAL PARAMETER]
                      dropdownDialogRadius: 15.0,

                      ///Search bar radius [OPTIONAL PARAMETER]
                      searchBarRadius: 15.0,

                      ///triggers once country selected in dropdown
                      onCountryChanged: (value) {
                        setState(() {
                          ///store value in country variable
                          countryValue = value.toString();
                        });
                      },

                      ///triggers once state selected in dropdown
                      onStateChanged: (value) {
                        setState(() {
                          ///store value in state variable
                          stateValue = value.toString();
                        });
                      },

                      ///triggers once city selected in dropdown
                      onCityChanged: (value) {
                        setState(() {
                          ///store value in city variable
                          cityValue = value.toString();
                        });
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (cityValue != 'null') {
                            Navigator.pop(context);
                            navigateWithReplacement(
                              context,
                              WeatherApi(
                                myCity: cityValue,
                              ),
                            );
                          } else if (stateValue == 'null') {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: Text(
                                  'Please select a State',
                                  style: GoogleFonts.ptSans(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w600,
                                    color: white,
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'OK'),
                                    child: Text(
                                      'OK',
                                      style: GoogleFonts.ptSans(
                                        fontSize: 25.0,
                                        fontWeight: FontWeight.w600,
                                        color: white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: Text(
                                  'Please select a City',
                                  style: GoogleFonts.ptSans(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w600,
                                    color: white,
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'OK'),
                                    child: Text(
                                      'OK',
                                      style: GoogleFonts.ptSans(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w600,
                                        color: white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: myBlue,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20.0),
                            ),
                          ),
                        ),
                        child: Text(
                          'Search',
                          style: GoogleFonts.ptSans(
                            fontSize: 25.0,
                            fontWeight: FontWeight.w600,
                            color: white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

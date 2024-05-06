import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';

void main() => runApp(MaterialApp(home: Main()));

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  double carat = 0;
  String cut = "";
  String color = "";
  String clarity = "";
  double depth = 0.0;
  double table = 0.0;
  double x = 0.0;
  double y = 0.0;
  double z = 0.0;
  String? selectedCut; // Variable to hold the selected value
  String? selectedColor; // Variable to hold the selected value
  String? selectedClarity; // Variable to hold the selected value

  // Future<String?> predictPrice(var body) async {
  // var uri = Uri.parse("https://mega.us-east-1.modelbit.com/v1/predictd/latest");
  // var headers = {"Content-type": "application/json"};
  // var jsonString = json.encode({"data": body});
  // print(jsonString);
  // try {
  //   var response = await http.post(uri, headers: headers, body: jsonString);
  //   print(response.body);
  //   if (response.statusCode == 200) {
  //     var result = json.decode(response.body);
  //     return result["prediction"];
  //   } else {
  //     return "Error: ${response.statusCode}";
  //   }
  // } catch (e) {
  //   return "Exception occurred: $e";
  // }
  Future<String?> predictPrice(
      double carat,
      String cut,
      String color,
      String clarity,
      double depth,
      double table,
      double x,
      double y,
      double z) async {
    var uri =
        Uri.parse("https://mega.us-east-1.modelbit.com/v1/predictd/latest");
    var headers = {"Content-type": "application/json"};
    var jsonString = json.encode({
      "data": [carat, cut, color, clarity, depth, table, x, y, z]
    });
    print(jsonString);

    try {
      var response = await http.post(uri, headers: headers, body: jsonString);
      print(response.body);
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        var predictedPrice = jsonResponse['data'][0];
        return predictedPrice.toString();
      } else {
        return "Error: ${response.statusCode}";
      }
    } catch (e) {
      return "Exception occurred: $e";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Enter carat',
                  ),
                  onChanged: (val) {
                    carat = double.parse(val);
                  },
                ),
                //make it multi select

                DropdownButton<String>(
                  value: selectedCut, // Set the value to the selected value
                  items: <String>[
                    'Ideal',
                    'Premium',
                    'Very Good',
                    'Good',
                    'Fair'
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (val) {
                    // Update the selected value when the user selects an item
                    setState(() {
                      selectedCut = val;
                      cut = val!;
                    });
                  },
                ),

                DropdownButton<String>(
                  value: selectedColor,
                  items: <String>['D', 'E', 'F', 'G', 'H', 'I', 'J']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedColor = val;
                      color = val!;
                    });
                  },
                ),
                DropdownButton<String>(
                  value: selectedClarity,
                  items: <String>[
                    'IF',
                    'VVS1',
                    'VVS2',
                    'VS1',
                    'VS2',
                    'SI1',
                    'SI2',
                    'I1'
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedClarity = val;
                      clarity = val!;
                    });
                  },
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Enter depth',
                  ),
                  onChanged: (val) {
                    depth = double.parse(val);
                  },
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Enter table',
                  ),
                  onChanged: (val) {
                    table = double.parse(val);
                  },
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Enter x',
                  ),
                  onChanged: (val) {
                    x = double.parse(val);
                  },
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Enter y',
                  ),
                  onChanged: (val) {
                    y = double.parse(val);
                  },
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Enter z',
                  ),
                  onChanged: (val) {
                    z = double.parse(val);
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () async {
                    var body = [
                      {
                        "carat": carat,
                        "cut": cut,
                        "color": color,
                        "clarity": clarity,
                        "depth": depth,
                        "table": table,
                        "x": x,
                        "y": y,
                        "z": z
                      }
                    ];
                    print(body);
                    var resp = await predictPrice(
                        carat, cut, color, clarity, depth, table, x, y, z);
                    _onBasicAlertPressed(context, resp);
                  },
                  child: Text("Get price"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onBasicAlertPressed(context, resp) {
    Alert(context: context, title: "Predicted price", desc: resp).show();
  }
}

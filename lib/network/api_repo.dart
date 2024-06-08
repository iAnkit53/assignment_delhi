import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiRepo {

  List<dynamic> categories = [];
  List<dynamic> products = [];

  Future<void> fetchMenuData() async {
    final response = await http.get(
        Uri.parse('https://staging.app2food.com/v30/api/store/menu?store_id=11002'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // setState(() {
        categories = data['data']['category'];
        products = data['data']['product'];
      // });
      print('API Success 200 LBAnkit ');
    } else {
      throw Exception('Failed to load menu data');
    }
  }

}
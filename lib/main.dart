import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('DyRam Foods🥙'),
        ),
        body: FoodOrderFormWidget(),
      ),
    );
  }
}

class FoodOrderFormWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FoodOrderForm();
  }
}

class FoodOrderForm extends StatefulWidget {
  @override
  _FoodOrderFormState createState() => _FoodOrderFormState();
}

class _FoodOrderFormState extends State<FoodOrderForm> {
  String? _selectedFood;
  int _quantity = 1;
  String _orderSummary = '';
  String _customerName = '';

  final List<String> _foodItems = [
    'Ayam Bakar ',
    'Nasi Liwet ',
    'Nasi Goreng ',
    'Mie Goreng ',
    'Nasi Campur '
  ];

  final _formKey = GlobalKey<FormState>(); // Global key for form validation

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey, // Wrap with Form and associate with _formKey
        child: Column(
          children: <Widget>[
            // Nama pemesan tidak akan terpengaruh oleh scroll
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Nama Pemesan',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama pemesan tidak boleh kosong';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _customerName = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _foodItems.length,
                itemBuilder: (context, index) {
                  final foodItem = _foodItems[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(
                        foodItem,
                        style: TextStyle(fontSize: 18.0),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedFood = foodItem;
                          _quantity = 1;
                        });
                      },
                      tileColor: _selectedFood == foodItem
                          ? Colors.orange
                          : Colors.orangeAccent,
                      textColor: _selectedFood == foodItem
                          ? Colors.white
                          : Colors.black,
                    ),
                  );
                },
              ),
            ),
            // Jika makanan dipilih, tampilkan bagian jumlah dan kirim
            if (_selectedFood != null) ...[
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Jumlah: $_quantity'),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: _quantity > 1
                            ? () {
                                setState(() {
                                  _quantity--;
                                });
                              }
                            : null,
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            _quantity++;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) { // Validate the form
                  if (_selectedFood != null) {
                    setState(() {
                      _orderSummary =
                          'Pesanan $_customerName: $_quantity x $_selectedFood telah diterima!';
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Silakan pilih makanan terlebih dahulu')),
                    );
                  }
                }
              },
              child: Text('Kirim'),
            ),
            SizedBox(height: 16.0),
            Text(
              _orderSummary,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

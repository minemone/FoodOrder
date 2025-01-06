import 'package:flutter/material.dart';
import 'dart:math'; // ใช้สำหรับการสุ่ม
import 'Menu.dart'; // ตรวจสอบให้แน่ใจว่าไฟล์ Menu.dart อยู่ในโฟลเดอร์เดียวกัน

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 255, 186, 253)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'FoodOrder'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Menu> _menuItems; // ใช้ List สำหรับจัดเก็บ Menu

  // รายการชื่อเมนู, ส่วนผสม และช่วงราคาที่จะสุ่ม
  final List<String> _menuNames = ['Pizza', 'Burger', 'Pasta', 'Salad', 'Sushi', 'Sandwich', 'Steak', 'Fries', 'Soup', 'Tacos'];
  final List<String> _ingredients = ['Cheese, Tomato, Lettuce', 'Beef, Lettuce, Onion', 'Pasta, Tomato Sauce, Basil', 'Lettuce, Carrot, Dressing', 'Rice, Fish, Seaweed', 'Bread, Ham, Cheese', 'Beef, Potatoes, Carrots', 'Potato, Oil, Salt', 'Chicken, Vegetables, Broth', 'Tortilla, Beef, Cheese'];
  
  @override
  void initState() {
    super.initState();
    _initializeMenuItems(); // กำหนดค่าเริ่มต้นใน initState
  }

  // กำหนดค่าเริ่มต้นให้กับรายการเมนู
  void _initializeMenuItems() {
    _menuItems = [];
  }

  // ฟังก์ชันเพิ่มเมนูสุ่ม 1 รายการ
  void _addMoreMenuItem() {
    setState(() {
      // สร้างเมนูใหม่ที่สุ่มชื่อ, ราคา และส่วนผสม
      String randomName = _menuNames[Random().nextInt(_menuNames.length)];
      int randomPrice = 80 + Random().nextInt(50); // สุ่มราคา
      String randomIngredient = _ingredients[Random().nextInt(_ingredients.length)];

      Menu newMenu = Menu(
        name: randomName,
        price: randomPrice,
        ingredient: randomIngredient
      );

      // ตรวจสอบว่ามีเมนูนี้อยู่ใน _menuItems หรือไม่
      if (!_menuItems.any((item) => item.name == newMenu.name)) {
        _menuItems.add(newMenu); // เพิ่มเมนูใหม่
      }
    });
  }

  // รีเซ็ตเมนู
  void _resetMenuItems() {
    setState(() {
      _initializeMenuItems(); // รีเซ็ตค่าเมนู
    });
  }

  // คำนวณผลรวมของราคาทั้งหมด
  int _calculateTotalPrice() {
    return _menuItems.fold(0, (sum, item) => sum + item.price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title),
            Text(
              'Total Price: ${_calculateTotalPrice()}', // แสดงผลรวมของราคา
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                final menuItem = _menuItems[index]; // ใช้เมนูตามตำแหน่งในรายการ
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.pink, // สีพื้นหลังของวงกลม
                    child: Text(
                      '${menuItem.price}', // แสดงราคาในวงกลม
                      style: const TextStyle(
                        color: Colors.white, // สีของตัวเลขในวงกลม
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    'Dish ${index}: ${menuItem.name}', // เปลี่ยนจาก 'Name' เป็น 'Dish' พร้อมกับตัวเลข index
                    style: const TextStyle(fontSize: 20), // ปรับขนาดตัวอักษร
                  ),
                  subtitle: Text(
                    'Ingredient: ${menuItem.ingredient}', // แสดงส่วนผสม
                    style: const TextStyle(fontSize: 16), // ปรับขนาดตัวอักษรของ subtitle
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: _addMoreMenuItem, // เพิ่มเมนูสุ่ม 1 รายการ
            tooltip: 'Add Menu Item',
            backgroundColor: const Color.fromARGB(255, 65, 193, 248),
            child: const Icon(Icons.add), // เปลี่ยนเป็นเครื่องหมาย "+"
          ),
          const SizedBox(height: 10), // ระยะห่างระหว่างปุ่ม
          FloatingActionButton(
            onPressed: _resetMenuItems, // รีเซ็ตเมนู
            tooltip: 'Reset Menu',
            backgroundColor: Colors.red, // สีปุ่ม Reset
            child: const Icon(Icons.restart_alt), // ไอคอน "วงกลมรีเซ็ต"
          ),
        ],
      ),
    );
  }
}

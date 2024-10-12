import 'package:flutter/material.dart';

class MyTask extends StatelessWidget {
  const MyTask({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'تطبيق العيادة',
      home: HomeScreenMyTask(),
    );
  }
}

class HomeScreenMyTask extends StatelessWidget {
  const HomeScreenMyTask({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تطبيق العيادة'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('قائمة مخصصة'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CustomListScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('صورة مع أيقونات'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ImageWithIconsScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('تقييم النجوم'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const StarRatingScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('تبديل اللغة'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const LanguageSwitchScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('التحقق من كلمة المرور'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PasswordCheckScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CustomListScreen extends StatelessWidget {
  final List<String> items = ['عنصر 1', 'عنصر 2', 'عنصر 3'];

  CustomListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('قائمة مخصصة'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: const Icon(Icons.label),
              title: Text(items[index]),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                // Navigate to detail page or perform any action
              },
            ),
          );
        },
      ),
    );
  }
}

class ImageWithIconsScreen extends StatelessWidget {
  const ImageWithIconsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('صورة مع أيقونات'),
      ),
      body: Column(
        children: [
          Image.asset('assets/images/image.png'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Page1()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.star),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Page2()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Page3()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الصفحة 1')),
      body: const Center(child: Text('مرحبًا بك في الصفحة 1')),
    );
  }
}

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الصفحة 2')),
      body: const Center(child: Text('مرحبًا بك في الصفحة 2')),
    );
  }
}

class Page3 extends StatelessWidget {
  const Page3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الصفحة 3')),
      body: const Center(child: Text('مرحبًا بك في الصفحة 3')),
    );
  }
}

class StarRatingScreen extends StatefulWidget {
  const StarRatingScreen({super.key});

  @override
  _StarRatingScreenState createState() => _StarRatingScreenState();
}

class _StarRatingScreenState extends State<StarRatingScreen> {
  int _rating = 0;

  Widget buildStar(int index) {
    return IconButton(
      icon: Icon(
        index < _rating ? Icons.star : Icons.star_border,
      ),
      color: Colors.amber,
      onPressed: () {
        setState(() {
          _rating = index + 1;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تقييم النجوم'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (index) => buildStar(index)),
      ),
    );
  }
}

class LanguageSwitchScreen extends StatefulWidget {
  const LanguageSwitchScreen({super.key});

  @override
  _LanguageSwitchScreenState createState() => _LanguageSwitchScreenState();
}

class _LanguageSwitchScreenState extends State<LanguageSwitchScreen> {
  bool _isEnglish = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تبديل اللغة'),
      ),
      body: SwitchListTile(
        title: Text(_isEnglish ? 'English' : 'العربية'),
        value: _isEnglish,
        onChanged: (bool value) {
          setState(() {
            _isEnglish = value;
            // Update text alignment or language settings here
          });
        },
      ),
    );
  }
}

class PasswordCheckScreen extends StatefulWidget {
  const PasswordCheckScreen({super.key});

  @override
  _PasswordCheckScreenState createState() => _PasswordCheckScreenState();
}

class _PasswordCheckScreenState extends State<PasswordCheckScreen> {
  final TextEditingController _passwordController = TextEditingController();
  String _message = '';

  void _checkPassword() {
    String password = _passwordController.text;
    if (password.length > 10) {
      setState(() {
        _message = 'كلمة المرور يجب ألا تتجاوز 10 أحرف.';
      });
    } else if (!RegExp(r'^(?=.*?[A-Za-z])(?=.*?[0-9]).{1,}$')
        .hasMatch(password)) {
      setState(() {
        _message = 'كلمة المرور يجب أن تحتوي على أحرف وأرقام.';
      });
    } else {
      setState(() {
        _message = 'كلمة المرور صالحة!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('التحقق من كلمة المرور'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'أدخل كلمة المرور'),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _checkPassword,
              child: const Text('تحقق من كلمة المرور'),
            ),
            Text(_message),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MatrimonyApp());
}

class MatrimonyApp extends StatelessWidget {
  const MatrimonyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Matrimony App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> loginUser() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString("email") ?? "";
    final savedPassword = prefs.getString("password") ?? "";

    if (emailController.text == savedEmail &&
        passwordController.text == savedPassword) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid credentials!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Matrimony Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                  labelText: "Email", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                  labelText: "Password", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: loginUser, child: const Text("Login")),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RegistrationPage()),
                );
              },
              child: const Text("Create Account"),
            ),
          ],
        ),
      ),
    );
  }
}

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final ageController = TextEditingController();
    final genderController = TextEditingController();
    final locationController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    Future<void> saveUser() async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("name", nameController.text);
      await prefs.setString("age", ageController.text);
      await prefs.setString("gender", genderController.text);
      await prefs.setString("location", locationController.text);
      await prefs.setString("email", emailController.text);
      await prefs.setString("password", passwordController.text);
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: "Full Name")),
              const SizedBox(height: 12),
              TextField(controller: ageController, decoration: const InputDecoration(labelText: "Age")),
              const SizedBox(height: 12),
              TextField(controller: genderController, decoration: const InputDecoration(labelText: "Gender")),
              const SizedBox(height: 12),
              TextField(controller: locationController, decoration: const InputDecoration(labelText: "Location")),
              const SizedBox(height: 12),
              TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
              const SizedBox(height: 12),
              TextField(controller: passwordController, obscureText: true, decoration: const InputDecoration(labelText: "Password")),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  await saveUser();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                child: const Text("Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Matrimony Home")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            title: const Text("Profile"),
            leading: const Icon(Icons.person),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
          ListTile(
            title: const Text("Matches"),
            leading: const Icon(Icons.favorite),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MatchesPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<Map<String, String>> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      "name": prefs.getString("name") ?? "",
      "age": prefs.getString("age") ?? "",
      "gender": prefs.getString("gender") ?? "",
      "location": prefs.getString("location") ?? "",
      "email": prefs.getString("email") ?? "",
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Profile")),
      body: FutureBuilder<Map<String, String>>(
        future: loadUser(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final user = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Name: ${user["name"]}"),
                Text("Age: ${user["age"]}"),
                Text("Gender: ${user["gender"]}"),
                Text("Location: ${user["location"]}"),
                Text("Email: ${user["email"]}"),
              ],
            ),
          );
        },
      ),
    );
  }
}

class MatchesPage extends StatelessWidget {
  const MatchesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final matches = [
      "Ayesha, 25, Hyderabad",
      "Fatima, 27, Bangalore",
      "Sara, 24, Chennai",
      "Zara, 26, Delhi",
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Your Matches")),
      body: ListView.builder(
        itemCount: matches.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.favorite, color: Colors.pink),
            title: Text(matches[index]),
          );
        },
      ),
    );
  }
}


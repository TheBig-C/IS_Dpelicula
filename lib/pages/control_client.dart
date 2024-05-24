import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ControlClient extends StatefulWidget {
  const ControlClient({super.key});

  @override
  State<ControlClient> createState() => _ControlClientState();
}

class _ControlClientState extends State<ControlClient> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameFilterController = TextEditingController();
  final TextEditingController ciFilterController = TextEditingController();
  final TextEditingController emailFilterController = TextEditingController();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ciController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController moneyController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController roleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 800;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50.0),
            bottomRight: Radius.circular(50.0),
          ),
          child: AppBar(
            title: Text(
              'Control de Empleados',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.grey[700],
          ),
        ),
      ),
      body: SafeArea(
        child: isDesktop
            ? Center(child: SizedBox(width: 800, child: _buildContent(users)))
            : ListView(children: [_buildContent(users)]),
      ),
    );
  }

  Widget _buildContent(CollectionReference users) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: nameFilterController,
                  decoration: InputDecoration(
                    labelText: 'Buscar por nombre',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: ciFilterController,
                  decoration: InputDecoration(
                    labelText: 'Buscar por Telefono',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: emailFilterController,
                  decoration: InputDecoration(
                    labelText: 'Buscar por email',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
              SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  nameFilterController.clear();
                  ciFilterController.clear();
                  emailFilterController.clear();
                  setState(() {});
                },
              ),
            ],
          ),
        ),
        Expanded(child: _buildUserList(users)),
      ],
    );
  }

  Widget _buildUserList(CollectionReference users) {
    String nameQuery = nameFilterController.text.toLowerCase();
    String ciQuery = ciFilterController.text.toLowerCase();
    String emailQuery = emailFilterController.text.toLowerCase();

    return StreamBuilder<QuerySnapshot>(
      stream: users
          .where('role', whereIn: ['client'])
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Algo salió mal');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        var filteredDocs = snapshot.data!.docs.where((doc) {
          var data = doc.data() as Map<String, dynamic>;
          bool matchesName = nameQuery.isEmpty || data['name'].toString().toLowerCase().contains(nameQuery);
          bool matchesCI = ciQuery.isEmpty || data['phone'].toString().toLowerCase().contains(ciQuery);
          bool matchesEmail = emailQuery.isEmpty || data['email'].toString().toLowerCase().contains(emailQuery);
          return matchesName && matchesCI && matchesEmail;
        }).toList();

        return ListView(
          children: filteredDocs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            return Card(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['name'] ?? 'N/A',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('Dirección: ${data['address'] ?? 'N/A'}',
                        style: TextStyle(color: Colors.black)),
                    Text('Email: ${data['email'] ?? 'N/A'}',
                        style: TextStyle(color: Colors.black)),
                    Text('Dinero: ${data['money']?.toString() ?? 'N/A'}',
                        style: TextStyle(color: Colors.black)),
                    Text('Teléfono: ${data['phone']?.toString() ?? 'N/A'}',
                        style: TextStyle(color: Colors.black)),
                    Text('Rol: ${data['role'] ?? 'N/A'}',
                        style: TextStyle(color: Colors.black)),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            _showEditUserDialog(document.id, data);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _showDeleteConfirmationDialog(document.id, data['email']);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
  void _showEditUserDialog(String userId, Map<String, dynamic> userData) {
    nameController.text = userData['name'] ?? '';
    ciController.text = userData['CI']?.toString() ?? '';
    addressController.text = userData['address'] ?? '';
    emailController.text = userData['email'] ?? '';
    moneyController.text = userData['money']?.toString() ?? '';
    phoneController.text = userData['phone']?.toString() ?? '';
    roleController.text = userData['role'] ?? '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar usuario', style: TextStyle(color: Colors.black)),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Nombre', labelStyle: TextStyle(color: Colors.black)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese un nombre';
                      }
                      return null;
                    },
                    style: TextStyle(color: Colors.black),
                  ),
                  TextFormField(
                    controller: addressController,
                    decoration: InputDecoration(labelText: 'Dirección', labelStyle: TextStyle(color: Colors.black)),
                    style: TextStyle(color: Colors.black),
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: 'Email', labelStyle: TextStyle(color: Colors.black)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese un email';
                      }
                      return null;
                    },
                    style: TextStyle(color: Colors.black),
                  ),
                  TextFormField(
                    controller: moneyController,
                    decoration: InputDecoration(labelText: 'Dinero', labelStyle: TextStyle(color: Colors.black)),
                    style: TextStyle(color: Colors.black),
                  ),
                  TextFormField(
                    controller: phoneController,
                    decoration: InputDecoration(labelText: 'Teléfono', labelStyle: TextStyle(color: Colors.black)),
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancelar', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Guardar', style: TextStyle(color: Colors.black)),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  _updateUser(userId);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateUser(String userId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'name': nameController.text,
        'CI': ciController.text,
        'address': addressController.text,
        'email': emailController.text,
        'money': moneyController.text,
        'phone': phoneController.text,
        'role': roleController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuario actualizado con éxito')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar el usuario: $e')),
      );
    }
  }

  void _showDeleteConfirmationDialog(String userId, String email) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación', style: TextStyle(color: Colors.black)),
          content: Text('¿Estás seguro de que deseas eliminar este usuario?', style: TextStyle(color: Colors.black)),
          actions: [
            TextButton(
              child: Text('Cancelar', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Eliminar', style: TextStyle(color: Colors.black)),
              onPressed: () {
                _deleteUser(userId, email);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteUser(String userId, String email) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).delete();
      User? userToDelete = await _findUserByEmail(email);
      if (userToDelete != null) {
        await userToDelete.delete();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuario eliminado con éxito')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar el usuario: $e')),
      );
    }
  }

  Future<User?> _findUserByEmail(String email) async {
    try {
      var methods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (methods.isNotEmpty) {
        var signInMethod = methods.first;
        if (signInMethod == 'password') {
          var result = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: 'defaultPassword',
          );
          return result.user;
        }
      }
    } catch (e) {
      print('Error al buscar usuario por email: $e');
    }
    return null;
  }
}

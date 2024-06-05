import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class RegisterEmployee extends StatefulWidget {
  const RegisterEmployee({super.key});

  @override
  State<RegisterEmployee> createState() => _RegisterEmployeeState();
}

class _RegisterEmployeeState extends State<RegisterEmployee> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController ciController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  String selectedCIExtension = 'NN';
  final List<String> ciExtensions = [
    'NN',
    'CB',
    'LP',
    'OR',
    'SC',
    'PD',
    'CH',
    'TJ',
    'BE',
    'PO'
  ];

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 800;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');

    Widget registerForm = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              TextFormField(
                controller: nameController,
                textInputAction: TextInputAction.next,
                cursorColor: Theme.of(context).primaryColor,
                style: TextStyle(
                  color: const Color(0xfff4b33c).withOpacity(0.7),
                  fontSize: 18,
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))
                ],
                validator: (name) => name != null && name.isEmpty
                    ? 'Por favor introduzca un nombre'
                    : null,
                decoration: InputDecoration(
                  labelText: "Nombre",
                  floatingLabelStyle: TextStyle(
                      color: const Color(0xfff4b33c).withOpacity(0.7),
                      fontSize: 22),
                  labelStyle: TextStyle(
                      color: const Color(0xfff4b33c).withOpacity(0.7),
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: const Color(0xfff4b33c).withOpacity(0.4)),
                      borderRadius: BorderRadius.circular(16)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: const Color(0xfff4b33c).withOpacity(0.7)),
                      borderRadius: BorderRadius.circular(16)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: const Color(0xfff4b33c).withOpacity(0.7)),
                      borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                textInputAction: TextInputAction.next,
                cursorColor: Theme.of(context).primaryColor,
                style: TextStyle(
                  color: const Color(0xfff4b33c).withOpacity(0.7),
                  fontSize: 18,
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) => email != null && email.isEmpty
                    ? 'Por favor introduzca un email'
                    : null,
                decoration: InputDecoration(
                  labelText: "Email",
                  floatingLabelStyle: TextStyle(
                      color: const Color(0xfff4b33c).withOpacity(0.7),
                      fontSize: 22),
                  labelStyle: TextStyle(
                      color: const Color(0xfff4b33c).withOpacity(0.7),
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: const Color(0xfff4b33c).withOpacity(0.4)),
                      borderRadius: BorderRadius.circular(16)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: const Color(0xfff4b33c).withOpacity(0.7)),
                      borderRadius: BorderRadius.circular(16)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: const Color(0xfff4b33c).withOpacity(0.7)),
                      borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: phoneController,
                textInputAction: TextInputAction.next,
                cursorColor: Theme.of(context).primaryColor,
                style: TextStyle(
                  color: const Color(0xfff4b33c).withOpacity(0.7),
                  fontSize: 18,
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (phone) => phone != null && phone.isEmpty
                    ? 'Por favor introduzca un teléfono'
                    : null,
                decoration: InputDecoration(
                  labelText: "Teléfono",
                  floatingLabelStyle: TextStyle(
                      color: const Color(0xfff4b33c).withOpacity(0.7),
                      fontSize: 22),
                  labelStyle: TextStyle(
                      color: const Color(0xfff4b33c).withOpacity(0.7),
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: const Color(0xfff4b33c).withOpacity(0.4)),
                      borderRadius: BorderRadius.circular(16)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: const Color(0xfff4b33c).withOpacity(0.7)),
                      borderRadius: BorderRadius.circular(16)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: const Color(0xfff4b33c).withOpacity(0.7)),
                      borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 7,
                    child: TextFormField(
                      controller: ciController,
                      textInputAction: TextInputAction.next,
                      cursorColor: Theme.of(context).primaryColor,
                      style: TextStyle(
                        color: const Color(0xfff4b33c).withOpacity(0.7),
                        fontSize: 18,
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (ci) => ci != null &&
                              (ci.isEmpty || ci.length > 8)
                          ? 'Por favor introduzca un carnet de identidad válido'
                          : null,
                      maxLength: 8,
                      decoration: InputDecoration(
                        labelText: "Carnet de identidad",
                        floatingLabelStyle: TextStyle(
                            color: const Color(0xfff4b33c).withOpacity(0.7),
                            fontSize: 22),
                        labelStyle: TextStyle(
                            color: const Color(0xfff4b33c).withOpacity(0.7),
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    const Color(0xfff4b33c).withOpacity(0.4)),
                            borderRadius: BorderRadius.circular(16)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    const Color(0xfff4b33c).withOpacity(0.7)),
                            borderRadius: BorderRadius.circular(16)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    const Color(0xfff4b33c).withOpacity(0.7)),
                            borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 3,
                    child: DropdownButtonFormField<String>(
                      value: selectedCIExtension,
                      items: ciExtensions.map((extension) {
                        return DropdownMenuItem<String>(
                          value: extension,
                          child: Text(
                            extension,
                            style: const TextStyle(color: Color(0xfff4b33c)),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCIExtension = value!;
                        });
                      },
                      dropdownColor: const Color(0xff1C1C27), // Azul oscuro
                      decoration: InputDecoration(
                        labelText: "Extensión",
                        floatingLabelStyle: TextStyle(
                            color: const Color(0xfff4b33c).withOpacity(0.7),
                            fontSize: 22),
                        labelStyle: TextStyle(
                            color: const Color(0xfff4b33c).withOpacity(0.7),
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    const Color(0xfff4b33c).withOpacity(0.4)),
                            borderRadius: BorderRadius.circular(16)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(16)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    const Color(0xfff4b33c).withOpacity(0.7)),
                            borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: addressController,
                textInputAction: TextInputAction.done,
                cursorColor: Theme.of(context).primaryColor,
                style: TextStyle(
                  color: const Color(0xfff4b33c).withOpacity(0.7),
                  fontSize: 18,
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (address) => address != null && address.isEmpty
                    ? 'Por favor introduzca una dirección'
                    : null,
                decoration: InputDecoration(
                  labelText: "Dirección",
                  floatingLabelStyle: TextStyle(
                      color: const Color(0xfff4b33c).withOpacity(0.7),
                      fontSize: 22),
                  labelStyle: TextStyle(
                      color: const Color(0xfff4b33c).withOpacity(0.7),
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: const Color(0xfff4b33c).withOpacity(0.4)),
                      borderRadius: BorderRadius.circular(16)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: const Color(0xfff4b33c).withOpacity(0.7)),
                      borderRadius: BorderRadius.circular(16)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: const Color(0xfff4b33c).withOpacity(0.7)),
                      borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final isValid = formKey.currentState!.validate();
                  if (!isValid) return;
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => Center(
                          child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor)));

                  FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: emailController.text.trim(),
                          password:
                              ciController.text.trim() + selectedCIExtension)
                      .then((userCredential) =>
                          users.doc(userCredential.user!.uid).set({
                            'money': 0,
                            'email': emailController.text.trim(),
                            'name': nameController.text.trim(),
                            'CI':
                                ciController.text.trim() + selectedCIExtension,
                            'phone': phoneController.text.trim(),
                            'address': addressController.text.trim(),
                            'role': 'admin',
                          }))
                      .then((_) {
                    Navigator.of(context, rootNavigator: true).pop();
                    showTopSnackBar(
                        Overlay.of(context)!,
                        const CustomSnackBar.success(
                            message: 'Empleado fue registrado exitosamente'));
                  }).catchError((e) {
                    Navigator.of(context, rootNavigator: true).pop();
                    showTopSnackBar(
                        Overlay.of(context)!,
                        CustomSnackBar.error(
                            message: "El correo ya está siendo utilizado"));
                  });
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 90, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16))),
                child: const Text(
                  "Registrar",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              )
            ],
          ),
        ),
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: isDesktop
            ? Center(child: SizedBox(width: 400, child: registerForm))
            : ListView(children: [registerForm]),
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(50.0),
            bottomRight: Radius.circular(50.0),
          ),
          child: AppBar(
            title: const Text(
              'Registrar Empleado',
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
      drawer: !isDesktop
          ? Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(color: Colors.blue),
                    child: Text('Menú',
                        style: TextStyle(color: Colors.white, fontSize: 24)),
                  ),
                  ListTile(
                    title: const Text('Inicio'),
                    onTap: () {
                      Navigator.of(context).pop();
                      context.goNamed('home');
                    },
                  ),
                  ListTile(
                    title: const Text('Nosotros'),
                    onTap: () {
                      Navigator.of(context).pop();
                      context.goNamed('aboutUs');
                    },
                  ),
                  ListTile(
                    title: const Text('Contáctanos'),
                    onTap: () {
                      Navigator.of(context).pop();
                      context.goNamed('contact');
                    },
                  ),
                ],
              ),
            )
          : null,
    );
  }
}

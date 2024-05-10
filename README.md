# Dpelícula
Descripcion:  
Dpelicula es una aplicación móvil desarrollada con Flutter que permite a los usuarios comprar fácilmente boletos desde un sistema web y tambien para el cine desde sus dispositivos móviles. 

![Logo de Mi Proyecto](https://meterpreter.org/wp-content/uploads/2018/09/flutter.png)

Planificacion:  
Como equipo planeamos desarrollar el programa en el trascurso del semestre, desde la fecha --/--/2024 hasta --/--/2024.

Pages:  
HomePage  
Compra del ticket 
Buscador   
Estadisticas  

Ramas:  
Main  
Persistencia  
Pages  
Diseño  

Funciones:  
Cesar Vera ()  
Christian Mendoza ()  
Ignacio Garcia ()  
Jared Pimentel ()  
Fernanda Mattos ()

Configuración del Proyecto:  

Para utilizar esta aplicación Flutter con una base de datos en Firebase, sigue los pasos a continuación:  

Configurar Firebase  
 
Accede a la consola de Firebase (https://console.firebase.google.com/) y crea un nuevo proyecto.  
Configura tu proyecto para utilizar Firestore como base de datos.  
Configurar Dependencias  

En el archivo pubspec.yaml de tu proyecto Flutter, agrega las dependencias necesarias para Firebase. Ejemplo:  

dependencies:  
  firebase_core: ^2.5.0  
  cloud_firestore: ^3.2.0  
Inicializar Firebase  

En el archivo principal de tu aplicación (generalmente main.dart), inicializa Firebase al inicio de tu aplicación:  
 

import 'package:firebase_core/firebase_core.dart';  

void main() async {  
  WidgetsFlutterBinding.ensureInitialized();  
  await Firebase.initializeApp();  
  runApp(MyApp());  
}  
Acceder a la Base de Datos  

Utiliza el servicio FirebaseFirestore para acceder y manipular datos en Firestore.  

Ejecutar la Aplicación  

Ejecuta tu aplicación Flutter usando el siguiente comando en la terminal:

flutter run
¡Listo! Ahora puedes disfrutar de tu aplicación Flutter conectada a una base de datos en Firebase. Asegúrate de ajustar las configuraciones y nombres de las colecciones según las necesidades específicas de tu proyecto.

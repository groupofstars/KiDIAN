// import 'package:flutter/material.dart';
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';

// class InforDialog extends StatefulWidget {
//   @override
//   _InforDialogState createState() => _InforDialogState();
// }
// class _InforDialogState extends State<InforDialog> {
//   TextEditingController _nameController = TextEditingController();
//   TextEditingController _phoneController = TextEditingController();
//   TextEditingController _addressController = TextEditingController();
//   TextEditingController _favoriteRestaController = TextEditingController();

//   File? _selectedImage;
//   // =File("assets/person.jpg");


//   void _selectImageFromGallery() async {
//     final pickedFile = await ImagePicker().getImage(
//         source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _selectedImage = File(pickedFile.path);
//       });
//     }
//   }

//   void _captureImageFromCamera() async {
//     final pickedFile =
//     await ImagePicker().getImage(source: ImageSource.camera);
//     if (pickedFile != null) {
//       setState(() {
//         _selectedImage = File(pickedFile.path);
//       });
//     }
//   }

//   void _showImageSelectionOptions() {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//           height: 150.0,
//           child: Column(
//             children: [
//               ListTile(
//                 leading: Icon(Icons.photo_library),
//                 title: Text('Gallery'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _selectImageFromGallery();
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.camera_alt),
//                 title: Text('Camera'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _captureImageFromCamera();
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       child: SingleChildScrollView(
//         child: Container(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 'Information',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: 16),
//               GestureDetector(
//                 onTap: _showImageSelectionOptions,
//                 child: CircleAvatar(
//                   radius: 50.0,
//                   backgroundImage:_selectedImage!=null ? FileImage(_selectedImage!):null,
//                   child: _selectedImage == null
//                       ? Container(
//                     decoration: BoxDecoration(
//                       color: Colors.grey[500],
//                       borderRadius: BorderRadius.circular(50.0),
//                     ),
//                     child: Icon(Icons.person, size: 60),
//                   )
//                       : null,
//                 ),
//               ),
//               SizedBox(height: 16),
//               TextField(
//                 controller: _nameController,
//                 decoration: InputDecoration(
//                   labelText: 'Name',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(height: 16),
//               TextField(
//                 controller: _phoneController,
//                 decoration: InputDecoration(
//                   labelText: 'Phone Number',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(height: 16),
//               TextField(
//                 controller: _addressController,
//                 decoration: InputDecoration(
//                   labelText: 'Living Address',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(height: 16),
//               TextField(
//                 controller: _favoriteRestaController,
//                 decoration: InputDecoration(
//                   labelText: 'Restaurant',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(height: 16),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   TextButton(
//                     child: Text('Cancel'),
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                   ),
//                   SizedBox(width: 16),
//                   ElevatedButton(
//                     child: Text('Add'),
//                     onPressed: () {
//                       // Add friend to database
//                       String name = _nameController.text;
//                       String phoneNumber = _phoneController.text;
//                       String address = _addressController.text;
//                       // File? logo = _selectedImage;
//                       // List<Restaurant> selectedRestaurants = [];
//                       // Restaurant nr =Restaurant(
//                       //     name: _favoriteRestaController.text, location: " ");
//                       //selectedRestaurants.add(nr);
//                       // Add friend to database here
//                       print(name);
//                       print(phoneNumber);
//                       print(address);


//                       Navigator.of(context).pop();
//                     },
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
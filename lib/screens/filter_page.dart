// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class FilterPage extends StatefulWidget {
//   const FilterPage({Key? key}) : super(key: key);

//   @override
//   _FilterPageState createState() => _FilterPageState();
// }

// class _FilterPageState extends State<FilterPage> {
//   String? selectedLocation;
//   RangeValues priceRange = const RangeValues(1000, 200000);
//   String? selectedRoomType;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Filter Rooms'),
//         backgroundColor: Colors.teal,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Location',
//               style: TextStyle(
//                 fontSize: 18.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 8.0),
//             DropdownButtonFormField<String>(
//               value: selectedLocation,
//               onChanged: (value) {
//                 setState(() {
//                   selectedLocation = value;
//                 });
//               },
//               items: [
//                 DropdownMenuItem(
//                   value: 'Location 1',
//                   child: Text('Location 1'),
//                 ),
//                 DropdownMenuItem(
//                   value: 'Location 2',
//                   child: Text('Location 2'),
//                 ),
//                 DropdownMenuItem(
//                   value: 'Location 3',
//                   child: Text('Location 3'),
//                 ),
//               ],
//             ),
//             SizedBox(height: 16.0),
//             Text(
//               'Price Range',
//               style: TextStyle(
//                 fontSize: 18.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             RangeSlider(
//               values: priceRange,
//               onChanged: (values) {
//                 setState(() {
//                   priceRange = values;
//                 });
//               },
//               min: 1000,
//               max: 200000,
//               divisions: 100,
//               labels: RangeLabels(
//                 'Ksh ${priceRange.start.round()}',
//                 'Ksh ${priceRange.end.round()}',
//               ),
//             ),
//             SizedBox(height: 16.0),
//             Text(
//               'Room Type',
//               style: TextStyle(
//                 fontSize: 18.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 8.0),
//             DropdownButtonFormField<String>(
//               value: selectedRoomType,
//               onChanged: (value) {
//                 setState(() {
//                   selectedRoomType = value;
//                 });
//               },
//               items: [
//                 DropdownMenuItem(
//                   value: 'Single',
//                   child: Text('Single'),
//                 ),
//                 DropdownMenuItem(
//                   value: 'Double',
//                   child: Text('Double'),
//                 ),
//                 DropdownMenuItem(
//                   value: 'Suite',
//                   child: Text('Suite'),
//                 ),
//               ],
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: () {
//                 applyFilters();
//               },
//               child: Text('Apply Filters'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void applyFilters() {
//     // Query Firestore to filter rooms based on selected filters
//     // You can use 'selectedLocation', 'priceRange', and 'selectedRoomType' to construct the query
//     // Display the filtered rooms in cards or any desired UI
//   }
// }

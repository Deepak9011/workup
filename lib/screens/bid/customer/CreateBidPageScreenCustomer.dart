import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:workup/screens/bid/customer/CustomerBidScreen.dart';
import 'dart:io';
import 'package:workup/utils/colors.dart';
import 'package:workup/widgets/bottom_navigation_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateBidPageScreenCustomer extends StatefulWidget {
  final String customerId;

  const CreateBidPageScreenCustomer({super.key, required this.customerId});

  @override
  _CreateBidPageScreenCustomerState createState() =>
      _CreateBidPageScreenCustomerState();
  // @override
  // _CreateBidPageScreenCustomerState createState() =>
  //     _CreateBidPageScreenCustomerState();
}

class _CreateBidPageScreenCustomerState
    extends State<CreateBidPageScreenCustomer> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _maxAmountController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  String _selectedCategory = 'Gardening';
  String _selectedState = 'Madhya Pradesh';
  String _selectedCountry = 'India';
  DateTime? _serviceDate;
  DateTime? _bidStartDate;
  DateTime? _bidEndDate;
  final Map<String, XFile?> _images = {
    'image1': null,
    'image2': null,
    'image3': null,
    'image4': null,
    'image5': null,
  };

  bool _isLoading = false;

  final List<String> _categories = [
    'Gardening',
    'Plumbing',
    'Electrical',
    'Cleaning',
    'Painting'
  ];

  final List<String> _indianStates = [
    'Madhya Pradesh',
    'Maharashtra',
    'Uttar Pradesh',
    'Rajasthan',
    'Gujarat',
    'Karnataka',
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    _maxAmountController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(String imageKey) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _images[imageKey] = pickedFile;
      });
    }
  }

  Future<void> _selectDate(BuildContext context, bool isServiceDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.primary,
            colorScheme: ColorScheme.light(primary: AppColors.primary),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isServiceDate) {
          _serviceDate = picked;
        } else if (_bidStartDate == null) {
          _bidStartDate = picked;
        } else {
          _bidEndDate = picked;
        }
      });
    }
  }

  Future<void> _submitBid() async {
    if (_formKey.currentState!.validate() &&
        _serviceDate != null &&
        _bidStartDate != null &&
        _bidEndDate != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Prepare the request body
        final Map<String, dynamic> requestBody = {
          "customerId": widget.customerId, // Replace with actual customer ID
          "serviceProviderId": "provider456", // This might be empty initially
          "startBidTime": _bidStartDate!.toIso8601String(),
          "endBidTime": _bidEndDate!.toIso8601String(),
          "serviceTime": _serviceDate!.toIso8601String(),
          "category": _selectedCategory,
          "description": _descriptionController.text,
          "maxAmount": double.parse(_maxAmountController.text),
          "address": _addressController.text,
          "state": _selectedState,
          "country": _selectedCountry,
          "additionalNotes": _notesController.text,
          "image": await _prepareImageData(),
          "bidStatus": "Open",
          "conformCustomerId": null
        };

        // Make the API call
        final response = await http.post(
          Uri.parse('https://workup-bidding-module.onrender.com/bids/create'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(requestBody),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Bid created successfully!'),
              backgroundColor: AppColors.primary,
            ),
          );

          // Navigate to CustomerBidScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    CustomerBidScreen(customerId: widget.customerId)),
          );
        } else {
          throw Exception('Failed to create bid: ${response.body}');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating bid: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all required fields and select dates'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<Map<String, dynamic>> _prepareImageData() async {
    Map<String, dynamic> imageData = {};

    for (var entry in _images.entries) {
      if (entry.value != null) {
        final file = File(entry.value!.path);
        final bytes = await file.readAsBytes();

        imageData[entry.key] = {
          "imageName": entry.value!.name,
          "imageType": entry.value!.mimeType ?? 'image/jpeg',
          "imageData": bytes.length,
          // In a real app, you would upload the image to a storage service
          // and get the URL to include here
          "imageUrl": "https://example.com/placeholder.jpg"
        };
      }
    }

    return imageData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Bid', style: TextStyle(color: AppColors.white)),
        backgroundColor: AppColors.primary,
        iconTheme: IconThemeData(color: AppColors.white),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: AppColors.primary))
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDropdown(
                      label: 'Category',
                      value: _selectedCategory,
                      items: _categories,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCategory = newValue!;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    _buildTextFormField(
                      controller: _descriptionController,
                      label: 'Description',
                      hint: 'Describe the service you need',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                      maxLines: 3,
                    ),
                    SizedBox(height: 16),
                    _buildTextFormField(
                      controller: _maxAmountController,
                      label: 'Maximum Amount (₹)',
                      hint: 'Enter your maximum budget',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an amount';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    _buildTextFormField(
                      controller: _addressController,
                      label: 'Address',
                      hint: 'Enter service location address',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    _buildDropdown(
                      label: 'State',
                      value: _selectedState,
                      items: _indianStates,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedState = newValue!;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    _buildDropdown(
                      label: 'Country',
                      value: _selectedCountry,
                      items: ['India'],
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCountry = newValue!;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    _buildDateField(
                      label: 'Service Date',
                      date: _serviceDate,
                      onTap: () => _selectDate(context, true),
                    ),
                    SizedBox(height: 16),
                    _buildDateField(
                      label: 'Bid Start Date',
                      date: _bidStartDate,
                      onTap: () => _selectDate(context, false),
                    ),
                    SizedBox(height: 16),
                    _buildDateField(
                      label: 'Bid End Date',
                      date: _bidEndDate,
                      onTap: () => _selectDate(context, false),
                    ),
                    SizedBox(height: 16),
                    _buildTextFormField(
                      controller: _notesController,
                      label: 'Additional Notes',
                      hint: 'Any special requirements or notes',
                      maxLines: 2,
                    ),
                    SizedBox(height: 16),
                    Text('Upload Images (Max 5)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkGrey,
                        )),
                    SizedBox(height: 8),
                    Text(
                        'Add photos to help service providers understand your needs better',
                        style: TextStyle(
                            color: AppColors.mediumGrey, fontSize: 12)),
                    SizedBox(height: 12),
                    GridView.count(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      children: _images.entries.map((entry) {
                        return GestureDetector(
                          onTap: () => _pickImage(entry.key),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: entry.value == null
                                ? Center(
                                    child: Icon(Icons.add_a_photo,
                                        color: AppColors.mediumGrey),
                                  )
                                : Stack(
                                    children: [
                                      Image.file(
                                        File(entry.value!.path),
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                                      Positioned(
                                        top: 4,
                                        right: 4,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _images[entry.key] = null;
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: AppColors.primary
                                                  .withOpacity(0.7),
                                              shape: BoxShape.circle,
                                            ),
                                            padding: EdgeInsets.all(4),
                                            child: Icon(Icons.close,
                                                size: 16,
                                                color: AppColors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 24),
                    Center(
                      child: ElevatedButton(
                        onPressed: _submitBid,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          'Create Bid',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGrey,
            )),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonFormField<String>(
            value: value,
            icon: Icon(Icons.arrow_drop_down, color: AppColors.primary),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: AppColors.darkGrey),
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            onChanged: onChanged,
            items: items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    String? hint,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int? maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGrey,
            )),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primary),
            ),
          ),
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGrey,
            )),
        SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date != null
                      ? DateFormat('dd MMM yyyy').format(date)
                      : 'Select date',
                  style: TextStyle(
                    color: date != null
                        ? AppColors.darkGrey
                        : AppColors.mediumGrey,
                  ),
                ),
                Icon(Icons.calendar_today, color: AppColors.primary),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:workup/utils/colors.dart';
// import 'package:workup/widgets/bottom_navigation_bar.dart';

// class CreateBidPageScreenCustomer extends StatefulWidget {
//   @override
//   _CreateBidPageScreenCustomerState createState() =>
//       _CreateBidPageScreenCustomerState();
// }

// class _CreateBidPageScreenCustomerState
//     extends State<CreateBidPageScreenCustomer> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _maxAmountController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//   final TextEditingController _notesController = TextEditingController();

//   String _selectedCategory = 'Gardening';
//   String _selectedState = 'Madhya Pradesh';
//   String _selectedCountry = 'India';
//   DateTime? _serviceDate;
//   DateTime? _bidStartDate;
//   DateTime? _bidEndDate;
//   final Map<String, XFile?> _images = {
//     'image1': null,
//     'image2': null,
//     'image3': null,
//     'image4': null,
//     'image5': null,
//   };

//   final List<String> _categories = [
//     'Gardening',
//     'Plumbing',
//     'Electrical',
//     'Cleaning',
//     'Painting'
//   ];

//   final List<String> _indianStates = [
//     'Madhya Pradesh',
//     'Maharashtra',
//     'Uttar Pradesh',
//     'Rajasthan',
//     'Gujarat',
//     'Karnataka',
//   ];

//   @override
//   void dispose() {
//     _descriptionController.dispose();
//     _maxAmountController.dispose();
//     _addressController.dispose();
//     _notesController.dispose();
//     super.dispose();
//   }

//   Future<void> _pickImage(String imageKey) async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _images[imageKey] = pickedFile;
//       });
//     }
//   }

//   Future<void> _selectDate(BuildContext context, bool isServiceDate) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2101),
//       builder: (BuildContext context, Widget? child) {
//         return Theme(
//           data: ThemeData.light().copyWith(
//             primaryColor: AppColors.primary,
//             colorScheme: ColorScheme.light(primary: AppColors.primary),
//             buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
//           ),
//           child: child!,
//         );
//       },
//     );
//     if (picked != null) {
//       setState(() {
//         if (isServiceDate) {
//           _serviceDate = picked;
//         } else if (_bidStartDate == null) {
//           _bidStartDate = picked;
//         } else {
//           _bidEndDate = picked;
//         }
//       });
//     }
//   }

//   void _submitBid() {
//     if (_formKey.currentState!.validate()) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('New bid created!'),
//           backgroundColor: AppColors.primary,
//         ),
//       );
//       Navigator.pop(context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Create New Bid', style: TextStyle(color: AppColors.white)),
//         backgroundColor: AppColors.primary,
//         iconTheme: IconThemeData(color: AppColors.white),
//       ),
//       bottomNavigationBar: const CustomBottomNavigationBar(),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildDropdown(
//                 label: 'Category',
//                 value: _selectedCategory,
//                 items: _categories,
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _selectedCategory = newValue!;
//                   });
//                 },
//               ),
//               SizedBox(height: 16),
//               _buildTextFormField(
//                 controller: _descriptionController,
//                 label: 'Description',
//                 hint: 'Describe the service you need',
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a description';
//                   }
//                   return null;
//                 },
//                 maxLines: 3,
//               ),
//               SizedBox(height: 16),
//               _buildTextFormField(
//                 controller: _maxAmountController,
//                 label: 'Maximum Amount (₹)',
//                 hint: 'Enter your maximum budget',
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter an amount';
//                   }
//                   if (double.tryParse(value) == null) {
//                     return 'Please enter a valid number';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16),
//               _buildTextFormField(
//                 controller: _addressController,
//                 label: 'Address',
//                 hint: 'Enter service location address',
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter an address';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16),
//               _buildDropdown(
//                 label: 'State',
//                 value: _selectedState,
//                 items: _indianStates,
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _selectedState = newValue!;
//                   });
//                 },
//               ),
//               SizedBox(height: 16),
//               _buildDropdown(
//                 label: 'Country',
//                 value: _selectedCountry,
//                 items: ['India'],
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _selectedCountry = newValue!;
//                   });
//                 },
//               ),
//               SizedBox(height: 16),
//               _buildDateField(
//                 label: 'Service Date',
//                 date: _serviceDate,
//                 onTap: () => _selectDate(context, true),
//               ),
//               SizedBox(height: 16),
//               _buildDateField(
//                 label: 'Bid Start Date',
//                 date: _bidStartDate,
//                 onTap: () => _selectDate(context, false),
//               ),
//               SizedBox(height: 16),
//               _buildDateField(
//                 label: 'Bid End Date',
//                 date: _bidEndDate,
//                 onTap: () => _selectDate(context, false),
//               ),
//               SizedBox(height: 16),
//               _buildTextFormField(
//                 controller: _notesController,
//                 label: 'Additional Notes',
//                 hint: 'Any special requirements or notes',
//                 maxLines: 2,
//               ),
//               SizedBox(height: 16),
//               Text('Upload Images (Max 5)',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.darkGrey,
//                   )),
//               SizedBox(height: 8),
//               Text(
//                   'Add photos to help service providers understand your needs better',
//                   style: TextStyle(color: AppColors.mediumGrey, fontSize: 12)),
//               SizedBox(height: 12),
//               GridView.count(
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 crossAxisCount: 3,
//                 crossAxisSpacing: 8,
//                 mainAxisSpacing: 8,
//                 children: _images.entries.map((entry) {
//                   return GestureDetector(
//                     onTap: () => _pickImage(entry.key),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         border: Border.all(color: AppColors.grey),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: entry.value == null
//                           ? Center(
//                               child: Icon(Icons.add_a_photo,
//                                   color: AppColors.mediumGrey),
//                             )
//                           : Stack(
//                               children: [
//                                 Image.file(
//                                   File(entry.value!.path),
//                                   fit: BoxFit.cover,
//                                   width: double.infinity,
//                                   height: double.infinity,
//                                 ),
//                                 Positioned(
//                                   top: 4,
//                                   right: 4,
//                                   child: GestureDetector(
//                                     onTap: () {
//                                       setState(() {
//                                         _images[entry.key] = null;
//                                       });
//                                     },
//                                     child: Container(
//                                       decoration: BoxDecoration(
//                                         color:
//                                             AppColors.primary.withOpacity(0.7),
//                                         shape: BoxShape.circle,
//                                       ),
//                                       padding: EdgeInsets.all(4),
//                                       child: Icon(Icons.close,
//                                           size: 16, color: AppColors.white),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//               SizedBox(height: 24),
//               Center(
//                 child: ElevatedButton(
//                   onPressed: _submitBid,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primary,
//                     padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                   ),
//                   child: Text(
//                     'Create Bid',
//                     style: TextStyle(
//                       fontSize: 18,
//                       color: AppColors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDropdown({
//     required String label,
//     required String value,
//     required List<String> items,
//     required Function(String?) onChanged,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label,
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: AppColors.darkGrey,
//             )),
//         SizedBox(height: 8),
//         Container(
//           decoration: BoxDecoration(
//             border: Border.all(color: AppColors.grey),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           padding: EdgeInsets.symmetric(horizontal: 12),
//           child: DropdownButtonFormField<String>(
//             value: value,
//             icon: Icon(Icons.arrow_drop_down, color: AppColors.primary),
//             iconSize: 24,
//             elevation: 16,
//             style: TextStyle(color: AppColors.darkGrey),
//             decoration: InputDecoration(
//               border: InputBorder.none,
//             ),
//             onChanged: onChanged,
//             items: items.map<DropdownMenuItem<String>>((String value) {
//               return DropdownMenuItem<String>(
//                 value: value,
//                 child: Text(value),
//               );
//             }).toList(),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildTextFormField({
//     required TextEditingController controller,
//     required String label,
//     String? hint,
//     String? Function(String?)? validator,
//     TextInputType? keyboardType,
//     int? maxLines = 1,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label,
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: AppColors.darkGrey,
//             )),
//         SizedBox(height: 8),
//         TextFormField(
//           controller: controller,
//           decoration: InputDecoration(
//             hintText: hint,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(color: AppColors.grey),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(color: AppColors.primary),
//             ),
//           ),
//           keyboardType: keyboardType,
//           maxLines: maxLines,
//           validator: validator,
//         ),
//       ],
//     );
//   }

//   Widget _buildDateField({
//     required String label,
//     required DateTime? date,
//     required VoidCallback onTap,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label,
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: AppColors.darkGrey,
//             )),
//         SizedBox(height: 8),
//         GestureDetector(
//           onTap: onTap,
//           child: Container(
//             padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
//             decoration: BoxDecoration(
//               border: Border.all(color: AppColors.grey),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   date != null
//                       ? DateFormat('dd MMM yyyy').format(date)
//                       : 'Select date',
//                   style: TextStyle(
//                     color: date != null
//                         ? AppColors.darkGrey
//                         : AppColors.mediumGrey,
//                   ),
//                 ),
//                 Icon(Icons.calendar_today, color: AppColors.primary),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

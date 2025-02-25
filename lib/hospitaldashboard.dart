import 'package:flutter/material.dart';
import 'package:mboacare/chip_widget.dart';
import 'package:mboacare/hospitaldetails.dart';
import 'package:provider/provider.dart';
import 'hospital_model.dart';
import 'hospital_provider.dart';
import 'colors.dart';
import 'dart:developer' as devtools show log;

class HospitalDashboard extends StatefulWidget {
  const HospitalDashboard({super.key});

  @override
  State<HospitalDashboard> createState() => _HospitalDashboardState();
}

class _HospitalDashboardState extends State<HospitalDashboard> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'View All'; // Initialize with 'View All'
  String _selectedDropdownFilter = 'View All'; // Initialize with 'View All'
  late List<HospitalData> filteredHospitals;
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Defined but not referenced
  // Uncomment to use the code below
  // Function to launch the website URL
  // Future<void> _launchURL(String url) async {
  //   devtools.log('Launching URL: $url');

  //   if (url.isNotEmpty &&
  //       (url.startsWith('http://') || url.startsWith('https://'))) {
  //     try {
  //       final Uri uri = Uri.parse(url);
  //       if (await url_launcher.canLaunchUrl(uri)) {
  //         await url_launcher.launchUrl(uri);
  //       } else {
  //         devtools.log('Could not launch $url');
  //       }
  //     } catch (e) {
  //       devtools.log('Error launching URL: $e');
  //     }
  //   } else {
  //     devtools.log('Invalid URL: $url');
  //   }
  // }

  Future<void> _refreshData() async {
    //final hospitalProvider = Provider.of<HospitalProvider>(context);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() {
      //hospitalProvider.getHospitalsStream();
    });
  }

  @override
  Widget build(BuildContext context) {
    final hospitalProvider = Provider.of<HospitalProvider>(context);

    return GestureDetector(
      onTap: () {
        // Unfocus the search field when tapping outside
        _searchFocusNode.unfocus();
      },
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(top: 30.0, left: 16.0, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Connecting',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                              fontFamily:
                                  'Inter', // Replace with the appropriate font family
                            ),
                          ),
                          TextSpan(text: '\n'), // Add a line break here
                          TextSpan(
                            text: 'Hospitals Globally',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                              fontFamily:
                                  'Inter', // Replace with the appropriate font family
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    const Text(
                      'Effortlessly Access a Network of Hospitals Worldwide',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.primaryColor,
                        fontFamily:
                            'Inter', // Replace with the appropriate font family
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  height: 50, // Set the height of the search bar
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode, // Add this line
                    onTap: () {
                      _searchFocusNode.requestFocus(); // Add this line
                    },
                    onChanged: (query) {
                      devtools.log('Search query: $query');
                      hospitalProvider.filterHospitals(query);
                    },
                    decoration: InputDecoration(
                      labelText: 'Search Hospitals',
                      labelStyle:
                          const TextStyle(color: AppColors.primaryColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: AppColors.primaryColor,
                          width: 2.0,
                        ),
                      ),
                      suffixIcon: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.search,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 12.0,
                      ),
                    ),
                  ),
                ),
              ),

              // Filter Tabs
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildFilterTab('View All'),
                      _buildFilterTab('Surgery'),
                      _buildFilterTab('Paediatrics'),
                      _buildFilterTab('Internal Medicine'),
                      _buildFilterTab('Obstetrics & Gynaecology'),
                      _buildFilterTab('Cardiology'),
                      _buildFilterTab('Oncology'),
                      _buildFilterTab('Neurology'),
                    ],
                  ),
                ),
              ),

              // Dropdown Filter
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: DropdownButton<String>(
                  value: _selectedDropdownFilter,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedDropdownFilter = newValue!;
                      _selectedFilter =
                          newValue; // Set the filter tab value based on dropdown selection
                      hospitalProvider.setSelectedFilter(_selectedFilter);
                      Future.delayed(const Duration(milliseconds: 500))
                          .then((_) {
                        hospitalProvider
                            .updateFilteredHospitalsDropdown(filteredHospitals);
                        //hospitalProvider.filterHospitals(_selectedFilter);
                      });
                    });
                  },
                  items: <String>[
                    'View All',
                    'Emergency Room',
                    'Laboratory',
                    'Radiology',
                    'Pharmacy',
                    'Intensive Care Unit',
                    'Operating Room',
                    'Blood Bank',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              Expanded(
                child: StreamBuilder<List<HospitalData>>(
                  stream: hospitalProvider.getHospitalsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      // Apply filtering based on selected filter tab and search query
                      filteredHospitals = hospitalProvider.applyFilters(
                        snapshot.data!,
                        _searchController.text,
                        _selectedFilter,
                      );

                      // Update the _filteredHospitals list with the latest data
                      //hospitalProvider.updateFilteredHospitals(filteredHospitals);

                      return ListView.builder(
                        itemCount: hospitalProvider.filteredHospitals.length,
                        itemBuilder: (context, index) {
                          // var hospital = hospitalProvider.hospitals[index];
                          // devtools.log(hospital.hospitalImageUrl);
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16.0),
                            padding: const EdgeInsets.all(16.0),
                            height: MediaQuery.sizeOf(context).height * .45,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Hospital Image
                                  Container(
                                    height:
                                        MediaQuery.sizeOf(context).height * .15,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(16.0),
                                        topRight: Radius.circular(16.0),
                                      ),
                                      image: hospitalProvider
                                                  .filteredHospitals[index]
                                                  .hospitalImageUrl !=
                                              ''
                                          ? DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  hospitalProvider
                                                      .filteredHospitals[index]
                                                      .hospitalImageUrl),
                                            )
                                          : const DecorationImage(
                                              fit: BoxFit.cover,
                                              image: AssetImage(
                                                  'lib/assests/images/placeholder_image.png'),
                                            ),
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 2,
                                  ),

                                  // Display Hospital Name with Right Arrow Button
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 14.0),
                                        child: Text(
                                          hospitalProvider
                                              .filteredHospitals[index]
                                              .hospitalName
                                              .toUpperCase(),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textColor2,
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          // if (hospitalProvider
                                          //             .filteredHospitals[index]
                                          //             .hospitalWebsite !=
                                          //         null &&
                                          //     hospitalProvider
                                          //         .filteredHospitals[index]
                                          //         .hospitalWebsite!
                                          //         .isNotEmpty) {
                                          //   WidgetsBinding.instance!
                                          //       .addPostFrameCallback((_) {
                                          //     _launchURL(hospitalProvider
                                          //         .filteredHospitals[index]
                                          //         .hospitalWebsite!);
                                          //   });
                                          // }
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      HospitalDetailsPage(
                                                        hospital: hospitalProvider
                                                                .filteredHospitals[
                                                            index],
                                                      )));
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.buttonColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.arrow_forward,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 1),

                                  // Display Hospital Address
                                  Padding(
                                    padding: const EdgeInsets.only(left: 14.0),
                                    child: Text(
                                      hospitalProvider.filteredHospitals[index]
                                          .hospitalAddress,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: AppColors.textColor2,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 1),

                                  // Display Hospital Specialities as Colorful Boxes
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Wrap(
                                      spacing: 5.0,
                                      runSpacing: 5.0,
                                      children: hospitalProvider
                                          .filteredHospitals[index]
                                          .hospitalSpecialities
                                          .split(',')
                                          .map(
                                            (speciality) =>
                                                ChipWidget(speciality),
                                          )
                                          .toList(),
                                    ),
                                  ),

                                  // ... Add any other hospital information here ...
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterTab(String filterOption) {
    final hospitalProvider = Provider.of<HospitalProvider>(context);
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = filterOption;
          hospitalProvider.setSelectedFilter(filterOption);
          Future.delayed(const Duration(milliseconds: 500)).then((_) {
            hospitalProvider.updateFilteredHospitals(filteredHospitals);
          });
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          filterOption,
          style: TextStyle(
            fontSize: 16,
            color: _selectedFilter == filterOption
                ? AppColors.primaryColor
                : Colors.black,
            fontWeight: _selectedFilter == filterOption
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

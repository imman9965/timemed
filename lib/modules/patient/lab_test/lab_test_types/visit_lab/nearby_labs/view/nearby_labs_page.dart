import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';
import 'package:timesmed_project/core/widgets/common_app_bar.dart';
import 'package:timesmed_project/modules/patient/medical_module/records/model/medical_record_model.dart';
import 'package:timesmed_project/routes/app_routes.dart';



class PatientNearbyLabsPage extends StatefulWidget {
  final LabTest labTest;

  const PatientNearbyLabsPage({
    super.key,
    required this.labTest,
  });

  @override
  State<PatientNearbyLabsPage> createState() =>
      _PatientNearbyLabsPageState();
}

class _PatientNearbyLabsPageState
    extends State<PatientNearbyLabsPage> {
  final TextEditingController searchController =
  TextEditingController();

  String selectedLocation = "Anna Nagar, Chennai";

  final List<Map<String, dynamic>> labs = [
    {
      "name": "Apollo Diagnostics",
      "distance": "1.2 km",
      "rating": "4.8",
      "time": "Open • Closes 9 PM",
      "address": "2nd Avenue, Anna Nagar",
      "tests": "250+ Tests Available",
      "price": 650,
    },
    {
      "name": "Medall Healthcare",
      "distance": "2.5 km",
      "rating": "4.6",
      "time": "Open • Closes 10 PM",
      "address": "Shanthi Colony, Anna Nagar",
      "tests": "180+ Tests Available",
      "price": 720,
    },
    {
      "name": "Lal Path Labs",
      "distance": "3.1 km",
      "rating": "4.7",
      "time": "Open • Closes 8 PM",
      "address": "Mogappair East",
      "tests": "320+ Tests Available",
      "price": 590,
    },
    {
      "name": "Vijaya Diagnostics",
      "distance": "4.4 km",
      "rating": "4.5",
      "time": "Open • Closes 9 PM",
      "address": "Kilpauk, Chennai",
      "tests": "200+ Tests Available",
      "price": 810,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final labTest = widget.labTest;

    final filteredLabs = labs.where((lab) {
      final search = searchController.text.toLowerCase();

      return lab["name"].toLowerCase().contains(search) ||
          lab["address"].toLowerCase().contains(search);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      appBar: CommonAppBar(
        title: "Nearby Labs",
      ),

      body: Column(
        children: [
          /// 🔹 TEST HEADER
          Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primary.withOpacity(.82),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.14),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.biotech,
                    color: Colors.white,
                    size: 28,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        labTest.testName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        labTest.category,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        labTest.instructions,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// 🔹 LOCATION + SEARCH
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  blurRadius: 14,
                  color: Colors.black.withOpacity(.04),
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary
                            .withOpacity(.08),
                        borderRadius:
                        BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.location_on,
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Current Location",
                            style: TextStyle(
                              color:
                              Colors.grey.shade600,
                              fontSize: 11,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            selectedLocation,
                            style: const TextStyle(
                              fontWeight:
                              FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),

                    TextButton(
                      onPressed: () {
                        _showLocationBottomSheet();
                      },
                      child: const Text("Change"),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xffF4F7FC),
                    borderRadius:
                    BorderRadius.circular(14),
                  ),
                  child: TextField(
                    controller: searchController,
                    onChanged: (_) {
                      setState(() {});
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search),
                      hintText: "Search labs",
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          /// 🔹 LAB LIST
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              itemCount: filteredLabs.length,
              itemBuilder: (context, index) {
                final lab = filteredLabs[index];

                return GestureDetector(
                  onTap: () {
                    context.push(
                      AppRoutes.patientLabSlotSelection,
                      extra: {
                        "selectedLab": lab,
                        "labTest": widget.labTest,
                      },
                    );
                  },
                  child: Container(
                    margin:
                    const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 12,
                          color:
                          Colors.black.withOpacity(.04),
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        /// ICON
                        Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            color: AppColors.primary
                                .withOpacity(.08),
                            borderRadius:
                            BorderRadius.circular(
                              18,
                            ),
                          ),
                          child: const Icon(
                            Icons.science,
                            color: AppColors.primary,
                            size: 28,
                          ),
                        ),

                        const SizedBox(width: 14),

                        /// DETAILS
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                lab["name"],
                                maxLines: 1,
                                overflow:
                                TextOverflow.ellipsis,
                                style:
                                const TextStyle(
                                  fontSize: 15,
                                  fontWeight:
                                  FontWeight.w700,
                                ),
                              ),

                              const SizedBox(height: 6),

                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 15,
                                    color: Colors
                                        .amber.shade700,
                                  ),

                                  const SizedBox(
                                      width: 4),

                                  Text(
                                    lab["rating"],
                                    style:
                                    const TextStyle(
                                      fontSize: 12,
                                      fontWeight:
                                      FontWeight
                                          .w600,
                                    ),
                                  ),

                                  const SizedBox(
                                      width: 10),

                                  Text(
                                    lab["distance"],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey
                                          .shade600,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 6),

                              Text(
                                lab["address"],
                                maxLines: 1,
                                overflow:
                                TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors
                                      .grey.shade700,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                lab["time"],
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.green
                                      .shade700,
                                  fontWeight:
                                  FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 10),

                        /// BUTTON
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "₹${lab["price"]}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              "Test Price",
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showLocationBottomSheet() {
    final locations = [
      "Anna Nagar, Chennai",
      "Velachery, Chennai",
      "Tambaram, Chennai",
      "T Nagar, Chennai",
      "Porur, Chennai",
      "OMR, Chennai",
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius:
                  BorderRadius.circular(20),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Select Location",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 20),

              ...locations.map(
                    (location) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.location_on,
                    color: AppColors.primary,
                  ),
                  title: Text(location),
                  onTap: () {
                    setState(() {
                      selectedLocation = location;
                    });

                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
import 'package:flutter/material.dart';

class PropertiesTab extends StatefulWidget {
  @override
  _PropertiesTabState createState() => _PropertiesTabState();
}

class _PropertiesTabState extends State<PropertiesTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> verifiedProperties = [];
  List<Map<String, dynamic>> unverifiedProperties = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchProperties(); // This would be where you load your data
  }

  Future<void> _fetchProperties() async {
    // Simulate fetching data
    verifiedProperties = [
      {'propertyTitle': 'Verified Property 1', 'location': 'Location 1', 'price': '1200', 'area': '55', 'bhk': '2 BHK', 'owner': 'Owner A', 'id': '1', 'imageURLs': ['https://via.placeholder.com/150']},
      {'propertyTitle': 'Verified Property 2', 'location': 'Location 2', 'price': '1300', 'area': '60', 'bhk': '3 BHK', 'owner': 'Owner B', 'id': '2', 'imageURLs': ['https://via.placeholder.com/150']},
    ];
    unverifiedProperties = [
      {'propertyTitle': 'Unverified Property 1', 'location': 'Location 3', 'price': '1000', 'area': '40', 'bhk': '1 BHK', 'owner': 'Owner C', 'id': '3', 'imageURLs': ['https://via.placeholder.com/150']},
      {'propertyTitle': 'Unverified Property 2', 'location': 'Location 4', 'price': '900', 'area': '35', 'bhk': '1 BHK', 'owner': 'Owner D', 'id': '4', 'imageURLs': ['https://via.placeholder.com/150']},
    ];
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
      TabBar(
      controller: _tabController,
      tabs: [
        Tab(
          icon: Image.asset(
            'assets/icons/verified.png',
            height: 24, // Adjust icon size as needed
          ),
          text: "Verified",
        ),
        Tab(
          icon: Image.asset(
            'assets/icons/unverified.png',
            height: 24, // Adjust icon size as needed
          ),
          text: "Unverified",
        ),
      ],
      indicatorColor: Color(0xFF192747),  // Custom tab indicator color
      labelColor: Color(0xFF192747),  // Active tab text color
      unselectedLabelColor: Colors.grey,  // Inactive tab text color
      indicatorWeight: 3.0,  // Indicator line thickness
    ),

    Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              VerifiedPropertiesList(verifiedProperties),
              UnverifiedPropertiesList(unverifiedProperties),
            ],
          ),
        ),
      ],
    );
  }
}

class VerifiedPropertiesList extends StatelessWidget {
  final List<Map<String, dynamic>> properties;

  VerifiedPropertiesList(this.properties);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: properties.length,
      itemBuilder: (context, index) {
        return buildPropertyCard(context, properties[index], true, false);
      },
    );
  }
}

class UnverifiedPropertiesList extends StatelessWidget {
  final List<Map<String, dynamic>> properties;

  UnverifiedPropertiesList(this.properties);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: properties.length,
      itemBuilder: (context, index) {
        return buildPropertyCard(context, properties[index], false, false);
      },
    );
  }
}

Widget buildPropertyCard(BuildContext context, Map<String, dynamic> property,
    bool isVerified, bool onTip) {
  double screenWidth = MediaQuery.of(context).size.width;
  double cardWidth = screenWidth < 450 ? screenWidth * 0.9 : screenWidth * 0.9;
  double cardHeight = 180;
  double imageWidth = screenWidth * 0.3;
  double iconSize = 22.0;

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
    child: GestureDetector(
      onTap: () {
        // Handle property card tap
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 3,
        shadowColor: Colors.black,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          height: cardHeight,
          width: cardWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Property image
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
                child: property['imageURLs'] != null
                    ? Image.network(
                  property['imageURLs'][0],
                  fit: BoxFit.cover,
                  height: cardHeight,
                  width: imageWidth,
                )
                    : Image.asset(
                  'assets/icons/wifi.png',
                  fit: BoxFit.cover,
                  height: cardHeight,
                  width: imageWidth,
                ),
              ),
              // Property details
              SizedBox(width: 8),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            property['propertyTitle'] ?? 'No Title',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Icon(
                            isVerified ? Icons.verified : Icons.not_interested,
                            color: isVerified ? Colors.green : Colors.red,
                            size: iconSize,
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      // Location
                      Text(
                        property['location'] ?? 'Unknown Location',
                        style: TextStyle(color: Color(0xff7d7f88), fontSize: 14),
                      ),
                      SizedBox(height: 4),
                      // Icons and details row
                      Row(
                        children: [
                          Icon(Icons.bed,
                              color: Color(0xff7d7f88), size: iconSize),
                          SizedBox(width: 4),
                          Text(
                            '${property['bhk']}',
                            style: TextStyle(color: Color(0xff7d7f88)),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.square_foot,
                              color: Color(0xff7d7f88), size: iconSize),
                          SizedBox(width: 4),
                          Text(
                            '${property['area'] ?? 'Unknown Area'} m²',
                            style: TextStyle(color: Color(0xff7d7f88)),
                          ),
                        ],
                      ),
                      Text(
                        '${property['price']} / month',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Spacer(),
                      Text(
                        isVerified ? 'Verified' : 'Not Verified',
                        style: TextStyle(
                          color: isVerified ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

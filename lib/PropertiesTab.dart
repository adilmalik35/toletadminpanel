import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PropertiesTab extends StatefulWidget {
  @override
  _PropertiesTabState createState() => _PropertiesTabState();
}

class _PropertiesTabState extends State<PropertiesTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> verifiedProperties = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
    _fetchProperties();
  }

  Future<void> _fetchProperties() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('propertiesAll').get();

      print(
          'Fetched ${querySnapshot.docs.length} properties from propertiesAll.');

      setState(() {
        verifiedProperties = querySnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          print('Property data: $data'); // Debugging: Print each property
          return {
            ...data,
            'id': doc.id, // Include document ID for reference
          };
        }).toList();
      });

      print('Verified Properties: ${verifiedProperties.length}');
    } catch (e) {
      print('Error fetching properties: $e');
    }
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
                height: 24,
              ),
              text: "Verified",
            ),
          ],
          indicatorColor: Color(0xFF192747),
          labelColor: Color(0xFF192747),
          unselectedLabelColor: Colors.grey,
          indicatorWeight: 3.0,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              VerifiedPropertiesList(verifiedProperties),
            ],
          ),
        ),
      ],
    );
  }
}

class VerifiedPropertiesList extends StatelessWidget {
  final List<Map<String, dynamic>> properties;

  VerifiedPropertiesList(this.properties) {
    print('Received properties: ${properties.length}'); // Debugging
  }

  @override
  Widget build(BuildContext context) {
    return properties.isEmpty
        ? Center(child: Text("No verified properties available."))
        : ListView.builder(
            itemCount: properties.length,
            itemBuilder: (context, index) {
              return buildPropertyCard(context, properties[index]);
            },
          );
  }
}

Widget buildPropertyCard(BuildContext context, Map<String, dynamic> property) {
  double screenWidth = MediaQuery.of(context).size.width;
  double cardHeight = 180;
  double imageWidth = screenWidth * 0.3;

  // Handle null or missing values gracefully
  String title = property['propertyTitle'] ?? 'No Title';
  String location = property['location'] ?? 'Unknown Location';
  String price = property['price'] ?? 'N/A';
  String owner = property['owner'] ?? 'Unknown';
  String bhk = property['bhk'] ?? 'N/A';
  List<dynamic> imageURLs = property['imageURLs'] ?? [];
  String createdAt = property['createdAt'] != null
      ? (property['createdAt'] as Timestamp).toDate().toLocal().toString()
      : 'Unknown Date';

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 3,
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ),
            child: imageURLs.isNotEmpty
                ? Image.network(
                    imageURLs[0], // Use the first image if available
                    fit: BoxFit.cover,
                    height: cardHeight,
                    width: imageWidth,
                  )
                : Container(
                    height: cardHeight,
                    width: imageWidth,
                    color: Colors.grey[300],
                    child: Icon(Icons.image_not_supported),
                  ),
          ),
          SizedBox(width: 8),
          // Property Details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  // BHK Type
                  Text(
                    bhk,
                    style: TextStyle(fontSize: 14, color: Color(0xff7d7f88)),
                  ),
                  SizedBox(height: 4),
                  // Owner
                  Text(
                    'Owner: $owner',
                    style: TextStyle(fontSize: 14, color: Color(0xff7d7f88)),
                  ),
                  SizedBox(height: 4),
                  // Location
                  Text(
                    location,
                    style: TextStyle(fontSize: 14, color: Color(0xff7d7f88)),
                  ),
                  SizedBox(height: 4),
                  // Price
                  Text(
                    '$price / month',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  // Created At
                  Text(
                    'Added on: $createdAt',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

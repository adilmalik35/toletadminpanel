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
  List<Map<String, dynamic>> unverifiedProperties = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchProperties();
  }

  Future<void> _fetchProperties() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('propertiesAll')
          .get();

      print('Fetched ${querySnapshot.docs.length} documents');

      setState(() {
        verifiedProperties = querySnapshot.docs
            .where((doc) => doc['isVerified'] == true)
            .map((doc) => {
          ...doc.data() as Map<String, dynamic>,
          'id': doc.id,
        })
            .toList();

        unverifiedProperties = querySnapshot.docs
            .where((doc) => doc['isVerified'] == false)
            .map((doc) => {
          ...doc.data() as Map<String, dynamic>,
          'id': doc.id,
        })
            .toList();
      });

      print('Verified: ${verifiedProperties.length}, Unverified: ${unverifiedProperties.length}');
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
            Tab(
              icon: Image.asset(
                'assets/icons/unverified.png',
                height: 24,
              ),
              text: "Unverified",
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
    return properties.isEmpty
        ? Center(child: Text("No verified properties available."))
        : ListView.builder(
      itemCount: properties.length,
      itemBuilder: (context, index) {
        return buildPropertyCard(context, properties[index], true);
      },
    );
  }
}

class UnverifiedPropertiesList extends StatelessWidget {
  final List<Map<String, dynamic>> properties;

  UnverifiedPropertiesList(this.properties);

  @override
  Widget build(BuildContext context) {
    return properties.isEmpty
        ? Center(child: Text("No unverified properties available."))
        : ListView.builder(
      itemCount: properties.length,
      itemBuilder: (context, index) {
        return buildPropertyCard(context, properties[index], false);
      },
    );
  }
}

Widget buildPropertyCard(
    BuildContext context, Map<String, dynamic> property, bool isVerified) {
  double screenWidth = MediaQuery.of(context).size.width;
  double cardHeight = 180;
  double imageWidth = screenWidth * 0.3;

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 3,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ),
            child: property['imageURLs'] != null &&
                property['imageURLs'].isNotEmpty
                ? Image.network(
              property['imageURLs'][0],
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property['propertyTitle'] ?? 'No Title',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    property['location'] ?? 'Unknown Location',
                    style: TextStyle(color: Color(0xff7d7f88), fontSize: 14),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${property['price'] ?? 'N/A'} / month',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Spacer(),
                  Text(
                    isVerified ? 'Verified' : 'Unverified',
                    style: TextStyle(
                      color: isVerified ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
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

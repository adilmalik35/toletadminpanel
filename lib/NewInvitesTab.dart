import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NewInvitesTab extends StatefulWidget {
  @override
  _NewInvitesTabState createState() => _NewInvitesTabState();
}

class _NewInvitesTabState extends State<NewInvitesTab> {
  List<Map<String, dynamic>> newInvites = [];

  @override
  void initState() {
    super.initState();
    _fetchNewInvites(); // Fetch unverified invites
  }

  /// Fetch unverified invites from Firestore
  Future<void> _fetchNewInvites() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('propertiesAll')
          .where('isVerified', isEqualTo: false)
          .get();

      setState(() {
        newInvites = querySnapshot.docs.map((doc) {
          return {
            ...doc.data() as Map<String, dynamic>,
            'id': doc.id, // Include document ID
          };
        }).toList();
      });
    } catch (e) {
      print('Error fetching new invites: $e');
    }
  }

  /// Update Firestore database and remove the item locally
  Future<void> _markAsVerified(String propertyId) async {
    try {
      // Update the Firestore document
      await FirebaseFirestore.instance
          .collection('propertiesAll')
          .doc(propertyId)
          .update({'isVerified': true});

      // Remove the property from the local list
      setState(() {
        newInvites.removeWhere((invite) => invite['id'] == propertyId);
      });

      print('Property with ID $propertyId marked as verified.');
    } catch (e) {
      print('Error verifying property: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Invites'),
      ),
      body: newInvites.isEmpty
          ? Center(
        child: Text(
          "No unverified properties available.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: newInvites.length,
        itemBuilder: (context, index) {
          return buildInviteCard(context, newInvites[index]);
        },
      ),
    );
  }

  /// Build a card for each invite
  Widget buildInviteCard(BuildContext context, Map<String, dynamic> invite) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = screenWidth * 0.9;
    double cardHeight = 180;
    double iconSize = 22.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Property image
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
                child: invite['imageURLs'] != null &&
                    invite['imageURLs'] is List &&
                    invite['imageURLs'].isNotEmpty
                    ? Image.network(
                  invite['imageURLs'][0],
                  fit: BoxFit.cover,
                  width: screenWidth * 0.3,
                )
                    : Container(
                  width: screenWidth * 0.3,
                  color: Colors.grey[300],
                  child: Icon(
                    Icons.image_not_supported,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              // Property details
              SizedBox(width: 8),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        invite['title'] ?? 'No title available',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      // Location
                      Text(
                        invite['location'] ?? 'No location available',
                        style: TextStyle(
                          color: Color(0xff7d7f88),
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 4),
                      // Icons and details row
                      Row(
                        children: [
                          Icon(Icons.bed,
                              size: iconSize, color: Color(0xff7d7f88)),
                          SizedBox(width: 4),
                          Text(invite['bhk'] ?? 'N/A'),
                          SizedBox(width: 8),
                          Icon(Icons.square_foot,
                              size: iconSize, color: Color(0xff7d7f88)),
                          SizedBox(width: 4),
                          Text(invite['area'] ?? 'N/A'),
                        ],
                      ),
                      SizedBox(height: 4),
                      // Price
                      Text(
                        '₹${invite['price'] ?? "0"} / month',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Spacer(),
                      // Verify and Unverify buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              await _markAsVerified(invite['id']);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 12),
                            ),
                            child: Text("Verify"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              print("Unverified invite ID: ${invite['id']}");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 27, vertical: 12),
                            ),
                            child: Text("Unverify"),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

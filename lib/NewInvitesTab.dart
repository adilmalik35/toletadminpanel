import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    _fetchNewInvites(); // Fetch unverified invites for the logged-in user
  }

  /// Fetch unverified invites from Firestore
  Future<void> _fetchNewInvites() async {
    try {
      // Get the current user's ID
      final String userId = FirebaseAuth.instance.currentUser!.uid;

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users') // Main 'Users' collection
          .doc(userId) // Reference to the logged-in user's document
          .collection('properties') // Subcollection under the user
          .where('isVerified', isEqualTo: false) // Query condition
          .get();

      setState(() {
        newInvites = querySnapshot.docs.map((doc) {
          return {
            ...doc.data() as Map<String, dynamic>,
            'id': doc.id, // Include document ID
          };
        }).toList();
      });

      print('Fetched ${newInvites.length} unverified properties.');
    } catch (e) {
      print('Error fetching new invites: $e');
    }
  }

  /// Update Firestore database and remove the item locally
  /// Update Firestore database, add to 'propertiesAll' collection, and remove the item locally
  Future<void> _markAsVerified(String propertyId) async {
    try {
      final String userId = FirebaseAuth.instance.currentUser!.uid;

      // Reference to the user's properties collection
      DocumentReference propertyRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('properties')
          .doc(propertyId);

      // Get the property data
      DocumentSnapshot propertySnapshot = await propertyRef.get();

      if (propertySnapshot.exists) {
        Map<String, dynamic> propertyData =
            propertySnapshot.data() as Map<String, dynamic>;

        // Mark as verified in the user's properties collection
        await propertyRef.update({'isVerified': true});

        // Add the property data to the 'propertiesAll' collection
        await FirebaseFirestore.instance
            .collection('propertiesAll')
            .doc(propertyId)
            .set({
          ...propertyData, // Use the existing property data
          'isVerified': true, // Ensure the isVerified field is true
          'userId': userId, // Include the userId for reference
        });

        // Remove the property from the local list
        setState(() {
          newInvites.removeWhere((invite) => invite['id'] == propertyId);
        });

        print(
            'Property with ID $propertyId added to propertiesAll collection and marked as verified.');
      } else {
        print('Property with ID $propertyId does not exist.');
      }
    } catch (e) {
      print('Error verifying property: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Requests'),
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
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property Title
            Text(
              invite['propertyTitle'].toString().toUpperCase() ?? 'No Title',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),

            // Price
            Text(
              'Price: \INR ${invite['price'] ?? 'N/A'}',
              style: TextStyle(fontSize: 16, color: Colors.green),
            ),
            SizedBox(height: 5),

            // Location
            Text(
              'Location: ${invite['location'] ?? 'No Location'}',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            SizedBox(height: 5),

            // Owner
            Text(
              'Owner: ${invite['owner'].toString().toUpperCase() ?? 'N/A'}',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            SizedBox(height: 5),

            // BHK Type
            Text(
              'BHK Type: ${invite['bhk'] ?? 'N/A'}',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            SizedBox(height: 5),

            // Created At

            SizedBox(height: 10),

            // Facilities
            if (invite['facilities'] != null && invite['facilities'] is List)
              Wrap(
                spacing: 5,
                runSpacing: 5,
                children: (invite['facilities'] as List).map((facility) {
                  return Chip(
                    label: Text(facility),
                    backgroundColor: Colors.blue[100],
                  );
                }).toList(),
              ),
            SizedBox(height: 10),

            // Property Image
            if (invite['imageURLs'] != null && invite['imageURLs'].isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  invite['imageURLs'][0],
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            SizedBox(height: 10),

            // Verify Button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff1b2644),
                ),
                onPressed: () async {
                  await _markAsVerified(invite['id']);
                },
                child: Text(
                  'Verify',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

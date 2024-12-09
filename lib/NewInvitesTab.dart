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
          .collection('Users') // Main 'Users' collection
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
  Future<void> _markAsVerified(String propertyId) async {
    try {
      final String userId = FirebaseAuth.instance.currentUser!.uid;

      // Update the Firestore document
      await FirebaseFirestore.instance
          .collection('Users') // Main 'Users' collection
          .doc(userId) // Reference to the logged-in user's document
          .collection('properties') // Subcollection under the user
          .doc(propertyId) // Reference to the specific property document
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
    return Card(
      child: ListTile(
        title: Text(invite['title'] ?? 'No Title'),
        subtitle: Text(invite['location'] ?? 'No Location'),
        trailing: ElevatedButton(
          onPressed: () async {
            await _markAsVerified(invite['id']);
          },
          child: Text('Verify'),
        ),
      ),
    );
  }
}

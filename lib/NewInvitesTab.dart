import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewInvitesTab extends StatefulWidget {
  @override
  _NewInvitesTabState createState() => _NewInvitesTabState();
}

class _NewInvitesTabState extends State<NewInvitesTab> {
  List<Map<String, dynamic>> newInvites = [];

  @override
  void initState() {
    super.initState();
    _fetchNewInvites(); // Fetch your invites data here
  }

  Future<void> _fetchNewInvites() async {
    // Simulate fetching data
    // Replace this with your actual data fetching logic
    newInvites = [
      {
        'propertyTitle': 'Invite Property 1',
        'location': 'Location 1',
        'price': '1000',
        'area': '50',
        'bhk': '2 BHK',
        'owner': 'Owner X',
        'id': '101',
        'imageURLs': ['https://via.placeholder.com/150']
      },
      {
        'propertyTitle': 'Invite Property 2',
        'location': 'Location 2',
        'price': '1200',
        'area': '60',
        'bhk': '3 BHK',
        'owner': 'Owner Y',
        'id': '102',
        'imageURLs': ['https://via.placeholder.com/150']
      },
    ];
    setState(() {});
  }

  Widget buildInviteCard(BuildContext context, Map<String, dynamic> invite) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = screenWidth < 450 ? screenWidth * 0.9 : screenWidth * 0.9;
    double cardHeight = 180;
    double imageWidth = screenWidth * 0.3;
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Property image
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
                child: invite['imageURLs'] != null
                    ? Image.network(
                  invite['imageURLs'][0],
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
                  padding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        invite['propertyTitle'] ?? 'No Title',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      // Location
                      Text(
                        invite['location'] ?? 'Unknown Location',
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
                              color: Color(0xff7d7f88), size: iconSize),
                          SizedBox(width: 4),
                          Text(
                            '${invite['bhk']}',
                            style: TextStyle(color: Color(0xff7d7f88)),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.square_foot,
                              color: Color(0xff7d7f88), size: iconSize),
                          SizedBox(width: 4),
                          Text(
                            '${invite['area'] ?? 'Unknown Area'} m²',
                            style: TextStyle(color: Color(0xff7d7f88)),
                          ),
                        ],
                      ),
                      Text(
                        '${invite['price']} / month',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Spacer(),
                      // Verify and Unverify buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Centers the buttons and minimizes space between
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Handle verify logic here
                              print("Verified invite ID: ${invite['id']}");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12), // Increase padding
                            ),
                            child: Text("Verify"),
                          ),
                          SizedBox(width: 8), // Space between buttons
                          ElevatedButton(
                            onPressed: () {
                              // Handle unverify logic here
                              print("Unverified invite ID: ${invite['id']}");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 27, vertical: 12), // Increase padding
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

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: newInvites.length,
      itemBuilder: (context, index) {
        return buildInviteCard(context, newInvites[index]);
      },
    );
  }
}

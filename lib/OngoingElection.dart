import 'package:flutter/material.dart';
import 'Home.dart'; // Import the VoteScreen

class OngoingElectionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ongoing Elections'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0), // Add overall padding
          child: Column(
            children: <Widget>[
              // First row of boxes
              GridView.count(
                crossAxisCount: 2, // 2 boxes per row
                shrinkWrap: true, // Allow GridView to scroll inside SingleChildScrollView
                physics: NeverScrollableScrollPhysics(), // Disable scrolling for GridView
                mainAxisSpacing: 20.0, // Spacing between rows
                crossAxisSpacing: 10.0, // Spacing between boxes
                children: [
                  _buildPartyBox(context, 'Election1', Colors.blue),
                  _buildPartyBox(context, 'Election2', Colors.orange),
                  _buildPartyBox(context, 'Election3', Colors.lightGreen),
                  _buildPartyBox(context, 'Election4', Colors.red),
                ],
              ),

              SizedBox(height: 20), // Add spacing between rows

              // Second row of boxes
              GridView.count(
                crossAxisCount: 2, // 2 boxes per row
                shrinkWrap: true, // Allow GridView to scroll inside SingleChildScrollView
                physics: NeverScrollableScrollPhysics(), // Disable scrolling for GridView
                mainAxisSpacing: 20.0, // Spacing between rows
                crossAxisSpacing: 10.0, // Spacing between boxes
                children: [
                  _buildPartyBox(context, 'Election5', Colors.purple),
                  _buildPartyBox(context, 'Election6', Colors.yellow),
                  // Add more boxes if needed
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPartyBox(BuildContext context, String partyName, Color color) {
    return GestureDetector(
      onTap: () {
        // Navigate to the vote.dart screen
      },
      child: Card(
        elevation: 4, // Adjust the elevation as needed
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          height: 160, // Adjust height as needed
          width: 130, // Adjust width as needed
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              partyName,
              textAlign: TextAlign.center, // Center the text
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

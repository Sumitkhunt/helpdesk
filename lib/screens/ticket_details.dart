import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TicketDetailsScreen extends StatelessWidget {
  final String ticketId;
  TicketDetailsScreen({required this.ticketId});

  final TextEditingController commentController = TextEditingController();

  void addComment() async {
    // Add a comment to the Firestore ticket's comments subcollection
    await FirebaseFirestore.instance
        .collection('tickets')
        .doc(ticketId)
        .collection('comments')
        .add({
      'comment': commentController.text,
      'createdDate': Timestamp.now(),
    });
    commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ticket Details",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('tickets')
            .doc(ticketId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.hasError) {
            return Center(child: Text("Error loading ticket details"));
          }

          var ticketData = snapshot.data!;
          var description = ticketData['description'] ?? 'No description';
          var status = ticketData['status'] ?? 'Unknown status';

          return Column(
            children: [
              // Ticket information section in a rounded card
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Ticket ID: $ticketId",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent)),
                        SizedBox(height: 8),
                        Text("Description: $description",
                            style: TextStyle(fontSize: 16)),
                        SizedBox(height: 8),
                        Text("Status: $status", style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),
              ),

              // Comments section
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('tickets')
                      .doc(ticketId)
                      .collection('comments')
                      .orderBy('createdDate', descending: true)
                      .snapshots(),
                  builder: (context, commentsSnapshot) {
                    if (commentsSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (!commentsSnapshot.hasData ||
                        commentsSnapshot.hasError) {
                      return Center(child: Text("Error loading comments"));
                    }

                    var comments = commentsSnapshot.data!.docs;
                    return ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        var comment = comments[index]['comment'];
                        var createdDate =
                            comments[index]['createdDate'].toDate();
                        return Card(
                          margin:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(16),
                            title: Text(comment),
                            subtitle:
                                Text("Posted on: ${createdDate.toLocal()}"),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              // Comment input field with styling
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: commentController,
                  decoration: InputDecoration(
                    labelText: "Add a comment",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  ),
                ),
              ),

              // Submit Comment button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: addComment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Submit Comment",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

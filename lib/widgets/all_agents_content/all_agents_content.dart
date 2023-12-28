import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finkin_admin/widgets/agents_track/agent_track.dart';
import 'package:flutter/material.dart';

class AllAgents extends StatelessWidget {
  const AllAgents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Agents'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Agents').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 60.0,
                    height: 60.0,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.grey,
                      value: 0.5,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Loading',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No Agent found.'),
            );
          }

          List<Agent> agents =
              snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return Agent(data['Name'], data['ImageUrl']);
          }).toList();

          return Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              itemCount: agents.length,
              itemBuilder: (context, index) {
                return AgentGridItem(agent: agents[index]);
              },
            ),
          );
        },
      ),
    );
  }
}

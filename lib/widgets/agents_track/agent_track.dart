import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Agent {
  final String agentName;
  final String agentImage;

  Agent(this.agentName, this.agentImage);
}

class AgentGridItem extends StatelessWidget {
  final Agent agent;

  const AgentGridItem({required this.agent});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 90.0,
          height: 90.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 2.0),
            image: DecorationImage(
              image: NetworkImage(agent.agentImage),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          agent.agentName,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class AllAgents extends StatelessWidget {
  const AllAgents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Agents'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Agents').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator(
              semanticsLabel: 'Loading',
              backgroundColor: Colors.grey,
              value: 0.5,
            );
          }

          List<Agent> agents = snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            String agentName = data['AgentName'];
            String agentImage = data['AgentImage'];
            print('Agent: $agentName, Image: $agentImage');
            return Agent(agentName, agentImage);
          }).toList();

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
            ),
            itemCount: agents.length,
            itemBuilder: (context, index) {
              return AgentGridItem(agent: agents[index]);
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

class Agent {
   String id;
  final String agentname;
  final String agentImage;
  final String email;
  final String phone;
  final String aadhar;
  final String address;
  final String agentType;
  final String pan;
  final bool isAccepted;

  Agent({
    required this.id,
    required this.agentname,
    required this.agentImage,
    required this.email,
    required this.phone,
    required this.aadhar,
    required this.address,
    required this.agentType,
    required this.pan,
    required this.isAccepted,
    
  });
}


class AgentGridItem extends StatelessWidget {
  final Agent agent;
  final String searchQuery;
  final VoidCallback? onPressed;

  const AgentGridItem(
      {super.key,
      required this.agent,
      required this.searchQuery,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPressed, // Execute the onPressed callback on tap
        child: Column(
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
            const SizedBox(height: 8.0),
            Text(
              agent.agentname,
              style:
                  const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }
}

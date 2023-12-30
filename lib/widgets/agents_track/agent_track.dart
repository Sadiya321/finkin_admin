import 'package:flutter/material.dart';

class Agent {
  final String agentname;
  final String agentImage;
  final String email;
  final String phone;

  Agent(this.agentname, this.agentImage, this.email, this.phone);
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

import 'package:finkin_admin/common/utils/screen_color.dart';
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

  const AgentGridItem({
    Key? key,
    required this.agent,
    required this.searchQuery,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isPhone = MediaQuery.of(context).size.width < 600; // Adjust the threshold as needed

    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          //pompom
          Container(
            width: isPhone ? 60.0 : 90.0, // Adjust the size for phone views
            height: isPhone ? 60.0 : 90.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: ScreenColor.combination, width: 2.0),
              image: DecorationImage(
                image: NetworkImage(agent.agentImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            agent.agentname,
            style: TextStyle(
              fontSize: isPhone ? 12.0 : 16.0, // Adjust the font size for phone views
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

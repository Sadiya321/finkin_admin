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
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
         double imageSizePercentage = screenWidth < 600 ? 0.40 : 0.54;
        double fontSizePercentage = screenWidth < 600 ? 0.075 : 0.80;
        //   double imageSizePercentage = screenWidth < 600 ? 0.30 : 0.45;
        // double fontSizePercentage = screenWidth < 600 ? 0.070 : 0.80;

        double imageSize = screenWidth * imageSizePercentage;
        double fontSize = screenWidth * fontSizePercentage;

        return GestureDetector(
          onTap: onPressed,
          child: Column(
            children: [
              Container(
                width: imageSize,
                height: imageSize,
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
                style: TextStyle(fontSize: fontSize),
              ),
            ],
          ),
        );
      },
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finkin_admin/common/utils/screen_color.dart';
import 'package:finkin_admin/widgets/agents_track/agent_track.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/admin_data_controller/adminData_controller.dart';
import '../../controller/auth_controller/auth_controller.dart';

class AllAgents extends StatefulWidget {
  const AllAgents({Key? key}) : super(key: key);

  @override
  State<AllAgents> createState() => _AllAgentsState();
}

class _AllAgentsState extends State<AllAgents> {
  final AuthController authController = Get.put(AuthController());
  final AdminDataController adminDataController =
      Get.put(AdminDataController());
  late List<Agent> allAgents;
  late List<Agent> displayedAgents;
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();
  bool agentsLoaded = false;

  @override
  void initState() {
    super.initState();
    allAgents = [];
    displayedAgents = [];
    _loadAllAgents(); // Load all agents initially
  }

  void _loadAllAgents() async {
    if (!agentsLoaded) {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Agents').get();

      setState(() {
        allAgents = querySnapshot.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          return Agent(
              data['Name'], data['ImageUrl'], data['Email'], data['Phone']);
        }).toList();

        displayedAgents =
            allAgents; // Set displayedAgents to allAgents initially
        agentsLoaded = true;
      });
    }
  }

  void _updateDisplayedAgents(String query) {
    setState(() {
      if (query.isEmpty) {
        // If the query is empty, show all agents
        isSearching = false;
        displayedAgents = allAgents;
      } else {
        // Otherwise, perform the search
        isSearching = true;
        displayedAgents = _performSearch(query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isSearching ? 'Search Results' : 'All Agents'),
        actions: [
          _buildSearchBar(),
          const SizedBox(
            width: 20,
          ),
          FutureBuilder<List<String?>>(
            future:
                adminDataController.getAdminData(authController.adminId.value),
            builder: (context, snapshot) {
              String agentName = snapshot.data?[0] ?? "";
              String? agentImage = snapshot.data?[1];

              return Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Text(agentName),
                  const SizedBox(
                    width: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 20.0,
                      backgroundColor: Colors.grey,
                      backgroundImage: agentImage != null
                          ? NetworkImage(agentImage) as ImageProvider<Object>?
                          : AssetImage('path_to_default_image')
                              as ImageProvider<Object>?,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Agents').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingIndicator();
          } else if (snapshot.hasError) {
            return _buildErrorWidget();
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No Agent found.'),
            );
          }

          _loadAllAgents(); // Ensure agents are loaded

          return _buildAgentGridView();
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      width: 200.0,
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: ScreenColor.subtext,
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  isSearching = value.isNotEmpty;
                  _updateDisplayedAgents(value);
                },
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  List<Agent> _performSearch(String query) {
    return allAgents
        .where((agent) =>
            agent.agentname.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 60.0,
            height: 60.0,
            child: CircularProgressIndicator(
              backgroundColor: ScreenColor.textdivider,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Loading',
            style: TextStyle(color: ScreenColor.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return const Center(
      child: Text('Error loading agents. Please try again.'),
    );
  }

  Widget _buildAgentGridView() {
    if (isSearching && displayedAgents.isEmpty) {
      return const Center(
        child: Text(
          'Search results not found',
          style: TextStyle(fontSize: 23),
        ),
      );
    }
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
      ),
      itemCount: displayedAgents.length,
      itemBuilder: (context, index) {
        return AgentGridItem(
          onPressed: () {
            _showAgentDetailsDialog(context, displayedAgents[index]);
          },
          agent: displayedAgents[index],
          searchQuery: '',
        );
      },
    );
  }

  void _showAgentDetailsDialog(BuildContext context, Agent agent) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40.0,
                backgroundImage: NetworkImage(agent.agentImage),
              ),
              const SizedBox(height: 16.0),
              Text(
                agent.agentname,
                style: const TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(
                agent.email, // Replace with the actual email address
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 8.0),
              Text(
                agent.phone, // Replace with the actual phone number
                style: const TextStyle(fontSize: 16.0),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

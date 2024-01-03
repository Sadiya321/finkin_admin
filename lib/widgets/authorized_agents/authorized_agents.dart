import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finkin_admin/common/utils/screen_color.dart';
import 'package:finkin_admin/controller/admin_data_controller/adminData_controller.dart';
import 'package:finkin_admin/controller/auth_controller/auth_controller.dart';
import 'package:finkin_admin/widgets/agents_track/agent_track.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthorizedAgents extends StatefulWidget {
  const AuthorizedAgents({super.key});

  @override
  State<AuthorizedAgents> createState() => _AuthorizedAgentsState();
}

class _AuthorizedAgentsState extends State<AuthorizedAgents> {
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
        await FirebaseFirestore.instance.collection('Agents').where('IsAccepted', isEqualTo: true).get();

      setState(() {
        allAgents = querySnapshot.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          return Agent(
            id: document.id,
            agentname: data['Name'] ?? '',
            agentImage: data['ImageUrl'] ?? '',
            email: data['Email'] ?? '',
            phone: data['Phone'] ?? '',
            aadhar: data['Aadhar'] ?? '',
            address: data['Address'] ?? '',
            agentType: data['AgentType'] ?? '',
            pan: data['Pan'] ?? '',
            isAccepted: data['IsAccepted'] ?? '',
          );
        }).toList();

        displayedAgents = allAgents;
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
        title: Text(isSearching ? 'Search Results' : 'AuthorizedAgents'),
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
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 20.0,
                      backgroundColor: Colors.grey,
                      backgroundImage: agentImage != null
                          ? NetworkImage(agentImage)
                          : const AssetImage('path_to_default_image')
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
              child: Text('Authorized Agent Not found.',
                  style: TextStyle(fontSize: 23)),
            );
          }

          _loadAllAgents();
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: 40.0,
                  backgroundImage: NetworkImage(agent.agentImage),
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Name: ${agent.agentname}',
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  'Email: ${agent.email}',
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
              const SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  'Phone: ${agent.phone}',
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
              const SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  'Address: ${agent.address}',
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
              const SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  'Aadhar: ${agent.aadhar}',
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
              const SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  'Agent Type: ${agent.agentType}',
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
              const SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  'PAN: ${agent.pan}',
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

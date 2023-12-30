import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finkin_admin/common/utils/screen_color.dart';
import 'package:finkin_admin/widgets/agents_track/agent_track.dart';
import 'package:flutter/material.dart';

class AllAgents extends StatefulWidget {
  const AllAgents({Key? key}) : super(key: key);

  @override
  State<AllAgents> createState() => _AllAgentsState();
}

class _AllAgentsState extends State<AllAgents> {
  late List<Agent> allAgents;
  late List<Agent> displayedAgents;
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    allAgents = [];
    displayedAgents = [];
    _loadAllAgents(); // Load all agents initially
  }

  void _loadAllAgents() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Agents').get();

    setState(() {
      allAgents = querySnapshot.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        return Agent(
            data['Name'], data['ImageUrl'], data['Email'], data['Phone']);
      }).toList();

      displayedAgents = allAgents; // Set displayedAgents to allAgents initially
    });
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
          _buildSearchButton(),
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

          return _buildAgentGridView();
        },
      ),
    );
  }

  Widget _buildSearchButton() {
    return Container(
      width: 250.0,
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: ScreenColor.subtext,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(color: ScreenColor.textLight),
                border: InputBorder.none,
              ),
              style: const TextStyle(color: ScreenColor.textLight),
              onChanged: (value) {
                setState(() {
                  isSearching = value.isNotEmpty;
                });
                _updateDisplayedAgents(value);
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search, color: ScreenColor.textLight),
            onPressed: () {
              setState(() {
                isSearching = true;
              });
            },
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
            // Handle the onPressed functionality here
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

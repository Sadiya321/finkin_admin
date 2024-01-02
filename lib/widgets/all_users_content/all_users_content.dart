import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finkin_admin/common/utils/screen_color.dart';
import 'package:finkin_admin/widgets/user_track/user_track.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/admin_data_controller/adminData_controller.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({Key? key}) : super(key: key);

  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  final AdminDataController adminDataController =
      Get.put(AdminDataController());
  late List<User> allUsers;
  late List<User> displayedUsers;
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    allUsers = [];
    displayedUsers = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isSearching ? 'Search Results' : 'All Users'),
        actions: [
          _buildSearchBar(),
          const SizedBox(
            width: 20,
          ),
          FutureBuilder<List<String?>>(
            future: adminDataController
                .getAdminData('wJkiOkXpwHh3osxsrXyVQ2UIUm33'),
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
        stream: FirebaseFirestore.instance.collection('Loan').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingIndicator();
          } else if (snapshot.hasError) {
            return _buildErrorWidget();
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No User found.'),
            );
          }

          allUsers = snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return User(data['UserName'], data['UserImage'], data['Email'],
                data['Phone']);
          }).toList();

          displayedUsers = isSearching ? _performSearch() : allUsers;

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
                  setState(() {
                    isSearching = value.isNotEmpty;
                  });
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

  List<User> _performSearch() {
    final String query = searchController.text.toLowerCase();
    return allUsers
        .where((user) => user.username.toLowerCase().contains(query))
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
    if (isSearching && displayedUsers.isEmpty) {
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
      itemCount: displayedUsers.length,
      itemBuilder: (context, index) {
        return UserGridItem(
          onPressed: () {
            // Handle the onPressed functionality here
            _showAgentDetailsDialog(context, displayedUsers[index]);
          },
          user: displayedUsers[index],
          searchQuery: '',
        );
      },
    );
  }

  void _showAgentDetailsDialog(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40.0,
                backgroundImage: NetworkImage(user.userImage),
              ),
              const SizedBox(height: 16.0),
              Text(
                user.username,
                style: const TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(
                user.email, // Replace with the actual email address
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 8.0),
              Text(
                user.phone, // Replace with the actual phone number
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

class UserSearchDelegate extends SearchDelegate<String> {
  final List<User> users;

  UserSearchDelegate(this.users);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final List<User> searchResults = users
        .where(
            (user) => user.username.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
      ),
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        return UserGridItem(
          user: searchResults[index],
          searchQuery: '',
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:online_voting_system/upcoming_elections.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:online_voting_system/OngoingElection.dart'; // Import the OngoingElectionsScreen

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Web3Client ethClient;
  final String rpcUrl = 'HTTP://127.0.0.1:7545';
  final EthereumAddress contractAddress =
  EthereumAddress.fromHex('0xdac17f958d2ee523a2206206994597c13d831ec7');
  final String privateKey = 'YOUR_PRIVATE_KEY';

  List<CandidateData> candidates = [];

  @override
  void initState() {
    super.initState();
    ethClient = Web3Client(rpcUrl, http.Client());
    // Fetch data when the screen is initialized
    fetchElectionResults().then((result) {
      setState(() {
        candidates = result;
      });
    });
  }

  @override
  void dispose() {
    ethClient.dispose();
    super.dispose();
  }

  // Function to fetch election results from the smart contract
  Future<List<CandidateData>> fetchElectionResults() async {
    const String abi = '''
    [
      {
        "constant": true,
        "inputs": [],
        "name": "getResults",
        "outputs": [
          {
            "components": [
              {"name": "name", "type": "string"},
              {"name": "voteCount", "type": "uint256"}
            ],
            "name": "",
            "type": "tuple[]"
          }
        ],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
      }
    ]
    ''';

    final credentials = await ethClient.credentialsFromPrivateKey(privateKey);
    final contract = DeployedContract(
      ContractAbi.fromJson(abi, 'VotingSystem'),
      contractAddress,
    );

    final function = contract.function('getResults');
    final result = await ethClient.call(
      contract: contract,
      function: function,
      params: [],
    );

    // Parse the result and create a list of CandidateData
    List<CandidateData> candidates = [];
    for (var candidate in result[0]) {
      candidates.add(
        CandidateData(
          name: candidate[0] as String,
          voteCount: candidate[1] as int,
        ),
      );
    }

    return candidates;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'HOME SCREEN',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(20.0),
        mainAxisSpacing: 20.0,
        crossAxisSpacing: 20.0,
        children: [
          _buildIconButton(Icons.search, 'Search', () {
            // Add your click handler for Search
            print('Search tapped');
          }),
          _buildIconButton(Icons.event, 'Upcoming Elections', () {
            // Navigate to the UpcomingElectionsScreen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => UpcomingElectionsScreen()),
            );
          }),
          _buildIconButton(Icons.how_to_vote, 'Ongoing Elections', () {
            // Navigate to the OngoingElectionsScreen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => OngoingElectionsScreen()),
            );
          }),
          _buildIconButton(Icons.bar_chart, 'Vote Results', () {
            // Add your click handler for Vote Results
            print('Vote Results tapped');
          }),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, String label, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48.0,
              color: Colors.blue,
            ),
            SizedBox(height: 10.0),
            Text(
              label,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CandidateData {
  final String name;
  final int voteCount;

  CandidateData({
    required this.name,
    required this.voteCount,
  });
}

// functions.dart

import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';
import 'package:online_voting_system/constants.dart';

Future<DeployedContract> loadContract() async {
  String abi = await rootBundle.loadString('assets/abi.json');
  String contractAddress = contractAddress1;
  final contract = DeployedContract(ContractAbi.fromJson(abi, 'Election'),
      EthereumAddress.fromHex(contractAddress));
  return contract;
}

Future<String> callFunction(String funcname, List<dynamic> args,
    Web3Client ethClient, String privateKey) async {
  EthPrivateKey credentials = EthPrivateKey.fromHex(privateKey);
  DeployedContract contract = await loadContract();
  final ethFunction = contract.function(funcname);
  final result = await ethClient.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: ethFunction,
        parameters: args,
      ),
      chainId: null,
      fetchChainIdFromNetworkId: true);
  return result;
}

Future<String> startElection(String name, Web3Client ethClient) async {
  var response =
      await callFunction('startElection', [name], ethClient, owner_private_key);
  print('Election started successfully');
  return response;
}

Future<String> addCandidate(String name, String dob, String fatherName, String education, String placeOfBirth, String candidateAddress, String constituency, String partyName, bool hasCriminalRecord, Web3Client ethClient) async {
  var response = await callFunction('addCandidate', [name, dob, fatherName, education, placeOfBirth, candidateAddress, constituency, partyName, hasCriminalRecord], ethClient, owner_private_key);
  print('Candidate added successfully');
  return response;
}

Future<String> authorizeVoter(String address, Web3Client ethClient) async {
  var response = await callFunction('authorizeVoter',
      [EthereumAddress.fromHex(address)], ethClient, owner_private_key);
  print('Voter Authorized successfully');
  return response;
}

Future<List> getCandidatesNum(Web3Client ethClient) async {
  List<dynamic> result = await ask('getNumCandidates', [], ethClient);
  return result;
}

Future<List> getTotalVotes(Web3Client ethClient) async {
  List<dynamic> result = await ask('getTotalVotes', [], ethClient);
  return result;
}

Future<List> candidateInfo(int index, Web3Client ethClient) async {
  List<dynamic> result =
      await ask('candidateInfo', [BigInt.from(index)], ethClient);
  return result;
}

Future<List<dynamic>> ask(
    String funcName, List<dynamic> args, Web3Client ethClient) async {
  final contract = await loadContract();
  final ethFunction = contract.function(funcName);
  final result =
      ethClient.call(contract: contract, function: ethFunction, params: args);
  return result;
}

Future<String> vote(int candidateIndex, Web3Client ethClient) async {
  var response = await callFunction(
      "vote", [BigInt.from(candidateIndex)], ethClient, voter_private_key);
  print("Vote counted successfully");
  return response;
}

Future<List<dynamic>> getCandidates(Web3Client ethClient, String electionName) async {
  try {
    final contract = await loadContract();
    final ethFunction = contract.function('getCandidates');

    final result = await ethClient.call(
      contract: contract,
      function: ethFunction,
      params: [EthereumAddress.fromHex(electionName)],
    );

    return result.cast<String>();
  } catch (e) {
    print('Error fetching candidates: $e');
    return [];
  }
}

Future<List<dynamic>> getElectionInfo(String electionName, Web3Client ethClient) async {
  try {
    final contract = await loadContract();
    final ethFunction = contract.function('getElectionInfo');

    final result = await ethClient.call(
      contract: contract,
      function: ethFunction,
      params: [],
    );

    // Assuming that the function returns a list of dynamic values
    return result.cast<dynamic>();
  } catch (e) {
    print('Error fetching election info: $e');
    return [];
  }
}

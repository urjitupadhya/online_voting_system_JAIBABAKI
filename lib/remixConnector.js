let web3Provider;
let web3;

async function connectRemix() {
  // Connect to Remix
  web3Provider = new RemixWeb3Provider();
  await web3Provider.enable();

  // Set up web3 instance
  web3 = new Web3(web3Provider);
}

async function vote(party, value) {
  // Call your contract function to register the vote using Remix's JavaScript API
  try {
    const accounts = await web3.eth.getAccounts();
    const contract = new web3.eth.Contract(CONTRACT_ABI, CONTRACT_ADDRESS);
    await contract.methods.vote(party, value).send({ from: accounts[0] });
  } catch (error) {
    console.error('Error voting:', error);
  }
}

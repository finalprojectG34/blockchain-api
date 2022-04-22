const Web3 = require('web3');
const Provider = require("@truffle/hdwallet-provider");
// const {RelayProvider} = require('@opengsn/provider');
const {Biconomy} = require("@biconomy/mexa");
// const Moralis = require("moralis/node");

const MyContract = require("../build/contracts/MyContract.json");
// const address = "0xA0bDd912d69a0A27b9AcFeEA52C6ACc105483837";
// const address = "0x02abA14f30a042080dda18E98d708566340A7edF"; //avalanche
const address = "0x96D692De7f2Dd6C9E0fff13e9d6e9F7FB6cEbfcB"; //avalanche
// const paymasterAddress = "0x96D692De7f2Dd6C9E0fff13e9d6e9F7FB6cEbfcB";
// const privateKey = "6f8ee57b4e9d4602169f223d53f0d5322cc48551868baa66eb6e6c6ddda75634";
// const privateKey = "be33a0b8e795abe62dd34d2628b90fa23df82afbb24d63020497dee6319ee31d";
const privateKey = "5e1299da69dc99e541c2eb8f850ce9741993cf566c69d1506dc02bc37d46e3a5"; //avalanche
// const paymasterAddressPrivateKey = "be33a0b8e795abe62dd34d2628b90fa23df82afbb24d63020497dee6319ee31d";

// const infuraUrl = "https://rinkeby.infura.io/v3/4c367eee9f214fc4a7ceb3d2103569f3";
// const moralisUrl2 = "https://speedy-nodes-nyc.moralis.io/0cfd86d7cc7a029dd95f5a57/eth/rinkeby";
// const moralisUrl = "https://speedy-nodes-nyc.moralis.io/0cfd86d7cc7a029dd95f5a57/eth/kovan";
const moralisUrl = "https://speedy-nodes-nyc.moralis.io/0cfd86d7cc7a029dd95f5a57/avalanche/testnet"; //avalanche

// const apiKey = "_55KEiW0v.b4ad0e91-7971-4540-a2d7-465b3b6ee3e8"; //kovan
const apiKey = "EvDyAGHHS.ad1d3f25-6448-4797-9a26-2903caabe83f"; //avalanche

// const config = {
//     paymasterAddress,
// }

const init1 = async () => {
    const providerr = new Provider(privateKey, moralisUrl);

    const biconomy = new Biconomy(providerr, {
        apiKey: apiKey,
        debug: true,
        walletProvider: providerr,
        // privateKey
    });
    const web3 = new Web3(biconomy);

    biconomy.onEvent(biconomy.READY, async () => {
        console.log("initialized")

        const networkId = await web3.eth.net.getId();
        const contractAddress = MyContract.networks[networkId].address
        const myContract = new web3.eth.Contract(
            MyContract.abi,
            contractAddress,
        );

        console.log(`Old Data value: ${await myContract.methods.getMyData().call()}`)
        // const tx = await myContract.methods.setMyData(10);
        // const gas = await tx.estimateGas({from: address});
        // const gasPrice = await web3.eth.getGasPrice();
        // const data = tx.encodeABI();
        // const nonce = await web3.eth.getTransactionCount(address);
        // console.log({gas, gasPrice, data, nonce, contractAddress})

        const receipt = await myContract.methods.setMyData(15).send({
            from: address,
        }).then(va => {
            console.log("Successuuuuuuu -->", va)
        }).catch(reason => {
            console.log("Error Reason ---->")
            console.log(reason)
        })
        // console.log(`Transaction hash: ${receipt.transactionHash}`);
        // const signedTx = await myContract.methods.setMyData(10).send({
        //         from: address,
        //         signatureType: biconomy,
        //         gas,
        //         gasPrice,
        //         data,
        //         nonce,
        //     },
        // );
        // const receipt = await web3.eth.sendSignedTransaction(signedTx.rawTransaction)
        // console.log(`Transaction hash: ${receipt.transactionHash}`);
        // console.log(`New Data value: ${await myContract.methods.getMyData().call()}`)
        // Initialize your dapp here like getting user accounts etc
    }).onEvent(biconomy.ERROR, (error, message) => {
        console.log("error happened here -------->: ", error, message)
    });
}

init1();

// await Moralis.start({
//     serverUrl: "https://fh3jwbndbln2.usemoralis.com:2053/server",
//     appId: "yxYnHZRLUOuIX50yx2myDYdz6m1zQEy7JBkemJBa",
//     masterKey: "Ia8aIBvf5GXHF22",
// });

// const web3Provider = await Moralis.enableWeb3({
//     // chainId: "",
//     // anyNetwork: true,
//     // apiKey: "",
//     // clientId: "0cfd86d7cc7a029dd95f5a57",
//     privateKey: privateKey,
//     // provider: "web3Auth",
// });

// const networkProvider = new Web3.providers.HttpProvider(
//     moralisUrl
// );
// const provider = await RelayProvider.newProvider({ provider: providerr }).init()

// const createTransaction = await web3.eth.accounts.signTransaction({
//         // from: address,
//         to: contractAddress,
//         gas,
//         gasPrice,
//         nonce,
//         data,
//         chainId: networkId
//     },
//     privateKey,
// );
import Provider from "@truffle/hdwallet-provider";
import Web3 from "web3";

import initializeBiconomy from "./biconomy";
import MyContract from "../../build/contracts/MyContract.json"

const moralisUrl = "https://speedy-nodes-nyc.moralis.io/0cfd86d7cc7a029dd95f5a57/avalanche/testnet"; //avalanche

export function makeBiconomy({privateKey}){
    const provider = new Provider(privateKey, moralisUrl);
    return initializeBiconomy({provider})
}

export async function getContract({biconomy}){
    const web3 = new Web3(biconomy);
    const networkId = await web3.eth.net.getId();
    const contractAddress = MyContract.networks[networkId].address;
    return new web3.eth.Contract(
        MyContract.abi,
        contractAddress,
    );
}


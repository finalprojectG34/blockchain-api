import Provider from "@truffle/hdwallet-provider";
import Web3 from "web3";

import initializeBiconomy from "./biconomy";
import getContract from "./contract";

const moralisUrl = "https://speedy-nodes-nyc.moralis.io/0cfd86d7cc7a029dd95f5a57/avalanche/testnet"; //avalanche

export function makeBiconomy({privateKey}) {
    const provider = new Provider(privateKey, moralisUrl);
    return initializeBiconomy({provider})
}

export async function makeContract({biconomy}) {
    const web3 = new Web3(biconomy);
    return new getContract({web3});
}


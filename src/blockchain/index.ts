import Provider from "@truffle/hdwallet-provider";
import Web3 from "web3";
// @ts-ignore
import {Biconomy} from "@biconomy/mexa";

import ContractObject from "../blockchain-contracts/build/contracts/MyContract.json";
import {Contract} from "web3-eth-contract";

const MORALIS_URL_AVALANCHE = "https://speedy-nodes-nyc.moralis.io/0cfd86d7cc7a029dd95f5a57/avalanche/testnet";

const BICONOMY_API_KEY_AVALANCHE = "EvDyAGHHS.ad1d3f25-6448-4797-9a26-2903caabe83f";

async function makeBiconomy(privateKey: string) {
    const provider = new Provider(privateKey, MORALIS_URL_AVALANCHE);
    return new Biconomy(provider, {
        apiKey: BICONOMY_API_KEY_AVALANCHE,
        debug: true,
        walletProvider: provider,
    });
}

async function makeContract(biconomy:any):Promise<Contract> {
    const web3 = new Web3(biconomy);
    const networkId: string = (await web3.eth.net.getId()).toString();
    // @ts-ignore
    const contractAddress: string = ContractObject.networks[networkId].address;
    const cont = new web3.eth.Contract(
        // @ts-ignore
        ContractObject.abi,
        contractAddress,
    );
    return cont.methods
}

export default async function Blockchain (privateKey: string):Promise<Contract> {
    const biconomy = await makeBiconomy(privateKey);

    return new Promise((resolve, reject) => {
        biconomy.onEvent(biconomy.READY, async () => {
            console.log("initialized")
            const contract = await makeContract({biconomy})
            resolve(contract)
        })
        biconomy.onEvent(biconomy.ERROR, (error:any, message: string) => {
            reject(undefined)
            console.log("error happened here -------->: ", error, message)
        })
    });
}
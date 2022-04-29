import Provider from "@truffle/hdwallet-provider";
import Web3 from "web3";
// @ts-ignore
// import {Biconomy} from "@biconomy/mexa";
import ContractObject from "../../blockchain-contracts/build/contracts/MetaCoin.json";
import {Contract} from "web3-eth-contract";
// import {Contract} from "web3-eth-contract";

// const MORALIS_URL_AVALANCHE = "https://speedy-nodes-nyc.moralis.io/0cfd86d7cc7a029dd95f5a57/avalanche/testnet";
// const INFURA_RINKEBY = "https://ropsten.infura.io/v3/4c367eee9f214fc4a7ceb3d2103569f3";

// const BICONOMY_API_KEY_AVALANCHE = "EvDyAGHHS.ad1d3f25-6448-4797-9a26-2903caabe83f";

// async function makeBiconomy(privateKey: string) {
//     const provider = new Provider(privateKey, MORALIS_URL_AVALANCHE);
//     return new Biconomy(provider, {
//         apiKey: BICONOMY_API_KEY_AVALANCHE,
//         debug: true,
//         walletProvider: provider,
//     });
// }
//
// async function makeContract(biconomy: any): Promise<Contract> {
//     const web3 = new Web3(biconomy);
//     const networkId: string = (await web3.eth.net.getId()).toString();
//     // @ts-ignore
//     const contractAddress: string = ContractObject.networks[networkId].address;
//     const cont = new web3.eth.Contract(
//         // @ts-ignore
//         ContractObject.abi,
//         contractAddress,
//     );
//     return cont.methods
// }

export default async function Blockchain(privateKey: string): Promise<Contract> {
    // const biconomy = await makeBiconomy(privateKey);
    const provider = new Provider(privateKey, "http://127.0.0.1:7545");
    // const biconomy = await Biconomy(provider, {
    //     apiKey: BICONOMY_API_KEY_AVALANCHE,
    //     debug: true,
    //     walletProvider: provider,
    // });
    const web3 = new Web3(provider);
    const networkId = await web3.eth.net.getId();
    // @ts-ignore
    const contractAddress: string = ContractObject.networks[networkId].address;
    // @ts-ignore
    return new web3.eth.Contract(ContractObject.abi, contractAddress)
    // return new Promise((resolve, reject) => {
    //     biconomy.onEvent(biconomy.READY, async () => {
    //         console.log("initialized")
    //         // const contract = await makeContract({biconomy})
    //         const web3 = new Web3(biconomy);
    //         const networkId: string = (await web3.eth.net.getId()).toString();
    //         // @ts-ignore
    //         const contractAddress: string = ContractObject.networks[networkId].address;
    //         const contract = new web3.eth.Contract(
    //             // @ts-ignore
    //             ContractObject.abi,
    //             contractAddress,
    //         );
    //         resolve(contract)
    //     })
    //     biconomy.onEvent(biconomy.ERROR, (error:any, message: string) => {
    //         reject(undefined)
    //         console.log("error happened here -------->: ", error, message)
    //     })
    // });
}
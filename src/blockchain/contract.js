import Contract from "../../build/contracts/MyContract.json";

export default async function getContract({web3}) {
    const networkId = await web3.eth.net.getId();
    const contractAddress = Contract.networks[networkId].address;
    return new web3.eth.Contract(
        Contract.abi,
        contractAddress,
    );
}
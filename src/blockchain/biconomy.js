import {Biconomy} from "@biconomy/mexa";

const apiKey = "EvDyAGHHS.ad1d3f25-6448-4797-9a26-2903caabe83f"; //avalanche

export default function initializeBiconomy({provider}) {
    return new Biconomy(provider, {
        apiKey: apiKey,
        debug: true,
        walletProvider: provider,
    });
}

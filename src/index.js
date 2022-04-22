import dotenv from "dotenv";
import express from "express";
import {ApolloServer} from "apollo-server-express";
import schema from "./graphql";
import {getContract, makeBiconomy} from "./blockchain";
import Web3 from "web3";
import MyContract from "../build/contracts/MyContract.json";
// import validateToken from "./middlewares/auth/validate-token";

dotenv.config();
const app = express();

async function startApolloServer() {
    const server = new ApolloServer({
        schema,
        playground: true,
        introspection: true,
        tracing: true,
        path: "/",
        context: ({req}) => {
            return {
                headers: req.headers,
            }
        },
    });

    // app.use(validateToken)

    await server.start();

    server.applyMiddleware({
        app,
        path: "/",
        cors: "no-cors",
    });

    app.listen({port: process.env.PORT}, () => {
        console.log(`🚀 Server listening on port ${process.env.PORT}`);
    });
}

const makeDb = async ({}) => {
    const biconomy = await makeBiconomy({privateKey: "5e1299da69dc99e541c2eb8f850ce9741993cf566c69d1506dc02bc37d46e3a5"})
    const web3 = new Web3(biconomy);
    console.log("sta")
    biconomy.onEvent(biconomy.READY, async () => {
        console.log("initialized")
        const networkId = await web3.eth.net.getId();
        const contractAddress = MyContract.networks[networkId].address;
        const contract = new web3.eth.Contract(
            MyContract.abi,
            contractAddress,
        );
        // const contract = await getContract({biconomy})
        console.log(`Old Data value: ${await contract.methods.getMyData().call()}`)

        // const receipt = await contract.methods.setMyData(15).send({
        //     from: address,
        // }).then(va => {
        //     console.log("Successuuuuuuu -->", va)
        // }).catch(reason => {
        //     console.log("Error Reason ---->")
        //     console.log(reason)
        // })
    }).onEvent(biconomy.ERROR, (error, message) => {
        console.log("error happened here -------->: ", error, message)
    });

    console.log("end")
    // return {biconomy, contract}
}

makeDb({})

// startApolloServer().then(() => {
//     console.log("Apollo server started");
// }).catch((err) => {
//     console.log(`🚀 Server Error: ${err.message}`);
// })
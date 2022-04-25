import express from "express";
import {ApolloServer} from "apollo-server-express";
import schema from "./graphql";
// import validateAddress from "./middlewares/address-validation";
import Blockchain from "./blockchain";
import ProductRepository from "./data-access/product.repository";
import ProductUseCases from "./use-cases/product.user-cases";
import dotenv from "dotenv";
import * as path from "path";

dotenv.config({path: path.resolve(__dirname, '../.env')});

async function startApolloServer() {
    const app = express();

    // app.use(validateAddress)

    const server = new ApolloServer({
        schema,
        introspection: true,
        context: async ({req}) => {
            return {
                address: req.headers.address,
            }
        },
        // @ts-ignore
        dataSources: async ({req}) => {
            console.log("in data source")
            console.log(req)
            const blockchain = await Blockchain(req.headers.privateKey);
            const productRepository = new ProductRepository(blockchain);
            return {
                productUseCases: new ProductUseCases(productRepository),
            };
        }
    });

    await server.start();

    server.applyMiddleware({
        app,
        path: "/",
        // cors: false,
    });

    app.listen({port: 3000}, () => {
        console.log(`🚀 Server listening on port ${process.env.PORT}`);
    });
}

startApolloServer().then(() => {
    console.log("Apollo server started");
}).catch((err) => {
    console.log(`🚀 Server Error: ${err.message}`);
})
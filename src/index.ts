import express from "express";
import {ApolloServer} from "apollo-server-express";
import schema from "./graphql";
import validateAddress from "./middlewares/address-validation";
import cors from 'cors' ;
import Blockchain from "./blockchain";
import ProductRepository from "./services/data-access/product.repository";
import ProductUseCases from "./services/use-cases/product.user-cases";
import {ContextType} from "./graphql/types/type-defs";
import dotenv from "dotenv";
import * as path from "path";

dotenv.config({path: path.resolve(__dirname, '../.env')});

async function startApolloServer() {
    const app = express();
    app.use(cors({
        origin: '*',
        credentials: true
    }))

    app.use(validateAddress)

    const server = new ApolloServer({
        schema,
        introspection: true,
        context: async ({req}):Promise<ContextType> => {
            const blockchain = await Blockchain(req.headers.privateKey as string);
            const productRepository = new ProductRepository(blockchain);
            const productUseCases = new ProductUseCases(productRepository)
            return {
                address: req.headers.address as string,
                productUseCases: productUseCases,
            };
        },
    });

    await server.start();

    server.applyMiddleware({
        app,
        path: "/",
        cors: false
    });

    app.listen({port: process.env.PORT}, () => {
        console.log(`🚀 Server listening on port ${process.env.PORT}`);
    });
}

startApolloServer().then(() => {
    console.log("Apollo server started");
}).catch((err) => {
    console.log(`🚀 Server Error: ${err.message}`);
})
// import productService from "../../../use-cases/product";

import productTC from "../../models/product";
// import ProductUseCases from "../../../use-cases/product.user-cases";
import {Resolver, ResolverResolveParams} from "graphql-compose";

const getAllProducts = {
    name: "getAllProducts",
    type: productTC,
    args: {
        newEmail: "String!",
        userId: "String!"
    },
    resolve: async ():Promise<Resolver|undefined> => {
        try {
            console.log("I am here")
            // console.log({address})
            // await productUseCases.getProductByAddress("address")
            return undefined
        } catch (error) {
            return Promise.reject(error);
        }
    },
};

// const createProduct = {
//     name: "createProduct",
//     type: "String",
//     args: {},
//     resolve: async () => {
//         try {
//             return null
//             // return productService.addProduct({myPro: "hehe"})
//         } catch (error) {
//             return Promise.reject(error);
//         }
//     },
// };

export default [
    // createProduct,
    getAllProducts,
]
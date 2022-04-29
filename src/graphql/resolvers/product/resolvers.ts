import productTC from "../../models/product";
import {ContextType} from "../../types/type-defs";

const getAllProducts = {
    name: "getAllProducts",
    type: productTC,
    args: {
        newEmail: "String!",
        userId: "String!"
    },
    resolve: async ({context: {productUseCases}}: {context: ContextType}) => {
        try {
            console.log("productUseCases")
            console.log(productUseCases.getProductByAddress("address"))
            return undefined
        } catch (error) {
            return Promise.reject(error);
        }
    },
};

const createProduct = {
    name: "createProduct",
    type: "String",
    args: {},
    resolve: () => {
        try {
            return null
            // return productService.addProduct({myPro: "hehe"})
        } catch (error) {
            return Promise.reject(error);
        }
    },
};

export default [
    createProduct,
    getAllProducts,
]
import ProductTC from "../../models/product";

import Resolvers from "./resolvers";

for (const resolver in Resolvers) {
    ProductTC.addResolver(Resolvers[resolver]);
}

const ProductQuery = {
    getAllProducts: ProductTC.getResolver("getAllProducts"),
};

const ProductMutation = {
    // createProduct: ProductTC.getResolver("createProduct"),
};

export {ProductQuery, ProductMutation};
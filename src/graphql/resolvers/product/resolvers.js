import productService from "../../../use-cases/product";

const createProduct = {
    name: "createProduct",
    type: "String",
    args: {
        firstName: "String!"
    },
    resolve: async ({
                        args: {
                            firstName,
                        },
                    }) => {
        try {
            await productService.addProduct({myPro: "hehe"})
        } catch (error) {
            return Promise.reject(error);
        }
    },
};

const getAllProducts = {
    name: "getAllProducts",
    type: "String",
    args: {
        newEmail: "String!",
        userId: "String!"
    },
    resolve: async ({args: {newEmail, userId}}) => {
        try {
            // const user = await userServices.updateUserEmail(
            //     {newEmail, userId}
            // );
            // return {user};
        } catch (error) {
            return Promise.reject(error);
        }
    },
};

export default {
    createProduct,
    getAllProducts,
}
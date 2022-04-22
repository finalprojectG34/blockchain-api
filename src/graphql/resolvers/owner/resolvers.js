// import userServices from "../../../services/user/repository/user-repository";

const createOwner = {
    name: "createOwner",
    type: "String",
    args: {
        firstName: "String!",
        middleName: "String!",
        phoneNumber: "String!",
    },
    resolve: async ({
                        args: {
                            firstName,
                            middleName,
                            phoneNumber
                        },
                    }) => {
        try {

            // const user = await userServices.createOneUser({
            //     firstName,
            //     middleName,
            //     phoneNumber,
            //     password: "",
            //     image: "",
            //     email: "",
            // });
            // return {user}
        } catch (error) {
            return Promise.reject(error);
        }
    },
};

const getAllOwners = {
    name: "getAllOwners",
    type: "String",
    args: {
        newEmail: "String!",
        userId: "String!"
    },
    resolve: async ({args: {newEmail, userId}}) => {
        // try {
        //     const user = await userServices.updateUserEmail(
        //         {newEmail, userId}
        //     );
        //     return {user};
        // } catch (error) {
        //     return Promise.reject(error);
        // }
    },
};

export default {
    createOwner,
    getAllOwners,
}
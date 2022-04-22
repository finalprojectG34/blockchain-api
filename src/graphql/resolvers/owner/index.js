import OwnerTC from "../../models/owner";

import Resolvers from "./resolvers";

for (const resolver in Resolvers) {
    OwnerTC.addResolver(Resolvers[resolver]);
}

const OwnerQuery = {
    getAllOwners: OwnerTC.getResolver("getAllOwners"),
};

const OwnerMutation = {
    createOwner: OwnerTC.getResolver("createOwner"),
};

export {OwnerQuery, OwnerMutation};
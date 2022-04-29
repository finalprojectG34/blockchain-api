import {SchemaComposer} from "graphql-compose";
import {ProductQuery,ProductMutation} from "./resolvers/product";
// import {OwnerQuery, OwnerMutation} from "./resolvers/owner";

const schemaComposer = new SchemaComposer();

schemaComposer.Query.addFields({
    ...ProductQuery,
    // ...OwnerQuery,
});

schemaComposer.Mutation.addFields({
    ...ProductMutation,
    // ...OwnerMutation,
});

const schema = schemaComposer.buildSchema();
export default schema;
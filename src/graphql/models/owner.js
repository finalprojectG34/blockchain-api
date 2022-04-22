import { schemaComposer } from 'graphql-compose';

const OwnerTC = schemaComposer.createObjectTC({
    name: 'Author',
    fields: {
        id: 'Int!',
        firstName: 'String',
        lastName: 'String',
    },
});

export default OwnerTC
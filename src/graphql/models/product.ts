import { schemaComposer } from 'graphql-compose';

const productTC = schemaComposer.createObjectTC({
    name: 'Post',
    fields: {
        id: 'Int!',
        title: 'String',
        votes: 'Int',
        authorId: 'Int',
    },
});

export default productTC
import Address from '../../helpers/address'

export default function makeProductsDb({makeDb}) {
    return Object.freeze({
        findAll,
        findByHash,
        findById,
        insert,
        remove,
        update
    })

    async function findAll({publishedOnly = true} = {}) {
        const db = await makeDb()
        const query = publishedOnly ? {published: true} : {}
        const result = await db.collection('comments').find(query)
        return (await result.toArray()).map(({_id: id, ...found}) => ({
            id,
            ...found
        }))
    }

    async function findById({id: _id}) {
        const db = await makeDb()
        const result = await db.collection('comments').find({_id})
        const found = await result.toArray()
        if (found.length === 0) {
            return null
        }
        const {_id: id, ...info} = found[0]
        return {id, ...info}
    }

    async function insert({id: _id = Id.makeId(), ...commentInfo}) {
        const db = await makeDb()
        const result = await db
            .collection('comments')
            .insertOne({_id, ...commentInfo})
        const {_id: id, ...insertedInfo} = result.ops[0]
        return {id, ...insertedInfo}
    }

    async function update({id: _id, ...commentInfo}) {
        const db = await makeDb()
        const result = await db
            .collection('comments')
            .updateOne({_id}, {$set: {...commentInfo}})
        return result.modifiedCount > 0 ? {id: _id, ...commentInfo} : null
    }

    async function remove({id: _id}) {
        const db = await makeDb()
        const result = await db.collection('comments').deleteOne({_id})
        return result.deletedCount
    }

    async function findByHash(comment) {
        const db = await makeDb()
        const result = await db.collection('comments').find({hash: comment.hash})
        const found = await result.toArray()
        if (found.length === 0) {
            return null
        }
        const {_id: id, ...insertedInfo} = found[0]
        return {id, ...insertedInfo}
    }
}

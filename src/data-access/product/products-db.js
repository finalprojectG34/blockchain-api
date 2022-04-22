export default function makeProductsDb({makeDb}) {
    return Object.freeze({
        findAll,
        // findByHash,
        // findById,
        insert,
        // remove,
        // update
    })

    async function findAll({publishedOnly = true} = {}) {
        // console.log(`Old Data value: ${await contract.methods.getMyData().call()}`)
        // const db = await makeDb()
        // const query = publishedOnly ? {published: true} : {}
        // const result = await db.collection('comments').find(query)
        // return (await result.toArray()).map(({_id: id, ...found}) => ({
        //     id,
        //     ...found
        // }))
    }

    async function insert({address}) {
        await makeDb({privateKey: "Address"}).catch((e)=>console.log(e))

        // biconomy.onEvent(biconomy.READY, async () => {
        //     console.log("initialized")
        //     console.log("eziga", contract)
        //
        //     // const receipt = await contract.methods.setMyData(15).send({
        //     //     from: address,
        //     // }).then(va => {
        //     //     console.log("Successuuuuuuu -->", va)
        //     // }).catch(reason => {
        //     //     console.log("Error Reason ---->")
        //     //     console.log(reason)
        //     // })
        // }).onEvent(biconomy.ERROR, (error, message) => {
        //     console.log("error happened here -------->: ", error, message)
        // });


        console.log("Done!")
        return {}
        // console.log(address)
        // const db = await makeDb()
        // const result = await db
        //     .collection('comments')
        //     .insertOne({_id, ...commentInfo})
        // const {_id: id, ...insertedInfo} = result.ops[0]
        // return {id, ...insertedInfo}
    }

}

export default function makeProductsDb({makeDb}) {
    return Object.freeze({
        findAll,
        // findByHash,
        // findById,
        insert,
        // remove,
        // update
    })

    async function findAll() {
        const res = await makeDb({privateKey: "Address"})

        if (res) {
            return res.getMyData().call()
        } else {
            console.log("Erororrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr")
        }
    }

    async function insert({address}) {
        try {
            const res = await makeDb({privateKey: "Address"})
            console.log(await makeDb({privateKey: "Address"}))
            await res.setMyData(15).send({
                from: "0x96D692De7f2Dd6C9E0fff13e9d6e9F7FB6cEbfcB",
            }).then(va => {
                console.log("Successuuuuuuu -->", va)
            }).catch(reason => {
                console.log("Error Reason ---->")
                console.log(reason)
            })
        } catch (e) {
            console.log("Erororrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr")
        }

        return {}
    }

}

import makeProductsDb from './product/products-db'
import makeOwnersDb from './owner/owner-db'

async function makeDb ({privateKey}) {
    // const biconomy = await makeBiconomy({privateKey})
    //
    // return new Promise((resolve, reject) => {
    //     biconomy.onEvent(biconomy.READY, async () => {
    //         console.log("initialized")
    //         const contract = await makeContract({biconomy})
    //         resolve(contract.methods)
    //     })
    //     biconomy.onEvent(biconomy.ERROR, (error, message) => {
    //         reject("Error")
    //         console.log("error happened here -------->: ", error, message)
    //     })
    // })
}

const productsDb = makeProductsDb({makeDb})
const ownersDb = makeOwnersDb({makeDb})

const dataAccess = Object.freeze({
    productsDb,
    ownersDb,
})

export default dataAccess
export {productsDb, ownersDb}

import makeProductsDb from './product/products-db'
import makeOwnersDb from './owner/owner-db'
import {getContract, makeBiconomy} from "../blockchain";

const address = "0x96D692De7f2Dd6C9E0fff13e9d6e9F7FB6cEbfcB"; //avalanche
const privateKey = "5e1299da69dc99e541c2eb8f850ce9741993cf566c69d1506dc02bc37d46e3a5"; //avalanche

const makeDb = async ({privateKey}) => {
    const biconomy = await makeBiconomy({privateKey: "5e1299da69dc99e541c2eb8f850ce9741993cf566c69d1506dc02bc37d46e3a5"})
    const contract = await getContract({biconomy})
    console.log("sta")
    biconomy.onEvent(biconomy.READY, async () => {
        console.log("initialized")

        console.log(`Old Data value: ${await contract.methods.getMyData().call()}`)

        // const receipt = await contract.methods.setMyData(15).send({
        //     from: address,
        // }).then(va => {
        //     console.log("Successuuuuuuu -->", va)
        // }).catch(reason => {
        //     console.log("Error Reason ---->")
        //     console.log(reason)
        // })
    }).onEvent(biconomy.ERROR, (error, message) => {
        console.log("error happened here -------->: ", error, message)
    });

    console.log("end")
    // return {biconomy, contract}
}

const productsDb = makeProductsDb({makeDb})
const ownersDb = makeOwnersDb({makeDb})

const dataAccess = Object.freeze({
    productsDb,
    ownersDb,
})

export default dataAccess
export {productsDb, ownersDb}

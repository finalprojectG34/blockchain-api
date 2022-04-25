import ProductRepositoryInterface from "../use-cases/product.repository.interface";
import ProductEntity from "../entities/product.entity";
import {Contract} from "web3-eth-contract";

export default class ProductRepository implements ProductRepositoryInterface {
    constructor(private blockchain: Contract) {}

    async getProductByAddress(address: string): Promise<ProductEntity | undefined> {
        // blockchain.getMyData
        console.log("hello there")
        // console.log(this.blockchain.methods)
        // await this.blockchain.methods.getMyData(address).call()
        return undefined
    }

    async createProduct(data: ProductEntity, address: string): Promise<ProductEntity | undefined> {
        // blockchain.addNewData
        try {
            // await this.blockchain.setMyData(data).send({from: address})
            return undefined
        } catch (e) {
            return Promise.reject(e)
        }
        return undefined
    }
}

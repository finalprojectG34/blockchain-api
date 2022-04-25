import ProductEntity from "../entities/product.entity";
import ProductRepositoryInterface from "./product.repository.interface";

export default class ProductUseCases {
    constructor(private productRepository: ProductRepositoryInterface) {
    }

    getProductByAddress(address: string): Promise<ProductEntity | undefined> {
        return this.productRepository.getProductByAddress(address);
    }

    async createProduct(data: ProductEntity, address: string): Promise<ProductEntity | undefined> {
        return await this.productRepository.createProduct(data, address);
    }
}

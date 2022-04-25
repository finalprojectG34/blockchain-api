import ProductEntity from "../entities/product.entity";

export default interface ProductRepositoryInterface {
    getProductByAddress(address: string): Promise<ProductEntity | undefined>;

    createProduct(data: ProductEntity, address: string): Promise<ProductEntity | undefined>;
}
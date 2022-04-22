import makeProduct from '../../entities/product'
export default function makeAddProduct ({ productDb }) {
  return async function addProduct (productInfo) {
    const product = makeProduct(productInfo)

    return productDb.insert({
      address: product.getAddress(),
      description: product.getDescription(),
      price: product.getPrice(),
      owner: product.getOwner(),
      createdOn: product.getCreatedOn(),
      modifiedOn: product.getModifiedOn(),
      deleted: product.isDeleted(),
      published: product.isPublished(),
    })
  }
}

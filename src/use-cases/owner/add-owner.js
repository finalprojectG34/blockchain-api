import makeOwner from '../../entities/product'
export default function makeAddOwner ({ ownerDb }) {
  return async function addOwner (ownerInfo) {
    const owner = makeOwner(ownerInfo)

    return ownerDb.insert({
      address: owner.getAddress(),
      name: owner.getName(),
      role: owner.getRole(),
      createdOn: owner.getCreatedOn(),
      modifiedOn: owner.getModifiedOn(),
      deleted: owner.isDeleted(),
    })
  }
}

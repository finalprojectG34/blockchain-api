export default function buildMakeProduct({Address, sanitize}) {
    return function makeProduct({
                                    address = Address.makeAddress(),
                                    description,
                                    price,
                                    owner,
                                    createdOn = Date.now(),
                                    modifiedOn = Date.now(),
                                    deleted = false,
                                    published = false,
                                } = {}) {
        if (!Address.isValidAddress(address)) {
            throw new Error('Product must have a valid address.')
        }
        if (!Address.isValidAddress(owner)) {
            throw new Error('Product must have a valid owner address.')
        }
        if (!description) {
            throw new Error('Product must have a description.')
        }
        if (description.length < 5) {
            throw new Error("Product's description text must be longer than 5 characters.")
        }
        if (!price) {
            throw new Error('Product must contain a price.')
        }

        description = sanitize(description).trim()
        if (description.length < 1) {
            throw new Error('Description contains no usable text.')
        }

        return Object.freeze({
            getAddress: () => address,
            getOwner: () => owner,
            getDescription: () => description,
            getPrice: () => price,
            getCreatedOn: () => createdOn,
            getModifiedOn: () => modifiedOn,
            isDeleted: () => deleted,
            isPublished: () => published,
            markDeleted: () => {
                deleted = true
            },
            publish: () => {
                published = true
            },
            unPublish: () => {
                published = false
            }
        })
    }
}

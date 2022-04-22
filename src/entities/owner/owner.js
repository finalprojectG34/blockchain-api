export default function buildMakeOwner({Address}) {
    return function makeOwner({
                                  address = Address.makeAddress(),
                                  name,
                                  role,
                                  createdOn = Date.now(),
                                  modifiedOn = Date.now(),
                                  deleted = false,
                              } = {}) {
        if (!Address.isValidAddress(address)) {
            throw new Error('Owner must have a valid address.')
        }
        if (!name) {
            throw new Error('Owner must have a name.')
        }
        if (!role) {
            throw new Error('Owner must contain a role.')
        }

        return Object.freeze({
            getAddress: () => address,
            getCreatedOn: () => createdOn,
            getModifiedOn: () => modifiedOn,
            getName: () => name,
            getRole: () => role,
            isDeleted: () => deleted,
            markDeleted: () => {
                deleted = true
            },
        })
    }
}

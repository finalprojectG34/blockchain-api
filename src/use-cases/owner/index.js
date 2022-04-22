import makeAddOwner from './add-owner'
import ownerDb from '../../data-access/owner'

const addOwner = makeAddOwner({ ownerDb })

const ownerService = Object.freeze({
  addOwner,
})

export default ownerService
export { addOwner}
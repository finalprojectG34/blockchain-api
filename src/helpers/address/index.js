import cuid from 'cuid'

const Address = Object.freeze({
  makeAddress: cuid,
  isValidAddress: cuid.isCuid
})

export default Address

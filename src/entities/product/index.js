import Address from '../../helpers/address'
import buildMakeProduct from "./product";

const makeProduct = buildMakeProduct({Address, sanitize})

function sanitize(text) {
    // TODO: allow more coding embeds
    // TODO: Add input sanitation
    return text.trim()
}

export default makeProduct

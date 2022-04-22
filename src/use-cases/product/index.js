import makeAddProduct from './add-product'
// import makeEditComment from './edit-comment'
// import makeRemoveComment from './remove-comment'
// import makeListComments from './list-comments'
import {productsDb} from '../../data-access'

const addProduct = makeAddProduct({productsDb})
// const editComment = makeEditComment({ commentsDb, handleModeration })
// const listComments = makeListComments({ commentsDb })
// const removeComment = makeRemoveComment({ commentsDb })

const productService = Object.freeze({
    addProduct,
    // editComment,
    // listComments,
    // removeComment
})

export default productService
export {
    addProduct,
    // editComment, listComments, removeComment
}

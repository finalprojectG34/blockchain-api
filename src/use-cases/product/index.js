import makeAddProduct from './add-product'
// import makeEditComment from './edit-comment'
// import makeRemoveComment from './remove-comment'
// import makeListComments from './list-comments'
import productDb from '../../data-access/product'


const addProduct = makeAddProduct({ productDb })
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
export { addProduct,
  // editComment, listComments, removeComment
}

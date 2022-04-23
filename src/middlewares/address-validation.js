const validateAddress = async (req, res, next) => {
    try {
        const unvalidated_address = req.headers.address
        const unvalidated_private_key = req.headers.privateKey

        Object.assign(req.headers, {
            address: null,
            privateKey: null,
        });

        const address = "0x96D692De7f2Dd6C9E0fff13e9d6e9F7FB6cEbfcB"; //avalanche
        const privateKey = "5e1299da69dc99e541c2eb8f850ce9741993cf566c69d1506dc02bc37d46e3a5"; //avalanche

        // if (!authorization) {
        //     return next();
        // }

        Object.assign(req.headers, {
            address,
            privateKey,
        });

        return next();
    } catch (error) {
        return Promise.reject(new Error("Error Happened!"));
    }
};

export default validateAddress;
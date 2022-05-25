const ProductContract = artifacts.require("ProductContract");

contract('ProductContract', async function (accounts) {
    let productContract;
    let productAddress;

    before(async () => {
        productContract = await ProductContract.deployed();
        productAddress = productContract.address;
    });

    it("should set supplyChain contract addresses", async function () {
        let supplyChainAddress = "";
        await productContract.setSupplyChainAddress(supplyChainAddress);

        assert.equal(supplyChainAddress, productContract.supplyChainAddress, "supplyChainAddress not the same");
    });
});

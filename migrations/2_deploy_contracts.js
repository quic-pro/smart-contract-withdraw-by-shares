const Contract = artifacts.require('./WithdrawByShares');


module.exports = function (deployer) {
    deployer.then(async () => {
        await deployer.deploy(Contract, 'name', 'SYMBOL');
    });
};

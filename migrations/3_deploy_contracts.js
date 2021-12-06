var Staking = artifacts.require("./Staking.sol");
var PriceConsumerV3 = artifacts.require("./PriceConsumerV3.sol");
var ERC20Token = artifacts.require("./ERC20Token.sol");


module.exports = async(deployer, _network, accounts) => {

    const TokenFarm = await ERC20Token.deployed();
    deployer.deploy(PriceConsumerV3);
    await deployer.deploy(Staking,TokenFarm.address);
    const staking = await Staking.deployed();
    await TokenFarm.transfer(staking.address, "100000000000000000000000");
    console.log(staking.address);
    
};




var Staking = artifacts.require("./Staking.sol");
var PriceConsumerV3 = artifacts.require("./PriceConsumerV3.sol");
var ERC20Token = artifacts.require("./ERC20Token.sol");


module.exports = async(deployer, _network, accounts) => {
  deployer.deploy(ERC20Token,"10000000");
 
  
};

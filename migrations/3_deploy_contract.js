var ERC20Token = artifacts.require("./ERC20Token.sol");
var Staking = artifacts.require("./Staking.sol");


module.exports = async(deployer, _network, accounts) => {

  const staking = await Staking.deployed();
  deployer.deploy(ERC20Token,"10000000",staking.address);  
};
var ERC20Token = artifacts.require("./ERC20Token.sol");
var Staking = artifacts.require("./Staking.sol");


module.exports = async(deployer, _network, accounts) => {
  deployer.deploy(ERC20Token,"10000000");
  deployer.deploy(Staking);
  const TokenFarm = await ERC20Token.deployed();
  const staking = await Staking.deployed();
  TokenFarm.increaseAllowance(staking.address,"100000000000000000");
  
};
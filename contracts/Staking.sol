// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./PriceConsumerV3.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./TokenReward.sol";


contract Staking {
  // ---- State variables ----
  TokenR public stakingToken;
  using SafeMath for uint256;
  uint256 public tvl = 0; // Total amount raised in ETH
  uint StakedTime=0;
  uint public montantAddReward;
  uint public index=0;
  mapping (address => uint256) public balances;
  mapping (address => uint256) public RewardUnpaid; 
  mapping (address => uint256) public RewartPaid; 
  mapping (address => uint256) public TimeStake; 
    
    
  event Depot(address  _receiver,address  _addressToken, uint256  _value);
  event Whithdraw(address  _receiver,address  _addressToken,  uint256  _value);
  event AmountReward(uint amount);

  constructor() {
    stakingToken = new TokenR();
    stakingToken.faucet(address(this),1000000000000000000000000);
  }

  PriceConsumerV3 private priceConsumerV3 = new PriceConsumerV3();


  function stake(address _tokenAddress, uint256 _tokenValue) public {  
    if(index!=0){
      reward(msg.sender);
      stakingToken.transfer(msg.sender,RewardUnpaid[msg.sender]*1000000000000000000);
    }
    balances[msg.sender] = balances[msg.sender].add(_tokenValue);
    tvl = tvl.add(_tokenValue);   
    TimeStake[msg.sender]=block.timestamp;
    index=index+1;
    RewardUnpaid[msg.sender]=0;
    ERC20(_tokenAddress).transferFrom(msg.sender,address(this),_tokenValue*1000000000000000000);
    emit Depot(msg.sender, _tokenAddress,_tokenValue);
  }

  function withdrawPayments(address _tokenAddress, uint256 _amount) public{
    require(balances[msg.sender] != 0);
    reward(msg.sender);
    stakingToken.transfer(msg.sender,RewardUnpaid[msg.sender]*1000000000000000000);

    tvl = tvl.sub(_amount);
    balances[msg.sender] = balances[msg.sender].sub(_amount);
    
    RewardUnpaid[msg.sender]=0;
    ERC20(_tokenAddress).transfer(msg.sender, _amount*1000000000000000000);
    emit Whithdraw(msg.sender,_tokenAddress ,_amount);
  }

  function ClaimAllReward() public{
    reward(msg.sender);
    stakingToken.transfer(msg.sender,RewardUnpaid[msg.sender]*1000000000000000000);
    
  }

  function reward(address _address)public{
    uint TotalStake=balances[_address];
    StakedTime=block.timestamp-TimeStake[_address];
    RewardUnpaid[_address]=TotalStake*StakedTime/ 100;
    emit AmountReward(RewardUnpaid[msg.sender]);
  }

  function getRewardUnpaid()public view returns(uint){
    return RewardUnpaid[msg.sender];
  }

  function getTime()public view returns(uint){
    return block.timestamp;
  }

  function VoirPrix(address token) public view returns(int) {
    return priceConsumerV3.getLatestPrice(token);
  } 
}

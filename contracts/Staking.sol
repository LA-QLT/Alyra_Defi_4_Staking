// Staking.sol
// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

  import "@openzeppelin/contracts/utils/math/SafeMath.sol";
  import "../contracts/PriceConsumerV3.sol";
  import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
  import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

 

  contract Staking {
    using SafeMath for uint256;

    IERC20 public PureToken;
    
    uint256 public tvl = 0; // Total amount raised in ETH
    uint public currentReward;
    uint currentTime=0;
    uint StakedTime=0;
    mapping (address => uint256) public balances;
    mapping (address => uint256) public TotalReward;  // Balances in incoming Ether
    mapping (address => uint256) public TimeStake; 
    
    
    event Depot(address  _receiver,  uint256  _value);
    event Whithdraw(address  _receiver,  uint256  _value);

    constructor(address _addresseToken) public {
        PureToken = IERC20(_addresseToken);
    }

    PriceConsumerV3 private priceConsumerV3 = new PriceConsumerV3();


    receive() payable external {
      balances[msg.sender] = balances[msg.sender].add(msg.value);
      tvl = tvl.add(msg.value);
      TimeStake[msg.sender]=block.timestamp;
      emit Depot(msg.sender, msg.value);
    }

   // refund investisor
  function withdrawPayments(uint256 _amount) public{
    require(balances[msg.sender] != 0);
    tvl = tvl.sub(_amount);
    balances[msg.sender] = balances[msg.sender].sub(_amount);
    payable(msg.sender).transfer(_amount);
    emit Whithdraw(msg.sender, _amount);
  }

  function reward(address _address)public returns(uint){
    uint TotalStake=balances[_address];
    uint T_Stake=TimeStake[_address];
    currentTime= block.timestamp;
    StakedTime=block.timestamp-TimeStake[_address];
    TotalReward[_address]=TotalStake*StakedTime/ 100000000000000;
    return TotalReward[_address];
  }

  function getTime()public view returns(uint){
    return block.timestamp;
  }
  
  function claimReward(address recipient,uint montant)external{
    TotalReward[msg.sender]=TotalReward[msg.sender]-(montant/100000000000000000000);
    PureToken.transfer(recipient,montant);
    
  }
    // fonction qui permet d'effectuer un transfer de dai vers le recipient
  function VoirPrix(address token) public view returns(int) {
    return priceConsumerV3.getLatestPrice(token);
  }

  
}
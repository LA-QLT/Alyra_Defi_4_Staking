// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
//import "./PriceConsumerV3.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./TokenReward.sol";


contract Staking {


  TokenR public stakingToken;        //TokenReward
  using SafeMath for uint256;
  uint256 public tvl = 0; // Total deposer dans ce Smart Contract
  uint StakedTime=0;
  uint public montantAddReward;
  uint public index=0;
  mapping (address => uint256) public balances;     //address -> balance 
  mapping (address => uint256) public RewardUnpaid; //address -> Montant gagne en TokenReward
  mapping (address => uint256) public TimeStake; //address -> date de la dernier transaction dans ce smart contract
    
  //Evenement 
  event Depot(address  _receiver,address  _addressToken, uint256  _value);
  event Whithdraw(address  _receiver,address  _addressToken,  uint256  _value);
  event AmountReward(uint amount);

  //Contructor Iniatilisation du token de reward ainsi que sa fabrication
  constructor() {
    stakingToken = new TokenR();
    stakingToken.faucet(address(this),1000000000000000000000000);
  }

  //PriceConsumerV3 private priceConsumerV3 = new PriceConsumerV3();

/*********************************************************************************************************
 * @dev Permet a utilisateur de stake un token mais va rendre egalement envoie les rewards deja gagné
 * @param _tokenAddress Adresse du token a Stake
 * @param _tokenValue Valeur qu'on aimerait stake dans ce smart contract pour gagner des rewards
 ***********************************************************************************************************/

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

  /*********************************************************************************************************
 * @dev Permet a l'utilisateur de retirer ses token deposer et retirer ses rewards gagné
 * @param _tokenAddress Adresse du token a Stake
 * @param _tokenValue Valeur qu'on aimerait retirer dans ce smart contract 
 ***********************************************************************************************************/

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
/*********************************************************************************************************
 * @dev Permet a l'utilisateur de retirer tout ses reward
 ***********************************************************************************************************/
  function ClaimAllReward() public{
    reward(msg.sender);
    stakingToken.transfer(msg.sender,RewardUnpaid[msg.sender]*1000000000000000000);
    RewardUnpaid[msg.sender]=0;
  }
/*********************************************************************************************************
 * @dev Permet a l'utilisateur de rafraichir le nombre de token gagner 
 * @param _address Adresse du proprietaire qui a deposer ses token
 ***********************************************************************************************************/
  function reward(address _address)public{
    uint TotalStake=balances[_address];
    StakedTime=block.timestamp-TimeStake[_address];
    RewardUnpaid[_address]=TotalStake*StakedTime/ 100;
    emit AmountReward(RewardUnpaid[msg.sender]);
  }
/*********************************************************************************************************
 * @dev Permet a l'utilisateur de voir combien il a gagne   
 ***********************************************************************************************************/
  function getRewardUnpaid()public view returns(uint){
    return RewardUnpaid[msg.sender];
  }

  function getTime()public view returns(uint){
    return block.timestamp;
  }
/*********************************************************************************************************
 * @dev Permet a l'utilisateur la capactie d'avoir le prix d'un token a grace a CHAINLINK
 * @param token Adresse du token(KOVAN OU RINKEBY OU MAINNET) pour l'utilisation de chainlink 

 ***********************************************************************************************************/
  // function VoirPrix(address token) public view returns(int) {
  //   return priceConsumerV3.getLatestPrice(token);
  // } 
}

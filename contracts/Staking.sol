// Staking.sol
// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

 

contract Staking {

  using SafeMath for uint256;
  uint256 public tvl = 0; // Total amount raised in ETH
  mapping (address => uint256) public balances; // Balances in incoming Ether
  event Depot(address  _receiver,  uint256  _value);
  event Whithdraw(address  _receiver,  uint256  _value);
  
  AggregatorV3Interface internal priceFeed;

    /**
     * Network: Kovan
     * Aggregator: ETH/USD
     * Address: 0x9326BFA02ADD2366b30bacB125260Af641031331
     */
    constructor() {
        priceFeed = AggregatorV3Interface(0x9326BFA02ADD2366b30bacB125260Af641031331);
    }

    /**
     * Returns the latest price
     */
    function getLatestPrice() public view returns (int) {
        (
            uint80 roundID, 
            int price,
            uint startedAt,
            uint timeStamp,
            uint80 answeredInRound
        ) = priceFeed.latestRoundData();
        return price;
    }
   // function to receive ETH
  receive() payable external {
      balances[msg.sender] = balances[msg.sender].add(msg.value);
      tvl = tvl.add(msg.value);
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


}
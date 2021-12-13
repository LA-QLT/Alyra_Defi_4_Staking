// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;
 
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
 
contract ERC20Token is ERC20 {   
    constructor(uint256 _monSupply,address _address) ERC20 ("USDCToken", "USDC"){

            _mint(msg.sender, _monSupply*10**decimals());
            increaseAllowance(_address,10000000000000000000000000000);
    }
}
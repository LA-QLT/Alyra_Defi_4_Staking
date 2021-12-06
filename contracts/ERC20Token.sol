// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;
 
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
 
contract ERC20Token is ERC20 {   
    constructor(uint256 _monSupply) ERC20 ("PURECOIN", "PURE"){

            _mint(msg.sender, _monSupply*10**decimals());
    }
}
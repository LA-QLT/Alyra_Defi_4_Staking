// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;
 
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
 
contract TokenR is ERC20 {   
   constructor()  ERC20("RewardSupra", "SPRE") {
       
   }
   function faucet(address recipient, uint amount) external {
   _mint(recipient, amount);
 }
}
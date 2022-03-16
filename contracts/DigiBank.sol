pragma solidity ^0.8.0;

import './Governor/Token.sol';
import "@openzeppelin/contracts/access/Ownable.sol";

contract DigiBank is Ownable {

DigiToken private digiToken; 
uint256 private value; 

event ValueChanged(uint256 newValue);

function store(uint256 newValue) public onlyOwner{
    value = newValue;
    emit ValueChanged(newValue);
}

function retrieve() public view returns (uint256) {
    return value; 
}

mapping (address => bool) public isStaking;
mapping (address => uint) public stakingBalance;
mapping (address => uint) public stakingStart;

event DepositMade(address indexed _from, uint256 amount, uint256 timeStamp);
event WithdrawlMade(address indexed _from, uint256 interestAmount, uint256 balance, uint256 timeStamp);

constructor(DigiToken _digiToken) public {
    digiToken = _digiToken;
}

function Deposit() public payable{
    
    if(isStaking[msg.sender]=!true) {
    
        require(msg.value >= .1 * (10 ** 18), 'deposit amount must be at least .1ETH');

        stakingBalance[msg.sender] = stakingBalance[msg.sender] + msg.value;
        stakingStart[msg.sender] = stakingStart[msg.sender] + block.timestamp;

        isStaking[msg.sender] = true;
        emit DepositMade(msg.sender, msg.value, block.timestamp);
        }
    }

function Withdraw() public payable{


        require(isStaking[msg.sender] == true, 'only the owner of the account has the authority to withdraw');        

        uint balance = stakingBalance[msg.sender];
        uint currentPeriod = block.timestamp;
        uint stakingPeriod = stakingStart[msg.sender] - currentPeriod;
        uint interestRate = 31668017 * (stakingBalance[msg.sender] / 1e16);
        uint interestAmount = balance * stakingPeriod * interestRate;

        
        msg.sender.transfer(balance);
        digiToken.MintTokens(msg.sender, interestAmount);

        stakingBalance[msg.sender] = 0;    
        stakingStart[msg.sender] = 0;
        isStaking[msg.sender] = false;
            
        emit WithdrawlMade(msg.sender, interestAmount, balance, block.timestamp);
        }
    }



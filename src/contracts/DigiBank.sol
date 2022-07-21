pragma solidity ^0.8.0;

import './Governor/DigiToken.sol';
import "@openzeppelin/contracts/access/Ownable.sol";

contract DigiBank is Ownable {
DigiToken private digiToken; // initialize the state variable of the DigiToken  
uint256 private value; 

event ValueChanged(uint256 newValue);

function store(uint256 newValue) public onlyOwner{
    value = newValue;
    emit ValueChanged(newValue);
} // store function to store the value change after voting ends 

function retrieve() public view returns (uint256) {
    return value; 
} // retrive function that retrives the value 

mapping (address => bool) public isStaking;
mapping (address => uint) public stakingBalance;
mapping (address => uint) public stakingStart;

event DepositMade(address indexed _from, uint256 amount, uint256 timeStamp);
event WithdrawlMade(address indexed _from, uint256 interestAmount, uint256 balance, uint256 timeStamp);

constructor(DigiToken _digiToken) public {
    digiToken = _digiToken;
}

function Deposit() payable public {
    
    require(isStaking[msg.sender] == false); 
    
        require(msg.value>= 1e16, 'deposit amount must be at least .1ETH');

        stakingBalance[msg.sender] = stakingBalance[msg.sender] + msg.value;
        stakingStart[msg.sender] = stakingStart[msg.sender] + block.timestamp;

        isStaking[msg.sender] = true;
        emit DepositMade(msg.sender, msg.value, block.timestamp);
        
    }

function Withdraw() public{


        require(isStaking[msg.sender] == true, 'only the owner of the account has the authority to withdraw');        

        uint balance = stakingBalance[msg.sender];
        uint currentPeriod = block.timestamp;
        uint stakingPeriod = stakingStart[msg.sender] - currentPeriod;
        uint interestRate = 31668017 * (stakingBalance[msg.sender] / 1e16);
        uint interestAmount = balance * stakingPeriod * interestRate;

        
        payable(msg.sender).transfer(balance);
        digiToken.MintTokens(msg.sender, interestAmount);

        stakingBalance[msg.sender] = 0;    
        stakingStart[msg.sender] = 0;
        isStaking[msg.sender] = false;
            
        emit WithdrawlMade(msg.sender, interestAmount, balance, block.timestamp);
        }
    }



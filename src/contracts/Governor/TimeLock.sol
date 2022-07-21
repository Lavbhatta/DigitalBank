pragma solidity ^0.8.0;


import "@openzeppelin/contracts/governance/extensions/GovernorTimelockControl.sol";

contract TimeLock is TimelockController { // mindelay will wait for certain amount of time after the voting period is over. Proper
// proposers allow you to directly execute actions or schedule delayed execution of functions through the TimeLockController contract
// executor: an address (smart contract or an enterally owned contract ) that is incharge of executing operations once the timelock has expired

    
    constructor(
        
        uint256 minDelay,
        address [] memory proposers, 
        address [] memory executors

)

    TimelockController(minDelay, proposers, executors) {}

}
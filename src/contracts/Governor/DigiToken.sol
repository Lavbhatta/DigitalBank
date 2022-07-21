pragma solidity ^0.8.0;

import  "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DigiToken is ERC20, ERC20Permit, ERC20Votes, Ownable {

address public minter; 

event MinterChanged(address indexed from, address indexed to);
event TokenMinted(address indexed _from, uint256 _amount);

    constructor() public ERC20("DigitalToken", "DGT") ERC20Permit('DigitalToken')  { // here we are initilaizing the digitoken, erc20Permit, and creating the supply for digitalToken 
        minter = msg.sender;
        _mint(msg.sender, 1000000 * (10 ** uint256(decimals())));
    }

    function _afterTokenTransfer(address from, address to, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._afterTokenTransfer(from, to, amount);
    }

    function _mint(address to, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._mint(to, amount);
    }

    function _burn(address account, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._burn(account, amount);
    }

    function PassMinterRole (address DigiBank) public returns (bool) { // Pass the minter role to the digital bank, so only the bank 
 
        require(msg.sender==minter, 'only the owner can pass minter role');
        minter = DigiBank; 
    
        emit MinterChanged(msg.sender, DigiBank);
        return true;
    }

    function MintTokens(address account, uint256 amount) public {   // creating the mint token funciton, that will used externally in DigiBnak.sol 
    require(msg.sender==minter, "error, msg.sender does not have the minter role");
    
    _mint(account, amount);

    emit TokenMinted(msg.sender, amount);
}

}


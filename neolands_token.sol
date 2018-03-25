pragma solidity ^0.4.18;

import "github.com/OpenZeppelin/zeppelin-solidity/contracts/token/ERC20/StandardToken.sol";

contract NeolandsToken is StandardToken {
    
    string public constant name    = "Neolands Token";
    string public constant symbol  = "XNL";
    uint8 public constant decimals = 0;
    
    uint256 public constant INITIAL_SUPPLY = 100000000;
    
    function NeolandsToken() public {
        totalSupply_         = INITIAL_SUPPLY;
        balances[msg.sender] = INITIAL_SUPPLY;
        
        emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
    }
}

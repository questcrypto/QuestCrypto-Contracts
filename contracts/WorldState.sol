pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/AccessControl.sol";

contract WorldState is AccessControl{
    
    mapping(address=>string) rootHashes;
    
    bytes32 public constant TREASURY_ROLE = keccak256("TREASURY_ROLE");
    constructor(
        address treasury
        ){
        _setupRole(TREASURY_ROLE, treasury);
    }
    

    function updateURI(string calldata _baseURI, address propertyTokenAddress) public{
        require(hasRole(TREASURY_ROLE, _msgSender()), "Cannot access");
        rootHashes[propertyTokenAddress] = _baseURI;
    }
    
    
    function getRootHash(address  propertyTokenAddress) public view returns(string memory){
        require(hasRole(TREASURY_ROLE, _msgSender()), "Cannot access");
        return rootHashes[propertyTokenAddress];
    }
}
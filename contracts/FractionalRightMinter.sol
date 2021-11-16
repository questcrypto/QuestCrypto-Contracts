// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./MintableFractionalRight.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";

contract FractionalRightMinter{
    struct FractionalRight{
        address targetPropertyContract;
        uint256 targetRightId;
    }
    mapping(address=>FractionalRight) fractionalRightDetails;
    event Fractionalised(
        address targetPropertyContract,
        uint256 targetRightId,
        string  name,
        string  symbol,
        string  rightURI,
        address fractionalTokenAddress
            );
    function fractionaliseRight(
        address targetPropertyContract,
        uint256 targetRightId,
        string calldata name,
        string calldata symbol,
        string calldata rightURI
            ) public{
        IERC1155(targetPropertyContract).safeTransferFrom(msg.sender,address(this),targetRightId,1,"");
        MintableFractionalRight _tokenAddress = new MintableFractionalRight(name,symbol,rightURI); //?? will right URI be part of the fractional Token
        emit Fractionalised(targetPropertyContract, targetRightId, name, symbol, rightURI, address(_tokenAddress));
        fractionalRightDetails[address(_tokenAddress)] =  FractionalRight(targetPropertyContract,targetRightId);
    }
}
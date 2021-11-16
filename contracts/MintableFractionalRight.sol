// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MintableFractionalRight is ERC20, Ownable {
    string rightURI;
    constructor(
        string memory name,
        string memory symbol,
        string memory _rightURI
    ) ERC20(name,symbol) {
        rightURI = _rightURI;
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}
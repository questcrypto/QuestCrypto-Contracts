// contracts/GameItems.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract QuestCryptoAsset is ERC1155, Ownable {
    string bURI;
    uint256 public constant RIGHT_TO_EQUITY = 0;
    uint256 public constant RIGHT_TO_MANAGEMENT = 1;
    uint256 public constant RIGHT_TO_RENT = 2;
    uint256 public constant SUBSURFACE_RIGHTS = 3;
    uint256 public constant RIGHT_TO_CARBON_CREDITS = 4;
    uint256 public constant FRACTIONAL_EQUITY_RIGHT = 5;
    uint256 public constant FRACTIONAL_RENT_RIGHT = 6;
    uint256 public constant FRACTIONAL_SUBSURFACE_RIGHTS = 7;
    uint256 public constant FRACTIONAL_CARBON_CREDITS = 8;
    uint256 public MAX_FRACTIONAL_EQUITY_RIGHT;
    uint256 public MAX_FRACTIONAL_RENT_RIGHT;
    uint256 public MAX_FRACTIONAL_SUBSURFACE_RIGHTS;
    uint256 public MAX_FRACTIONAL_CARBON_CREDITS;
    //property Token Price
    uint256 public QUEST_TOKEN_PRICE = 10**14; //(0.0001 MATIC)
    uint256 public RENT_TOKEN_PRICE = 2 * 10**13; //(0.00002 MATIC)
    uint256 public SUBSURFACE_TOKEN_PRICE = 2 * 10**13; //(0.00002 MATIC)
    uint16 [] ordering;
    bool public approvalStatus;
    modifier isLessThanMaxSupply(uint256 _id,uint256 _price,uint256 _limit){
        require(balanceOf(msg.sender,_id) + msg.value/_price < _limit);
        _;
    }
    // modifier isAvailable(){
    //     //Checks if certain right is available
    // }
    // modifier followsOrder(){
    //     require();
    //     _;
    // }
    constructor(
        string memory _baseURI,
        address _managingCompany
        )  ERC1155("") {
        bURI = _baseURI;
        _mint(_managingCompany, RIGHT_TO_EQUITY, 1, "");
        _mint(_managingCompany, RIGHT_TO_MANAGEMENT, 1, "");
        _mint(_managingCompany, RIGHT_TO_RENT, 1, "");
        _mint(_managingCompany, SUBSURFACE_RIGHTS, 1, "");
        _mint(_managingCompany, RIGHT_TO_CARBON_CREDITS, 1, "");
        approvalStatus = false;
    }
    // function updatePrice(){
        
    // }
    function approveProperty() public onlyOwner{
        approvalStatus = true;
    }
    function updateRightOrder(
        uint16 [] calldata _rightOrder
        ) public onlyOwner{
        ordering = _rightOrder;
    }
    function buyEquityRightFraction()public payable {
        _mint(msg.sender,FRACTIONAL_EQUITY_RIGHT,msg.value/QUEST_TOKEN_PRICE,"");
    }
    function buyRentRight()public payable {
        _mint(msg.sender,FRACTIONAL_RENT_RIGHT,msg.value/RENT_TOKEN_PRICE,"");
    }
    function buySubsurfaceTokens()public payable {
        _mint(msg.sender,FRACTIONAL_SUBSURFACE_RIGHTS,msg.value/SUBSURFACE_TOKEN_PRICE,"");
    }
    function baseURI() public view returns(string memory) {
        return bURI;
    }
    
}
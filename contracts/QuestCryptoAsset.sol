// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract QuestCryptoAsset is ERC1155, Ownable, AccessControl {
    string bURI;
    uint256 [] public absoluteRightIDs;
    uint256 [] public fractionalRightIDs;
    mapping(uint256=>string) rights;
    bytes32 public constant HOA_ADMIN_ROLE = keccak256("HOA_ADMIN_ROLE");
    bytes32 public constant TREASURY_ADMIN_ROLE = keccak256("TREASURY_ADMIN_ROLE");
    uint256 public constant RIGHT_TO_EQUITY = 0;
    uint256 public constant RIGHT_TO_MANAGEMENT = 1;
    uint256 public constant RIGHT_TO_RESIDENCY = 2;
    uint256 public constant RIGHT_TO_CONTROL= 3;
    uint256 public constant SUBSURFACE_RIGHTS = 4;
    
    uint256 public constant FRACTIONAL_EQUITY_RIGHT = 5;
    uint256 public constant FRACTIONAL_RENT_RIGHT = 6;
    uint256 public constant FRACTIONAL_SUBSURFACE_RIGHTS = 7;
    uint256 public constant FRACTIONAL_CARBON_CREDITS = 8;
    
    uint256 public MAX_FRACTIONAL_EQUITY_RIGHT;
    uint256 public MAX_FRACTIONAL_RENT_RIGHT;
    uint256 public MAX_FRACTIONAL_SUBSURFACE_RIGHTS;
    uint256 public MAX_FRACTIONAL_CARBON_CREDITS;
    
    //property Token Price
    uint256 public PROPERTY_PRICE = 10**14; //(0.0001 MATIC)
    uint256 public RENT_TOKEN_PRICE = 2 * 10**13; //(0.00002 MATIC)
    uint256 public SUBSURFACE_TOKEN_PRICE = 2 * 10**13; //(0.00002 MATIC)
    uint16 [] ordering;
    bool public approvalStatus;
    address TreasuryAdmin;
    modifier isTreasuryAdmin(){
        require(msg.sender==TreasuryAdmin);
        _;
    }
    modifier isLessThanMaxSupply(uint256 _id,uint256 _price,uint256 _limit){
        require(balanceOf(msg.sender,_id) + msg.value/_price < _limit);
        _;
    }
     
    constructor(
        string memory _baseURI,
        address _managingCompany,
        address _HOAAdmin,
        address _treasuryAdmin,
        bytes memory _rightToManagementURI,
        bytes memory _rightToEquityURI,
        bytes memory _rightToControlURI,
        bytes memory _rightToResidencyURI,
        bytes memory _rightToSubsurfaceURI
        )  ERC1155("") {
        bURI = _baseURI;
        _mint(_managingCompany, RIGHT_TO_EQUITY, 1, _rightToEquityURI);
        _mint(_managingCompany, RIGHT_TO_MANAGEMENT, 1, _rightToManagementURI);
        _mint(_managingCompany, RIGHT_TO_RESIDENCY, 1, _rightToResidencyURI);
        _mint(_managingCompany, RIGHT_TO_CONTROL, 1, _rightToControlURI);
        _mint(_managingCompany, SUBSURFACE_RIGHTS, 1, _rightToSubsurfaceURI);
        grantRole(HOA_ADMIN_ROLE, _HOAAdmin);
        grantRole(TREASURY_ADMIN_ROLE, _treasuryAdmin);
        approvalStatus = false;
        transferOwnership(_HOAAdmin);
        
    }
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC1155, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
        
    }
    function addRight(uint256 _rightId,string calldata _right,bool isAbsolute,uint16 [] calldata _rightOrder)public onlyOwner{
        if(isAbsolute){
            absoluteRightIDs.push(_rightId);
        }else{
            fractionalRightIDs.push(_rightId);
        }
        rights[_rightId] = _right;
        updateRightOrder(_rightOrder);
    }
    function updatePrice(uint256 _price)public onlyOwner{
        PROPERTY_PRICE = _price;
    }
    function approveProperty() public onlyOwner{
        approvalStatus = true;
    }
    function updateRightOrder(
        uint16 [] calldata _rightOrder
        ) public onlyOwner{
        ordering = _rightOrder;
    }
    function buyEquityRightFraction()public payable isTreasuryAdmin{
        require(hasRole(TREASURY_ADMIN_ROLE, msg.sender), "Caller is not a TREASURY_ADMIN_ROLE");
        _mint(msg.sender,FRACTIONAL_EQUITY_RIGHT,msg.value/PROPERTY_PRICE,"");
    }
    function buyRentRight()public payable isTreasuryAdmin{
        require(hasRole(TREASURY_ADMIN_ROLE, msg.sender), "Caller is not a TREASURY_ADMIN_ROLE");
        _mint(msg.sender,FRACTIONAL_RENT_RIGHT,msg.value/RENT_TOKEN_PRICE,"");
    }
    function buySubsurfaceTokens()public payable isTreasuryAdmin{
        require(hasRole(TREASURY_ADMIN_ROLE, msg.sender), "Caller is not a TREASURY_ADMIN_ROLE");
        _mint(msg.sender,FRACTIONAL_SUBSURFACE_RIGHTS,msg.value/SUBSURFACE_TOKEN_PRICE,"");
    }
    function baseURI() public view returns(string memory) {
        return bURI;
    }
    
}
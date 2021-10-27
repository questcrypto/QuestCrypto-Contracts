// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import "./QuestCryptoAsset.sol";

contract QuestAssetFactory{
    mapping(uint256=>address) tokenAddresses;
    uint256 propertyCounter = 0;
    address HOAadmin;
    modifier onlyHOAadmin(){
        require(msg.sender == HOAadmin);
        _;
    }
    constructor(){
        HOAadmin = msg.sender;
    }
    function deployQuestCryptoAsset(string memory _baseURI,address _managingCompany) public onlyHOAadmin returns(address) {

        QuestCryptoAsset contractAddress = new QuestCryptoAsset(
            _baseURI,
            _managingCompany,
            HOAadmin
        );
        tokenAddresses[propertyCounter] = address(contractAddress);
        propertyCounter++;
        return address(contractAddress);
    }
}
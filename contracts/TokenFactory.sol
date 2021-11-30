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
    function deployQuestCryptoAsset(string memory _baseURI, address _treasuryAdmin, address _managingCompany, bytes memory _rightToManagementURI, bytes memory _rightToEquityURI, bytes memory _rightToControlURI, bytes memory _rightToResidencyURI, bytes memory _rightToSubsurfaceURI ) public onlyHOAadmin returns(address) {
        QuestCryptoAsset contractAddress = new QuestCryptoAsset(
            _baseURI,
            _managingCompany,
            HOAadmin,
            _treasuryAdmin,
            _rightToManagementURI,
            _rightToEquityURI,
            _rightToControlURI,
            _rightToResidencyURI,
            _rightToSubsurfaceURI
        );
        tokenAddresses[propertyCounter] = address(contractAddress);
        propertyCounter++;
        return address(contractAddress);
    }
}
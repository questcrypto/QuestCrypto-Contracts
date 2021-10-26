// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import "./QuestCryptoAsset.sol";

contract QuestAssetFactory{
    // mapping(uint256=>address) tokenAddresses;
    // uint256 tokenCounter = 0;
    function deployQuestCryptoAsset(string memory _baseURI) public returns(address) {

        QuestCryptoAsset contractAddress = new QuestCryptoAsset(
            _baseURI,
            msg.sender
        );
        // tokenAddresses[tokenCounter] = address(contractAddress);
        // tokenCounter++;
        return address(contractAddress);
    }
}
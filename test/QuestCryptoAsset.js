const { expect } = require("chai")
const { ethers } = require("hardhat")

describe("Asset contract", () => {
  let Token, token, owner, addr1, addr2;

	beforeEach(async () => {
		Token = await ethers.getContractFactory("QuestCryptoAsset")
		token = await Token.deploy()
		[owner, addr1, addr2, _] = await ethers.getSigners()
  })
})

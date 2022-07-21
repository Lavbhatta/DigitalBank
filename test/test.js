const { expect } = require('chai')
const chaiAsPromised = require('chai-as-promised')
const { default: Web3 } = require('web3')
const { tokens, ether, ETHER_ADDRESS, EVM_REVERT, wait }=require ('./helper')

const Token = artifacts.require('./DigiToken.sol')
const Digibank = artifacts.require('./DigiBank.sol')

require('chai')
.use(require('chai-As-Promised'))
.should()


contract ('Digibank', ([deployer, user, bank]) => { 
let dbank, token
const interestPerSecond = 31668017
    
beforeEach(async () => { 
    token = await Token.new()
    dbank = await Digibank.new(token.address)
    await token.PassMinterRole(dbank.address, {from: deployer})
})

describe('Testing TokenContract', () => { 
    describe('success', () => { 
        it('has a name', async () => {
        const name = "DigitalToken";
        expect(await token.name()).to.be.eq(name);    
    })

    it('has a symbol', async () => {
        const sym = "DGT";
            expect(await token.symbol()).to.be.eq(sym)
    })

    it('has initial supply', async () => {
        const sup = 1e+24;
        expect(Number(await token.totalSupply())).to.be.eq(sup)
    })

    it("dbank has minter role", async () => {
        expect(await token.minter()).to.be.eq(dbank.address)
    })

})
    describe('faliure', () => {
    
    it("Faliure in minting tokens by users", async () =>  {
        await token.MintTokens(user, '1', {from: deployer}).should.be.rejectedWith(EVM_REVERT)
    })

    it('Mint Tokens', async () => {
        await token.PassMinterRole(user, {from: deployer}).should.be.rejectedWith(EVM_REVERT)
    })
    })
})

    describe('testing deposits', () => {
    let balance 
    
    describe('success', () => { 
      beforeEach(async () => {
        await dbank.Deposit({value: 1 * (10 ** 16), from: user})
    }) 

       it('deposit should match ether balance', async () => {
        await dbank.Deposit({value: 10**16, from: user})
       expect(Number(await dbank.stakingBalance(user))).to.be.eq(10**16)
    })    

    it('Timestamp should be higher than 0', async () => {
        expect(Number(await dbank.stakingStart(user))).to.be.eq(0)
    })
})
})
})

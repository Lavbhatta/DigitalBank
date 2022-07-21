const DigiToken = artifacts.require("./DigiToken")
const DigiBank = artifacts.require("./DigiBank")

module.exports = async function(deplpoyer) {
     
    await deplpoyer.deploy(DigiToken);
    
    const digiToken = await DigiToken.deployed()

    await deplpoyer.deploy(DigiBank, digiToken.address);

    const digiBank = await DigiBank.deployed()

    await digiToken.PassMinterRole(digiBank.address)

}
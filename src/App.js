import { React, Component } from "react";
const Token = artifacts.require('./DigiToken.json')
const Digibank = artifacts.require('./DigiBank.json')
const { default: Web3 } = require('web3')

class Digital extends React.Component {


async ComponentWillMount() {

   await loadblockChainData(dispatch); 

}

loadblockChainData(dispatch){

web3 = new Web3(ethereum.window);

const accounts = await web3.eth.getAccounts();
const account = accounts[0]

const token = await DigiToken.new();
const digibank = await DigiBank.new(token.address)

const network = web3.eth.net.getId();


const digiBank = new web3.eth.Contract(digibank.abi, digibank.network.address)
const stakingBalance = digiBank.stakingBalance([ account ]);
this.setState({stakingBalance: stakingBalance([ account ])})
const stakingStatus = digiBank.stakingStaus([ account ]);
this.setState({stakingStatus: stakingStatus([ account ])})
const stakingStart = digiBank.stakingStart([ account]);
this.setState({stakingStart: stakingStart([ account ])})
const daddress = digiBank.address
this.setState({daddress: daddress, web3: web3})
const digiToken = new Contract(token.abi, token.network.address)
this.setState({digiToken: digiToken})

}

constructor(props){
super(props) 
    this.state = {
        stakingBalance: '',
        stakingStatus: ' ',
        account: '',
        stakingStart: ''
    
}

}

}
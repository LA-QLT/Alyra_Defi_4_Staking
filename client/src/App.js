import React, { Component } from "react";
import 'bootstrap/dist/css/bootstrap.min.css';
import Button from 'react-bootstrap/Button';
import Form from 'react-bootstrap/Form';
import Card from 'react-bootstrap/Card';
import ListGroup from 'react-bootstrap/ListGroup';
import Table from 'react-bootstrap/Table';
import Staking from "./contracts/Staking.json";
import getWeb3 from "./getWeb3";
import "./App.css";

class App extends Component {
  state = { 
    web3: null, 
    accounts: null, 
    contract: null, 
    value:null,
    TVL:null
    };

  componentWillMount = async () => {
    try {
      // Récupérer le provider web3
      const web3 = await getWeb3();
  
      // Utiliser web3 pour récupérer les comptes de l’utilisateur (MetaMask dans notre cas) 
      const accounts = await web3.eth.getAccounts();

      // Récupérer l’instance du smart contract “Whitelist” avec web3 et les informations du déploiement du fichier (client/src/contracts/Whitelist.json)
      const networkId = await web3.eth.net.getId();
      const deployedNetwork = Staking.networks[networkId];
  
      const instance = new web3.eth.Contract(
        Staking.abi,
        deployedNetwork && deployedNetwork.address,
      );
      
      // Set web3, accounts, and contract to the state, and then proceed with an
      // example of interacting with the contract's methods.
      this.setState({ web3, accounts, contract: instance }, this.runInit);
    } catch (error) {
      // Catch any errors for any of the above operations.
      alert(
        `Non-Ethereum browser detected. Can you please try to install MetaMask before starting.`,
      );
      console.error(error);
    }
  };

  runInit = async() => {
    const {accounts, contract,web3 } = this.state;
    

    // Interaction avec le smart contract pour verifier le status 
    const StakeWei = await contract.methods.balances(accounts[0]).call();  
    const StakeEth = web3.utils.fromWei(StakeWei, 'ether');
    const tvlWei= await contract.methods.tvl().call();
    const tvlEther = web3.utils.fromWei(tvlWei, 'ether');
    this.setState({ nbStakeEth: StakeEth, tvl: tvlEther});

    //EVENEMENTS
    window.ethereum.on('accountsChanged', () => this.CompteMetamaskModifier());

    contract.events.Depot({},(err,event)=>{
    
    });

    contract.events.Whithdraw({},(err,event)=>{
      this.InitValueStake(event);
    });
  }; 

  CompteMetamaskModifier = async() => {
    const { web3,contract } = this.state;
    const reloadedAccounts = await web3.eth.getAccounts();
    const StakeW = await contract.methods.balances(reloadedAccounts[0]).call();  
    const StakeE = web3.utils.fromWei(StakeW, 'ether');
    this.setState({ accounts: reloadedAccounts, nbStakeEth: StakeE});
  }

  
  InitValueStake = async (event) => {
    const {accounts, contract,web3 } = this.state;
    const StakeWei = await contract.methods.balances(accounts[0]).call();  
    const StakeEth = web3.utils.fromWei(StakeWei, 'ether');
    const tvlWei= await contract.methods.tvl().call();
    const tvlEther = web3.utils.fromWei(tvlWei, 'ether');
    this.setState({ nbStakeEth: StakeEth, tvl: tvlEther});

  }


  Retirer = async () => {
    const { accounts, contract ,web3} = this.state;
    const valeur = this.valeur.value;
    const valeurWei = web3.utils.toWei(valeur, 'ether');
    // Interaction avec le smart contract pour ajouter une proposition
    await contract.methods.withdrawPayments(valeurWei).send({from: accounts[0]});
  
  }


 

  render() {
    const {nbStakeEth, contract,tvl } = this.state;
    if (!this.state.web3) {
      return <div>Loading Web3, accounts, and contract...</div>;
    }
    return (
      <div className="App">
        <div>
            <h2 className="text-center">Staking RENDEMENT</h2>
            <hr></hr>
            <br></br>
        </div>
        <div style={{display: 'flex', justifyContent: 'center'}}>
          <Card style={{ width: '50rem' }}>
            <Card.Header><strong>Staking ETH</strong></Card.Header>
            <Card.Body>
              <ListGroup variant="flush">
                <ListGroup.Item>
                    <tbody>
                    <tr>TVL:
                      <td><p>{tvl} ETH</p></td>
                    </tr>
                    <tr>Stake:
                      <td><p>{nbStakeEth} ETH</p></td>
                    </tr>
                    <tr>Profit:
                      <td>(Nombre de Profit en ETH )</td>
                      <td> <button variant="dark">  Claim  </button>   </td>
                    </tr>
                    <tr> 
                      <td>
                        <p>Pour Stake en ETH Veuillez envoyer de l'ether a cette adresse<br></br> 0x95262362852A2aB68C6c5847d2834cD9889da4F1 </p>  
                      </td>  
                    </tr>  
                    <tr>  
                    <td>  
                      <Form.Control type="text" id="valeur"
                      ref={(input) => { this.valeur = input }}
                      />   
                    </td>   
                       
                      <td>
                        <button onClick={this.Retirer}  variant="dark">UNSTAKE </button>     
                      </td>
                    </tr>
                    </tbody>
                </ListGroup.Item>
              </ListGroup>
            </Card.Body>
            <Card.Footer>
                  
            </Card.Footer >  
          </Card>
        </div>
        <br></br>
        
      </div>
    );
  }
}

export default App;
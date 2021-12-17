// const { BN, ether } = require('@openzeppelin/test-helpers');
// const { expect, expectRevert, expectEvent,} = require('chai');
// const Staking = artifacts.require('Staking');

// contract("Voting", function (accounts){
//   const owner = accounts[1];

  
//   beforeEach(async function () {
//     this.StakingInstance = await Staking.new({from: owner});
//   });

// //   it("verification owner", async function ()  {
// //     expect(await this.StakingInstance.owner()).to.equal(owner);
// //   });

//   it("verification Ajout Deposer", async function ()  {
//     const montant = new BN(100);
//     await this.StakingInstance.stake("0x8ccedeb0b7601a5e30be80356f2fc72164d7a0ef","100");
//     expect(await this.StakingInstance.balances(owner)).to.be.bignumber.equal("100");
//   });

//   it("status ProposalsRegistrationStarted", async function ()  {
//     await this.VotingInstance.StartEnregristrement();
//     const verifStatus = new BN(1);
//     expect(await this.VotingInstance.Status({from: owner})).to.be.bignumber.equal(verifStatus);
//   });

//   it("status ProposalsRegistrationEnded", async function ()  {
//     await this.VotingInstance.StartEnregristrement();
//     await this.VotingInstance.EndEnregristrement();
//     const verifStatus = new BN(2);
//     expect(await this.VotingInstance.Status({from: owner})).to.be.bignumber.equal(verifStatus);
//   });
//   it("status VotingSessionStarted", async function ()  {
//     await this.VotingInstance.StartEnregristrement();
//     await this.VotingInstance.EndEnregristrement();
//     await this.VotingInstance.StartVote();
//     const verifStatus = new BN(3);
//     expect(await this.VotingInstance.Status({from: owner})).to.be.bignumber.equal(verifStatus);
//   });

//   it("status VotingSessionEnded", async function ()  {
//     await this.VotingInstance.StartEnregristrement();
//     await this.VotingInstance.EndEnregristrement();
//     await this.VotingInstance.StartVote();
//     await this.VotingInstance.EndVote();
//     const verifStatus = new BN(4);
//     expect(await this.VotingInstance.Status({from: owner})).to.be.bignumber.equal(verifStatus);
//   });

//   it("Add proposal", async function ()  {
//     await this.VotingInstance.whitelist(whitelisted);
//     await this.VotingInstance.StartEnregristrement();
//     await this.VotingInstance.Addproposal("Proposition242",{from: whitelisted});
//     let newProposal = await this.VotingInstance.proposition(0); 
//     expect(newProposal.description).to.equal("Proposition242");
//     expect(newProposal.voteCount).to.be.bignumber.equal('0');
//   });


//   it("Add Vote", async function ()  {
//     await this.VotingInstance.whitelist(whitelisted);
//     await this.VotingInstance.whitelist(owner);
//     await this.VotingInstance.StartEnregristrement();
//     await this.VotingInstance.Addproposal("Proposition0",{from: whitelisted});
//     await this.VotingInstance.Addproposal("Proposition1",{from: owner});
//     await this.VotingInstance.EndEnregristrement();
//     await this.VotingInstance.StartVote();
//     await this.VotingInstance.Vote(1,{from: whitelisted});
//     await this.VotingInstance.Vote(1,{from: owner});
//     let newProposal = await this.VotingInstance.proposition(1); 
//     expect(newProposal.description).to.equal("Proposition1");
//     expect(newProposal.voteCount).to.be.bignumber.equal('2');
//   });
  



});

const Cryptoknowmics = artifacts.require('Cryptoknowmics.sol');
const Vesting = artifacts.require('Vesting.sol');

var Web3 = require("web3");
var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));

var Web3Utils = require('web3-utils');

const { increaseTimeTo, duration } = require('openzeppelin-solidity/test/helpers/increaseTime');
const { latestTime } = require('openzeppelin-solidity/test/helpers/latestTime');

contract('Cryptoknowmics Contract ', async (accounts) => {

    it('Should correctly initialize constructor values of Cryptoknowmics Token Contract', async () => {

        this.tokenhold = await Cryptoknowmics.new('QUILLHASH', 18, 'QH', { from: accounts[0], gas: 600000000 });

    });

    it('Should correctly initialize constructor values of Cryptoknowmics vesting Contract', async () => {

        this.vesting = await Vesting.new(this.tokenhold.address, { from: accounts[0], gas: 600000000 });

    });

    it('Should check the advisors token left', async () => {

        advisorTokensLeft = await this.vesting.advisorTokensLeft.call({ gas: 600000000 });
        assert.equal(advisorTokensLeft.toString() / 10 ** 18, 500000000)

    });

    it('Should check the stratergic token left', async () => {

        stratergicTokensLeft = await this.vesting.stratergicTokensLeft.call({ gas: 600000000 });
        assert.equal(stratergicTokensLeft.toString() / 10 ** 18, 500000000)

    });

    it('Should check the Team token left', async () => {

        teamReservedLeft = await this.vesting.teamReservedLeft.call({ gas: 600000000 });
        assert.equal(teamReservedLeft.toString() / 10 ** 18, 1500000000)

    });

    it('Should check the bounty air drop token left', async () => {

        bountieAirDropsLeft = await this.vesting.bountieAirDropsLeft.call({ gas: 600000000 });
        assert.equal(bountieAirDropsLeft.toString() / 10 ** 18, 500000000)

    });

    it('Should check the content contribution token left', async () => {

        contentContributionLeft = await this.vesting.contentContributionLeft.call({ gas: 600000000 });
        assert.equal(contentContributionLeft.toString() / 10 ** 18, 1500000000)

    });

    it('Should check the business development token left', async () => {

        businessDevelopmentLeft = await this.vesting.businessDevelopmentLeft.call({ gas: 600000000 });
        assert.equal(businessDevelopmentLeft.toString() / 10 ** 18, 2500000000)

    });

    it('Should check the advisors token sent', async () => {

        advisorTokensReleased = await this.vesting.advisorTokensReleased.call({ gas: 600000000 });
        assert.equal(advisorTokensReleased, 0)

    });

    it('Should check the stratergic token sent', async () => {

        stratergicTokensReleased = await this.vesting.stratergicTokensReleased.call({ gas: 600000000 });
        assert.equal(stratergicTokensReleased, 0)

    });

    it('Should check the Team token sent', async () => {

        teamReservedReleased = await this.vesting.teamReservedReleased.call({ gas: 600000000 });
        assert.equal(teamReservedReleased, 0)

    });

    it('Should check the bounty air drop token sent', async () => {

        bountieAirDropsReleased = await this.vesting.bountieAirDropsReleased.call({ gas: 600000000 });
        assert.equal(bountieAirDropsReleased, 0)

    });

    it('Should check the content contribution token sent', async () => {

        contentContributionReleased = await this.vesting.contentContributionReleased.call({ gas: 600000000 });
        assert.equal(contentContributionReleased, 0)

    });

    it('Should check the business development token sent', async () => {

        businessDevelopmentReleased = await this.vesting.businessDevelopmentReleased.call({ gas: 600000000 });
        assert.equal(businessDevelopmentReleased, 0)

    });

    it('Should send the required tokens to vesting contract', async () => {

        let value = 900 * 10 ** 18;
        let hexaValue = Web3Utils.toHex(value);
        await this.tokenhold.transfer(this.vesting.address, hexaValue, { from: accounts[0], gas: 600000000 });
    });

    it('Should check the balance tokens to vesting contract', async () => {


        let balanceOf = await this.tokenhold.balanceOf(this.vesting.address, { gas: 600000000 });

        assert.equal(balanceOf.toString() / 10 ** 18, 900);

    });

    it('Should Not be able to send Stratergic tokens by non owner account', async () => {

        try {
            let value = 10 * 10 ** 18;
            let hexaValue = Web3Utils.toHex(value);
            await this.vesting.sendStratergicTokens(accounts[1], hexaValue, { from: accounts[1], gas: 600000000 });
        } catch (error) {
            var error_ = 'Returned error: VM Exception while processing transaction: revert';
            assert.equal(error.message, error_);
        }

    });

    it('Should send the Stratergic tokens to beneficiary address from vesting contract', async () => {

        let value = 10 * 10 ** 18;
        let hexaValue = Web3Utils.toHex(value);
        await this.vesting.sendStratergicTokens(accounts[1], hexaValue, { from: accounts[0], gas: 600000000 });

    });

    it('Should check balance of  beneficiary of stratergic tokens', async () => {


        let balanceOf = await this.tokenhold.balanceOf(accounts[1], { gas: 600000000 });

        assert.equal(balanceOf.toString() / 10 ** 18, 10);

    });

    it('Should check the stratergic token left', async () => {

        stratergicTokensLeft = await this.vesting.stratergicTokensLeft.call({ gas: 600000000 });
        assert.equal(stratergicTokensLeft.toString() / 10 ** 18, 499999990)

    });

    it('Should check the stratergic token sent', async () => {

        stratergicTokensReleased = await this.vesting.stratergicTokensReleased.call({ gas: 600000000 });
        assert.equal(stratergicTokensReleased.toString() / 10 ** 18, 10)

    });

    it('Should not be able send the Bounty Tokens  to beneficiary address from non owner', async () => {

        try {
            let value = 10 * 10 ** 18;
            let hexaValue = Web3Utils.toHex(value);
            await this.vesting.sendBountyTokens(accounts[1], hexaValue, { from: accounts[1], gas: 600000000 });
        } catch (error) {
            var error_ = 'Returned error: VM Exception while processing transaction: revert';
            assert.equal(error.message, error_);
        }
    });

    it('Should send the Bounty Tokens  to beneficiary address from vesting contract', async () => {

        let value = 10 * 10 ** 18;
        let hexaValue = Web3Utils.toHex(value);
        await this.vesting.sendBountyTokens(accounts[1], hexaValue, { from: accounts[0], gas: 600000000 });

    });

    it('Should check balance of  beneficiary of bountieAirDrop', async () => {


        let balanceOf = await this.tokenhold.balanceOf(accounts[1], { gas: 600000000 });

        assert.equal(balanceOf.toString() / 10 ** 18, 20);

    });

    it('Should check the bountieAirDrop token left', async () => {

        bountieAirDropsLeft = await this.vesting.bountieAirDropsLeft.call({ gas: 600000000 });
        assert.equal(bountieAirDropsLeft.toString() / 10 ** 18, 499999990)

    });

    it('Should check the bountieAirDrop token sent', async () => {

        bountieAirDropsReleased = await this.vesting.bountieAirDropsReleased.call({ gas: 600000000 });
        assert.equal(bountieAirDropsReleased.toString() / 10 ** 18, 10)

    });

    it('Should not lock Team Tokens  to beneficiary address from non owner account', async () => {

        try {
            let value = 10 * 10 ** 18;
            let hexaValue = Web3Utils.toHex(value);
            await this.vesting.lockTeamTokens(accounts[2], hexaValue, { from: accounts[1], gas: 600000000 });
    
        } catch (error) {
            var error_ = 'Returned error: VM Exception while processing transaction: revert';
            assert.equal(error.message, error_);
        }
    });

    it('Should lock Team Tokens  to beneficiary address from vesting contract', async () => {

        let value = 10 * 10 ** 18;
        let hexaValue = Web3Utils.toHex(value);
        await this.vesting.lockTeamTokens(accounts[2], hexaValue, { from: accounts[0], gas: 600000000 });

    });

    it('Should check balance of  beneficiary of team token sent', async () => {


        let balanceOf = await this.tokenhold.balanceOf(accounts[2], { gas: 600000000 });

        assert.equal(balanceOf, 0);

    });

    it('Should check the teamInfo token ', async () => {

        teamInfo = await this.vesting.teamInfo.call(accounts[2], { gas: 600000000 });

        assert.equal(teamInfo.beneficiaryAddress, accounts[2]);
        assert.equal(teamInfo.tokensAlloted.toString(), 10 * 10 ** 18);

    });

    it('Should check the team token left', async () => {

        teamReservedLeft = await this.vesting.teamReservedLeft.call({ gas: 600000000 });
        assert.equal(teamReservedLeft.toString() / 10 ** 18, 1499999990)

    });

    it('Should check the team token sent', async () => {

        teamReservedReleased = await this.vesting.teamReservedReleased.call({ gas: 600000000 });
        assert.equal(teamReservedReleased.toString() / 10 ** 18, 10)

    });

    it('Should not be able to release team tokens quater 1 by non pwner account', async () => {

        try {

            teamReservedReleased = await this.vesting.releaseTeamTokens(accounts[2], 1, { from :accounts[1], gas: 600000000 })
    
        } catch (error) {
            var error_ = 'Returned error: VM Exception while processing transaction: revert';
            assert.equal(error.message, error_);
        }
    });

    it('Should be able to release team tokens quater 1', async () => {

        this.openingTime = (await latestTime());
        await increaseTimeTo(this.openingTime + duration.seconds(70934400));
        teamReservedReleased = await this.vesting.releaseTeamTokens(accounts[2], 1, { gas: 600000000 });


    });

    it('Should check balance of  beneficiary of team token after quater 1', async () => {


        let balanceOf = await this.tokenhold.balanceOf(accounts[2], { gas: 600000000 });

        assert.equal(balanceOf.toString() / 10 ** 18, 2.5);

    });

    it('Should not be able to release team tokens quater 2 by non pwner account', async () => {

        try {

            teamReservedReleased = await this.vesting.releaseTeamTokens(accounts[2], 2, { from :accounts[2], gas: 600000000 })
    
        } catch (error) {
            var error_ = 'Returned error: VM Exception while processing transaction: revert';
            assert.equal(error.message, error_);
        }
    });

    it('Should be able to release team tokens quater 2', async () => {

        this.openingTime = (await latestTime());
        await increaseTimeTo(this.openingTime + duration.seconds(78710400));
        teamReservedReleased = await this.vesting.releaseTeamTokens(accounts[2], 2, { gas: 600000000 });


    });

    it('Should check balance of  beneficiary of team token after quater 2', async () => {


        let balanceOf = await this.tokenhold.balanceOf(accounts[2], { gas: 600000000 });

        assert.equal(balanceOf.toString() / 10 ** 18, 5);

    });

    it('Should be able to release team tokens quater 3', async () => {

        this.openingTime = (await latestTime());
        await increaseTimeTo(this.openingTime + duration.seconds(102038400));
        teamReservedReleased = await this.vesting.releaseTeamTokens(accounts[2], 3, { gas: 600000000 });


    });

    it('Should check balance of  beneficiary of team token after quater 3', async () => {


        let balanceOf = await this.tokenhold.balanceOf(accounts[2], { gas: 600000000 });

        assert.equal(balanceOf.toString() / 10 ** 18, 7.5);

    });

    it('Should be able to release team tokens quater 4', async () => {

        this.openingTime = (await latestTime());
        await increaseTimeTo(this.openingTime + duration.seconds(133142400));
        teamReservedReleased = await this.vesting.releaseTeamTokens(accounts[2], 4, { gas: 600000000 });


    });

    it('Should check balance of  beneficiary of team token after quater 3', async () => {


        let balanceOf = await this.tokenhold.balanceOf(accounts[2], { gas: 600000000 });

        assert.equal(balanceOf.toString() / 10 ** 18, 10);

    });

    it('Should not be able to lock business tokensby non owner account', async () => {

        try {

            let value = 10 * 10 ** 18;
            let hexaValue = Web3Utils.toHex(value);
            await this.vesting.lockBusinessTokens(accounts[3], hexaValue, { from: accounts[1], gas: 600000000 });
    
        } catch (error) {
            var error_ = 'Returned error: VM Exception while processing transaction: revert';
            assert.equal(error.message, error_);
        }
    });

    it('Should be able to lock business tokens', async () => {


        let value = 10 * 10 ** 18;
        let hexaValue = Web3Utils.toHex(value);
        await this.vesting.lockBusinessTokens(accounts[3], hexaValue, { from: accounts[0], gas: 600000000 });


    });

    it('Should not be able to release business tokens just after the lock time finish by non owner account', async () => {

        try {

            teamReservedReleased = await this.vesting.releasebusinessTokens(accounts[3], { from : accounts[1], gas: 600000000 });
    
        } catch (error) {
            var error_ = 'Returned error: VM Exception while processing transaction: revert';
            assert.equal(error.message, error_);
        }
    });

    it('Should be able to release business tokens just after the lock time finish', async () => {

        this.openingTime = (await latestTime());
        await increaseTimeTo(this.openingTime + duration.seconds(15638400));
        teamReservedReleased = await this.vesting.releasebusinessTokens(accounts[3], { gas: 600000000 });


    });

    it('Should check balance of  beneficiary of after business tokens recieved', async () => {


        let balanceOf = await this.tokenhold.balanceOf(accounts[3], { gas: 600000000 });

        assert.equal(balanceOf.toString() / 10 ** 18, 10);

    });

    it('Should not be able to lock Advisor Tokens by non owner account', async () => {

        try {

            let value = 10 * 10 ** 18;
            let hexaValue = Web3Utils.toHex(value);
            await this.vesting.lockAdvisorTokens(accounts[4], hexaValue, { from: accounts[1], gas: 600000000 });
    
    
        } catch (error) {
            var error_ = 'Returned error: VM Exception while processing transaction: revert';
            assert.equal(error.message, error_);
        }
    });

    it('Should be able to lock Advisor Tokens ', async () => {

        let value = 10 * 10 ** 18;
        let hexaValue = Web3Utils.toHex(value);
        await this.vesting.lockAdvisorTokens(accounts[4], hexaValue, { from: accounts[0], gas: 600000000 });

    });

    it('Should check the advisors token left', async () => {

        advisorTokensLeft = await this.vesting.advisorTokensLeft.call({ gas: 600000000 });
        assert.equal(advisorTokensLeft.toString() / 10 ** 18, 499999990);

    });

    it('Should not be able to release advisors tokens quater 1 non owner account', async () => {

        try {

            releaseAdvisorTokens = await this.vesting.releaseAdvisorTokens(accounts[4], 1, { from : accounts[1], gas: 600000000 });
    
    
        } catch (error) {
            var error_ = 'Returned error: VM Exception while processing transaction: revert';
            assert.equal(error.message, error_);
        }
    });

    it('Should be able to release advisors tokens quater 1', async () => {

        this.openingTime = (await latestTime());
        await increaseTimeTo(this.openingTime + duration.seconds(7862400));
        releaseAdvisorTokens = await this.vesting.releaseAdvisorTokens(accounts[4], 1, { gas: 600000000 });
    });

    it('Should check balance of  beneficiary of after advisors tokens recieved', async () => {


        let balanceOf = await this.tokenhold.balanceOf(accounts[4], { gas: 600000000 });

        assert.equal(balanceOf.toString() / 10 ** 18, 1.25);

    });

    it('Should not be able to release advisors tokens quater 1 non owner account', async () => {

        try {

            releaseAdvisorTokens = await this.vesting.releaseAdvisorTokens(accounts[4], 2, { from : accounts[1], gas: 600000000 });
    
    
        } catch (error) {
            var error_ = 'Returned error: VM Exception while processing transaction: revert';
            assert.equal(error.message, error_);
        }
    });

    it('Should be able to release advisors tokens quater 2', async () => {

        this.openingTime = (await latestTime());
        await increaseTimeTo(this.openingTime + duration.seconds(7862400));
        releaseAdvisorTokens = await this.vesting.releaseAdvisorTokens(accounts[4], 2, { gas: 600000000 });
    });

    it('Should check balance of  beneficiary of after advisors tokens recieved', async () => {


        let balanceOf = await this.tokenhold.balanceOf(accounts[4], { gas: 600000000 });

        assert.equal(balanceOf.toString() / 10 ** 18, 2.5);

    });

    it('Should be able to release advisors tokens quater 3', async () => {

        this.openingTime = (await latestTime());
        await increaseTimeTo(this.openingTime + duration.seconds(7862400));
        releaseAdvisorTokens = await this.vesting.releaseAdvisorTokens(accounts[4], 3, { gas: 600000000 });
    });

    it('Should check balance of  beneficiary of after advisors tokens recieved', async () => {


        let balanceOf = await this.tokenhold.balanceOf(accounts[4], { gas: 600000000 });

        assert.equal(balanceOf.toString() / 10 ** 18, 3.75);

    });

    it('Should be able to release advisors tokens quater 4', async () => {

        this.openingTime = (await latestTime());
        await increaseTimeTo(this.openingTime + duration.seconds(7862400));
        releaseAdvisorTokens = await this.vesting.releaseAdvisorTokens(accounts[4], 4, { gas: 600000000 });
    });

    it('Should check balance of  beneficiary of after advisors tokens recieved', async () => {


        let balanceOf = await this.tokenhold.balanceOf(accounts[4], { gas: 600000000 });

        assert.equal(balanceOf.toString() / 10 ** 18, 5);

    });

    it('Should be able to release advisors tokens quater 5', async () => {

        this.openingTime = (await latestTime());
        await increaseTimeTo(this.openingTime + duration.seconds(7862400));
        releaseAdvisorTokens = await this.vesting.releaseAdvisorTokens(accounts[4], 5, { gas: 600000000 });
    });

    it('Should check balance of  beneficiary of after advisors tokens recieved', async () => {


        let balanceOf = await this.tokenhold.balanceOf(accounts[4], { gas: 600000000 });

        assert.equal(balanceOf.toString() / 10 ** 18, 6.25);

    });

    it('Should be able to release advisors tokens quater 6', async () => {

        this.openingTime = (await latestTime());
        await increaseTimeTo(this.openingTime + duration.seconds(7862400));
        releaseAdvisorTokens = await this.vesting.releaseAdvisorTokens(accounts[4], 6, { gas: 600000000 });
    });

    it('Should check balance of  beneficiary of after advisors tokens recieved', async () => {


        let balanceOf = await this.tokenhold.balanceOf(accounts[4], { gas: 600000000 });

        assert.equal(balanceOf.toString() / 10 ** 18, 7.5);

    });

    it('Should be able to release advisors tokens quater 7', async () => {

        this.openingTime = (await latestTime());
        await increaseTimeTo(this.openingTime + duration.seconds(7862400));
        releaseAdvisorTokens = await this.vesting.releaseAdvisorTokens(accounts[4], 7, { gas: 600000000 });
    });

    it('Should check balance of  beneficiary of after advisors tokens recieved', async () => {


        let balanceOf = await this.tokenhold.balanceOf(accounts[4], { gas: 600000000 });

        assert.equal(balanceOf.toString() / 10 ** 18, 8.75);

    });

    it('Should be able to release advisors tokens quater 8', async () => {

        this.openingTime = (await latestTime());
        await increaseTimeTo(this.openingTime + duration.seconds(7862400));
        releaseAdvisorTokens = await this.vesting.releaseAdvisorTokens(accounts[4], 8, { gas: 600000000 });
    });

    it('Should check balance of  beneficiary of after advisors tokens recieved', async () => {


        let balanceOf = await this.tokenhold.balanceOf(accounts[4], { gas: 600000000 });

        assert.equal(balanceOf.toString() / 10 ** 18, 10);

    });

    it('Should be able to lock content Tokens by non owner account', async () => {

        try {

            let value = 10 * 10 ** 18;
            let hexaValue = Web3Utils.toHex(value);
            await this.vesting.lockContentTokens(accounts[5], hexaValue, { from: accounts[1], gas: 600000000 });
    
        } catch (error) {
            var error_ = 'Returned error: VM Exception while processing transaction: revert';
            assert.equal(error.message, error_);
        }
    });

    it('Should be able to lock content Tokens ', async () => {

        let value = 10 * 10 ** 18;
        let hexaValue = Web3Utils.toHex(value);
        await this.vesting.lockContentTokens(accounts[5], hexaValue, { from: accounts[0], gas: 600000000 });

    });

    it('Should check the content Contribution token Left', async () => {

        contentContributionLeft = await this.vesting.contentContributionLeft.call({ gas: 600000000 });
        assert.equal(contentContributionLeft.toString() / 10 ** 18, 1499999990);

    });

    it('Should check the content contribution token sent', async () => {

        contentContributionReleased = await this.vesting.contentContributionReleased.call({ gas: 600000000 });
        assert.equal(contentContributionReleased.toString() / 10 ** 18, 10)

    });

    it('Should Not be able to release content tokens quater 1 before time', async () => {

        try {
            await this.vesting.releaseContentTokens(accounts[5], 10, { gas: 600000000 });
        } catch (error) {
            var error_ = 'Returned error: VM Exception while processing transaction: revert';
            assert.equal(error.message, error_);
        }

    });

    it('Should be able to release content tokens quater 1', async () => {

        this.openingTime = (await latestTime());
        await increaseTimeTo(this.openingTime + duration.seconds(7862400));
        releaseContentTokens = await this.vesting.releaseContentTokens(accounts[5], 1, { gas: 600000000 });
    });

    it('Should check balance of  beneficiary of after content tokens recieved', async () => {


        let balanceOf = await this.tokenhold.balanceOf(accounts[5], { gas: 600000000 });

        assert.equal(balanceOf.toString() / 10 ** 18, 1);

    });

    it('Should Not be able to release content tokens quater 2 by non owner account', async () => {

        try {
            await this.vesting.releaseContentTokens(accounts[5], 2, { from : accounts[1], gas: 600000000 });
        } catch (error) {
            var error_ = 'Returned error: VM Exception while processing transaction: revert';
            assert.equal(error.message, error_);
        }

    });

    it('Should be able to release content tokens quater 2', async () => {

        this.openingTime = (await latestTime());
        await increaseTimeTo(this.openingTime + duration.seconds(15638400));
        releaseContentTokens = await this.vesting.releaseContentTokens(accounts[5], 2, { gas: 600000000 });

    });

    it('Should check balance of  beneficiary of after content tokens recieved', async () => {


        let balanceOf = await this.tokenhold.balanceOf(accounts[5], { gas: 600000000 });

        assert.equal(balanceOf.toString() / 10 ** 18, 2);

    });

    it('Should Not be able to release content tokens quater 3 by non owner account', async () => {

        try {
            await this.vesting.releaseContentTokens(accounts[5], 3, { from : accounts[1], gas: 600000000 });
        } catch (error) {
            var error_ = 'Returned error: VM Exception while processing transaction: revert';
            assert.equal(error.message, error_);
        }

    });

    it('Should be able to release content tokens quater 3', async () => {

        this.openingTime = (await latestTime());
        await increaseTimeTo(this.openingTime + duration.seconds(23414400));
        releaseContentTokens = await this.vesting.releaseContentTokens(accounts[5], 3, { gas: 600000000 });

    });

    it('Should check balance of  beneficiary of after content tokens recieved', async () => {

        let balanceOf = await this.tokenhold.balanceOf(accounts[5], { gas: 600000000 });

        assert.equal(balanceOf.toString() / 10 ** 18, 3);

    });

    it('Should be able to release content tokens quater 4', async () => {

        this.openingTime = (await latestTime());
        await increaseTimeTo(this.openingTime + duration.seconds(31190400));
        releaseContentTokens = await this.vesting.releaseContentTokens(accounts[5], 4, { gas: 600000000 });

    });

    it('Should check balance of  beneficiary of after content tokens recieved', async () => {

        let balanceOf = await this.tokenhold.balanceOf(accounts[5], { gas: 600000000 });

        assert.equal(balanceOf.toString() / 10 ** 18, 4);

    });

    it('Should Not be able to release content tokens quater 5 by non owner account', async () => {

        try {
            await this.vesting.releaseContentTokens(accounts[5], 5, { from : accounts[1], gas: 600000000 });
        } catch (error) {
            var error_ = 'Returned error: VM Exception while processing transaction: revert';
            assert.equal(error.message, error_);
        }

    });

    it('Should be able to release content tokens quater 5', async () => {

        this.openingTime = (await latestTime());
        await increaseTimeTo(this.openingTime + duration.seconds(38966400));
        releaseContentTokens = await this.vesting.releaseContentTokens(accounts[5], 5, { gas: 600000000 });

    });

    it('Should check balance of  beneficiary of after content tokens recieved', async () => {

        let balanceOf = await this.tokenhold.balanceOf(accounts[5], { gas: 600000000 });

        assert.equal(balanceOf.toString() / 10 ** 18, 5);

    });

    it('Should be able to release content tokens quater 6', async () => {

        this.openingTime = (await latestTime());
        await increaseTimeTo(this.openingTime + duration.seconds(41558400));
        releaseContentTokens = await this.vesting.releaseContentTokens(accounts[5], 6, { gas: 600000000 });

    });

    it('Should check balance of  beneficiary of after content tokens recieved', async () => {

        let balanceOf = await this.tokenhold.balanceOf(accounts[5], { gas: 600000000 });

        assert.equal(balanceOf.toString() / 10 ** 18, 6);

    });

    it('Should Not be able to release content tokens quater 7 by non owner account', async () => {

        try {
            await this.vesting.releaseContentTokens(accounts[5], 7, { from : accounts[1], gas: 600000000 });
        } catch (error) {
            var error_ = 'Returned error: VM Exception while processing transaction: revert';
            assert.equal(error.message, error_);
        }

    });

    it('Should be able to release content tokens quater 7', async () => {

        this.openingTime = (await latestTime());
        await increaseTimeTo(this.openingTime + duration.seconds(46742400));
        releaseContentTokens = await this.vesting.releaseContentTokens(accounts[5], 7, { gas: 600000000 });

    });

    it('Should check balance of  beneficiary of after content tokens recieved', async () => {

        let balanceOf = await this.tokenhold.balanceOf(accounts[5], { gas: 600000000 });

        assert.equal(balanceOf.toString() / 10 ** 18, 7);

    });

    it('Should be able to release content tokens quater 8', async () => {

        this.openingTime = (await latestTime());
        await increaseTimeTo(this.openingTime + duration.seconds(54518400));
        releaseContentTokens = await this.vesting.releaseContentTokens(accounts[5], 8, { gas: 600000000 });

    });

    it('Should check balance of  beneficiary of after content tokens recieved', async () => {

        let balanceOf = await this.tokenhold.balanceOf(accounts[5], { gas: 600000000 });

        assert.equal(balanceOf.toString() / 10 ** 18, 8);

    });

    it('Should be able to release content tokens quater 9', async () => {

        this.openingTime = (await latestTime());
        await increaseTimeTo(this.openingTime + duration.seconds(62294400));
        releaseContentTokens = await this.vesting.releaseContentTokens(accounts[5], 9, { gas: 600000000 });

    });

    it('Should check balance of  beneficiary of after content tokens recieved', async () => {

        let balanceOf = await this.tokenhold.balanceOf(accounts[5], { gas: 600000000 });

        assert.equal(balanceOf.toString() / 10 ** 18, 9);

    });

    it('Should be able to release content tokens quater 10', async () => {

        this.openingTime = (await latestTime());
        await increaseTimeTo(this.openingTime + duration.seconds(70070400));
        releaseContentTokens = await this.vesting.releaseContentTokens(accounts[5], 10, { gas: 600000000 });

    });

    it('Should check balance of  beneficiary of after content tokens recieved', async () => {

        let balanceOf = await this.tokenhold.balanceOf(accounts[5], { gas: 600000000 });

        assert.equal(balanceOf.toString() / 10 ** 18, 10);

    });

    it('Should check balance of  vesting contract at token contract', async () => {

        let balanceOf = await this.tokenhold.balanceOf(this.vesting.address, { gas: 600000000 });

        assert.equal(balanceOf.toString() / 10 ** 18, 840);

    });

    it('Should transfer all the tokens left in vesting contract', async () => {

        let value = 800 * 10 ** 18;
        let hexaValue = Web3Utils.toHex(value);
        await this.vesting.transferAnyERC20Token(this.tokenhold.address,hexaValue, {from: accounts[0], gas: 600000000 });

    });

    it('Should check balance of vesting contract at token contract after transfer any ERC20 tokens', async () => {

        let balanceOf = await this.tokenhold.balanceOf(this.vesting.address, { gas: 600000000 });
        assert.equal(balanceOf.toString() / 10 ** 18, 40);

    });
})



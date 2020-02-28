pragma solidity 0.5.0;


contract Cryptoknowmics {

    function transfer(address, uint256) public returns (bool);
    
}

contract Owned {
    address public owner;
    address public newOwner;

    event OwnershipTransferred(address indexed from, address indexed _to);

    constructor(address _owner) public {
        owner = _owner;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

}

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint c) {
        require(b <= a);
        c = a - b;
    }
    function mul(uint256 a, uint256 b) internal pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }
    function div(uint256 a, uint256 b) internal pure returns (uint c) {
        require(b > 0);
        c = a / b;
    }
}

/**
 * @title TokenVesting
 * @dev A token holder contract that can release its token balance gradually like a
 * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
 * owner.
 */
contract Vesting is Owned {

    using SafeMath for uint256;

    Cryptoknowmics public _token;


    uint256 public advisorTokensLeft = 500000000 ether; // release 12.5% each quater 
    uint256 public stratergicTokensLeft = 500000000 ether; //kept unlocked can be sent directly
    uint256 public teamReservedLeft = 1500000000 ether; // 2 years completely locked after that release 25% quaterly
    uint256 public bountieAirDropsLeft = 500000000 ether; //unlocked can be available anytime
    uint256 public contentContributionLeft = 1500000000 ether; // 10% each quater, when alloted
    uint256 public businessDevelopmentLeft = 2500000000 ether; // lock for first 6 months

    uint256 public advisorTokensReleased;
    uint256 public stratergicTokensReleased;
    uint256 public teamReservedReleased;
    uint256 public bountieAirDropsReleased;
    uint256 public contentContributionReleased;
    uint256 public businessDevelopmentReleased;
    
    mapping (address => uint256) public businessTokensAlloted;
    mapping (address => uint256) public businessTokensAllotedTime;
    mapping (address => bool) public businessTokensReleased;


    struct advisorsTokenInfo {

        address beneficiaryAddress;
        uint256 tokensAlloted;
        uint256 timeAtAllocation;
        uint256 tokenSent;
        uint256 tokensLeft;
        mapping (uint256 => bool) quaterAvaild;


    }

    mapping(address => advisorsTokenInfo) public advisorsInfo;

      struct teamTokenInfo {

        address beneficiaryAddress;
        uint256 tokensAlloted;
        uint256 timeAtAllocation;
        uint256 tokenSent;
        uint256 tokensLeft;
        bool availedQuaterOne;
        bool availedQuaterTwo;
        bool availedQuaterThree;
        bool availedQuaterFour;                

    }

    mapping(address => teamTokenInfo) public teamInfo;


    struct contenntContribution {

        address beneficiaryAddress;
        uint256 tokensAlloted;
        uint256 timeAtAllocation;
        uint256 tokenSent;
        uint256 tokensLeft;
        mapping (uint256 => bool) quaterAvaild;

    }

    mapping(address => contenntContribution) public contentContributionInfo;    


    constructor(Cryptoknowmics token) Owned(msg.sender) public {
      _token = token;
    }


  function lockTeamTokens (address _beneficiary, uint256 amount) onlyOwner external {
      
      require(_beneficiary != address(0));
      require(amount != 0);
      require(teamReservedLeft>=amount);
      require (teamReservedReleased.add(amount) <= teamReservedLeft);
      require(teamInfo[_beneficiary].beneficiaryAddress == address(0x0));
      
      teamReservedReleased = teamReservedReleased.add(amount);
      teamReservedLeft = teamReservedLeft.sub(amount);
      
      teamInfo[_beneficiary].beneficiaryAddress  = _beneficiary;
      teamInfo[_beneficiary].tokensAlloted = amount;
      teamInfo[_beneficiary].timeAtAllocation = now;
      teamInfo[_beneficiary].availedQuaterOne = false;


  }



  function lockContentTokens (address _beneficiary, uint256 amount) onlyOwner external {
      
      require(_beneficiary != address(0));
      require(amount != 0);
      require(contentContributionLeft>=0);

      require (contentContributionReleased.add(amount) <= contentContributionLeft);
      require(contentContributionInfo[_beneficiary].beneficiaryAddress == address(0x0));
      
      
      contentContributionReleased = contentContributionReleased.add(amount);
      contentContributionLeft = contentContributionLeft.sub(amount);

      contentContributionInfo[_beneficiary].beneficiaryAddress  = _beneficiary;
      contentContributionInfo[_beneficiary].tokensAlloted = amount;
      contentContributionInfo[_beneficiary].timeAtAllocation = now;

      }


  function sendStratergicTokens (address _beneficiary, uint256 amount) onlyOwner external {
      
      require(_beneficiary != address(0));
      require(amount != 0);
      require(stratergicTokensLeft>=0);
      require (stratergicTokensReleased.add(amount) <= stratergicTokensLeft);
      
      stratergicTokensReleased = stratergicTokensReleased.add(amount);
      stratergicTokensLeft = stratergicTokensLeft.sub(amount);
      require(_token.transfer(_beneficiary, amount));        

  }


  function lockBusinessTokens (address _beneficiary, uint256 amount) onlyOwner external {
      
      require(_beneficiary != address(0));
      require(amount != 0);
      require(businessDevelopmentLeft>=0);
      require(businessTokensAlloted[_beneficiary] == 0);
      require (businessDevelopmentReleased.add(amount) <= businessDevelopmentLeft);
      
      businessDevelopmentReleased = businessDevelopmentReleased.add(amount);
      businessDevelopmentLeft = businessDevelopmentLeft.sub(amount);

      businessTokensAlloted[_beneficiary] = amount;
      businessTokensAllotedTime[_beneficiary] = now;
      businessTokensReleased[_beneficiary] = false;
    
  }


  function sendBountyTokens (address _beneficiary, uint256 amount) onlyOwner external {
      
      require(_beneficiary != address(0));
      require(amount != 0);
      require (bountieAirDropsReleased.add(amount) <= bountieAirDropsLeft);
      
      bountieAirDropsReleased = bountieAirDropsReleased.add(amount);
      bountieAirDropsLeft = bountieAirDropsLeft.sub(amount);
      require(_token.transfer(_beneficiary, amount));        

  }

  function lockAdvisorTokens (address _beneficiary, uint256 amount) onlyOwner external {
      
      require(_beneficiary != address(0));
      require(amount != 0);
      require (advisorTokensReleased.add(amount) <= advisorTokensLeft);
      require(advisorsInfo[_beneficiary].beneficiaryAddress == address(0x0));
      
      
      advisorTokensReleased = advisorTokensReleased.add(amount);
      advisorTokensLeft = advisorTokensLeft.sub(amount);

      advisorsInfo[_beneficiary].beneficiaryAddress  = _beneficiary;
      advisorsInfo[_beneficiary].tokensAlloted = amount;
      advisorsInfo[_beneficiary].timeAtAllocation = now;


      }
    

    //1st, 2nd , 3rd.....

    function releaseAdvisorTokens (address _beneficiary, uint256 _quater) onlyOwner external {      

      require(_beneficiary != address(0));
      require(advisorsInfo[_beneficiary].beneficiaryAddress != address(0x0));
      uint256 quaterTokens;

      if(_quater == 1) //1st quater (3-6)
      {
          quaterTokens = advisorsInfo[_beneficiary].tokensAlloted.div(8);
          require(advisorsInfo[_beneficiary].tokenSent == 0);
          require(now>=advisorsInfo[_beneficiary].timeAtAllocation.add(7776000));
          require(advisorsInfo[_beneficiary].quaterAvaild[1] ==  false);

          advisorsInfo[_beneficiary].tokenSent = advisorsInfo[_beneficiary].tokensAlloted.div(8);
          advisorsInfo[_beneficiary].tokensLeft = advisorsInfo[_beneficiary].tokensAlloted.sub(advisorsInfo[_beneficiary].tokensAlloted.div(8));
          require(advisorsInfo[_beneficiary].tokenSent<=advisorsInfo[_beneficiary].tokensAlloted);
          advisorsInfo[_beneficiary].quaterAvaild[1] = true;
          require(_token.transfer(_beneficiary, quaterTokens));
          

      }else if (_quater == 2) // 2nd quater (6-9)
      {
          quaterTokens = advisorsInfo[_beneficiary].tokensAlloted.div(8);
          require(advisorsInfo[_beneficiary].tokenSent == quaterTokens.mul(1));
          require(now>=advisorsInfo[_beneficiary].timeAtAllocation.add(15552000));
          require(advisorsInfo[_beneficiary].quaterAvaild[2] ==  false);

          advisorsInfo[_beneficiary].tokenSent = advisorsInfo[_beneficiary].tokenSent.add(quaterTokens);
          advisorsInfo[_beneficiary].tokensLeft = advisorsInfo[_beneficiary].tokensAlloted.sub(quaterTokens.mul(2));
          require(advisorsInfo[_beneficiary].tokenSent<=advisorsInfo[_beneficiary].tokensAlloted);
          advisorsInfo[_beneficiary].quaterAvaild[2] = true;
          require(_token.transfer(_beneficiary, quaterTokens));       
          
      }else if (_quater == 3) // 3rd quater (9-12)
      {
          quaterTokens = advisorsInfo[_beneficiary].tokensAlloted.div(8);
          require(advisorsInfo[_beneficiary].tokenSent == quaterTokens.mul(2));
          require(now>=advisorsInfo[_beneficiary].timeAtAllocation.add(23328000));
          require(advisorsInfo[_beneficiary].quaterAvaild[3] ==  false);

          advisorsInfo[_beneficiary].tokenSent = advisorsInfo[_beneficiary].tokenSent.add(quaterTokens);
          advisorsInfo[_beneficiary].tokensLeft = advisorsInfo[_beneficiary].tokensAlloted.sub(quaterTokens.mul(3));
          require(advisorsInfo[_beneficiary].tokenSent<=advisorsInfo[_beneficiary].tokensAlloted);
          advisorsInfo[_beneficiary].quaterAvaild[3] = true;
          require(_token.transfer(_beneficiary, quaterTokens));

          
      }else if (_quater == 4) // 4th quater (12-15)
      {
          
          quaterTokens = advisorsInfo[_beneficiary].tokensAlloted.div(8);
          require(advisorsInfo[_beneficiary].tokenSent == quaterTokens.mul(3));
          require(now>=advisorsInfo[_beneficiary].timeAtAllocation.add(31104000));
          require(advisorsInfo[_beneficiary].quaterAvaild[4] ==  false);

          advisorsInfo[_beneficiary].tokenSent = advisorsInfo[_beneficiary].tokenSent.add(quaterTokens);
          advisorsInfo[_beneficiary].tokensLeft = advisorsInfo[_beneficiary].tokensAlloted.sub(quaterTokens.mul(4));
          require(advisorsInfo[_beneficiary].tokenSent<=advisorsInfo[_beneficiary].tokensAlloted);
          advisorsInfo[_beneficiary].quaterAvaild[4] = true;
          require(_token.transfer(_beneficiary, quaterTokens));
          
          
          
      }else if (_quater == 5) // 5th quater (15-18)
      {

          quaterTokens = advisorsInfo[_beneficiary].tokensAlloted.div(8);
          require(advisorsInfo[_beneficiary].tokenSent == quaterTokens.mul(4));
          require(now>=advisorsInfo[_beneficiary].timeAtAllocation.add(38880000));
          require(advisorsInfo[_beneficiary].quaterAvaild[5] ==  false);

          advisorsInfo[_beneficiary].tokenSent = advisorsInfo[_beneficiary].tokenSent.add(quaterTokens);
          advisorsInfo[_beneficiary].tokensLeft = advisorsInfo[_beneficiary].tokensAlloted.sub(quaterTokens.mul(5));
          require(advisorsInfo[_beneficiary].tokenSent<=advisorsInfo[_beneficiary].tokensAlloted);
          advisorsInfo[_beneficiary].quaterAvaild[5] = true;
          require(_token.transfer(_beneficiary, quaterTokens));

          
      }else if (_quater == 6) // 6th quater (18-21)
      {
          
          quaterTokens = advisorsInfo[_beneficiary].tokensAlloted.div(8);
          require(advisorsInfo[_beneficiary].tokenSent == quaterTokens.mul(5));
          require(now>=advisorsInfo[_beneficiary].timeAtAllocation.add(46656000));
          require(advisorsInfo[_beneficiary].quaterAvaild[6] ==  false);

          advisorsInfo[_beneficiary].tokenSent = advisorsInfo[_beneficiary].tokenSent.add(quaterTokens);
          advisorsInfo[_beneficiary].tokensLeft = advisorsInfo[_beneficiary].tokensAlloted.sub(quaterTokens.mul(6));
          require(advisorsInfo[_beneficiary].tokenSent<=advisorsInfo[_beneficiary].tokensAlloted);
          advisorsInfo[_beneficiary].quaterAvaild[6] = true;
          require(_token.transfer(_beneficiary, quaterTokens));          
          
      }else if (_quater == 7) // 7th quater (21-24)
      {

          quaterTokens = advisorsInfo[_beneficiary].tokensAlloted.div(8);
          require(advisorsInfo[_beneficiary].tokenSent == quaterTokens.mul(6),"token sent is higher");
          require(now>=advisorsInfo[_beneficiary].timeAtAllocation.add(54432000),"Time not complete");
          require(advisorsInfo[_beneficiary].quaterAvaild[7] ==  false,"already taken seventh quater tokens");

          advisorsInfo[_beneficiary].tokenSent = advisorsInfo[_beneficiary].tokenSent.add(quaterTokens);
          advisorsInfo[_beneficiary].tokensLeft = advisorsInfo[_beneficiary].tokensAlloted.sub(quaterTokens.mul(7));
          require(advisorsInfo[_beneficiary].tokenSent<=advisorsInfo[_beneficiary].tokensAlloted,"after update token is higher is sent than alloted");
          advisorsInfo[_beneficiary].quaterAvaild[7] = true;
          require(_token.transfer(_beneficiary, quaterTokens),"token transferfails");          

          
      }else if (_quater == 8) //greater than 8th quater 
      {

          quaterTokens = advisorsInfo[_beneficiary].tokensAlloted.div(8);
          require(advisorsInfo[_beneficiary].tokenSent == quaterTokens.mul(7),"token sent is higher");
          require(now>=advisorsInfo[_beneficiary].timeAtAllocation.add(62208000),"Time not complete");
          require(advisorsInfo[_beneficiary].quaterAvaild[8] ==  false,"already taken seventh quater tokens");

          advisorsInfo[_beneficiary].tokenSent = advisorsInfo[_beneficiary].tokenSent.add(quaterTokens);
          advisorsInfo[_beneficiary].tokensLeft = advisorsInfo[_beneficiary].tokensAlloted.sub(quaterTokens.mul(8));
          require(advisorsInfo[_beneficiary].tokenSent<=advisorsInfo[_beneficiary].tokensAlloted,"after update token is higher is sent than alloted");
          advisorsInfo[_beneficiary].quaterAvaild[8] = true;
          require(_token.transfer(_beneficiary, quaterTokens),"token transferfails");
          
      }else {

          revert();

      }
  }


    function releaseTeamTokens (address _beneficiary, uint256 _quater) onlyOwner external {
      
      uint256 twoYearsTime = 63072000;
      uint256 quaterTokens;
      require(_beneficiary != address(0),"beneficiary address is zero");
      require(teamInfo[_beneficiary].beneficiaryAddress != address(0x0),"beneficiary is not team member");


      if(_quater == 1) //1st quater (3-6) 25%
      {

          quaterTokens = teamInfo[_beneficiary].tokensAlloted.div(4);

          require(teamInfo[_beneficiary].tokenSent == 0,"Token sent is not zero");
          require(teamInfo[_beneficiary].availedQuaterOne == false);
          require(now>=teamInfo[_beneficiary].timeAtAllocation.add(7776000));          
          teamInfo[_beneficiary].tokenSent = teamInfo[_beneficiary].tokensAlloted.div(4);
          teamInfo[_beneficiary].tokensLeft = teamInfo[_beneficiary].tokensAlloted.sub(teamInfo[_beneficiary].tokensAlloted.div(4));
          require(teamInfo[_beneficiary].tokenSent<=teamInfo[_beneficiary].tokensAlloted,"token sent is higher than quater 1 expected");
          teamInfo[_beneficiary].availedQuaterOne = true;
          require(_token.transfer(_beneficiary, quaterTokens),"token transfer failed");


      }else if (_quater == 2) // 2nd quater 25%
      {

          quaterTokens = teamInfo[_beneficiary].tokensAlloted.div(4);

          require(now>=teamInfo[_beneficiary].timeAtAllocation.add(15552000).add(twoYearsTime),"time for quater 2 is not complete");
          require(teamInfo[_beneficiary].availedQuaterTwo == false);
          
          teamInfo[_beneficiary].tokenSent = quaterTokens.mul(2);
          teamInfo[_beneficiary].tokensLeft = quaterTokens.mul(2);
          require(teamInfo[_beneficiary].tokenSent <= teamInfo[_beneficiary].tokensAlloted,"token sent is higher");
          teamInfo[_beneficiary].availedQuaterTwo = true;
          require(_token.transfer(_beneficiary, quaterTokens));


      }else if (_quater == 3) // 3rd quater 25%
      {

          quaterTokens = teamInfo[_beneficiary].tokensAlloted.div(4);

          require(now>=teamInfo[_beneficiary].timeAtAllocation.add(23328000).add(twoYearsTime),"time not completed yet");
          require(teamInfo[_beneficiary].availedQuaterThree == false);
          
          teamInfo[_beneficiary].tokenSent = quaterTokens.mul(3);
          teamInfo[_beneficiary].tokensLeft = quaterTokens;
          require(teamInfo[_beneficiary].tokenSent<=teamInfo[_beneficiary].tokensAlloted,"token sent is higher");
          teamInfo[_beneficiary].availedQuaterThree = true;
          require(_token.transfer(_beneficiary, quaterTokens));

          
      }else if (_quater == 4) // 4th quater 25%
      {

          quaterTokens = teamInfo[_beneficiary].tokensAlloted.div(4);

          require(now>=teamInfo[_beneficiary].timeAtAllocation.add(31104000).add(twoYearsTime));
          require(teamInfo[_beneficiary].availedQuaterFour == false);
          
          teamInfo[_beneficiary].tokenSent = quaterTokens.mul(4);
          teamInfo[_beneficiary].tokensLeft = 0;
          require(teamInfo[_beneficiary].tokenSent<=teamInfo[_beneficiary].tokensAlloted);
          teamInfo[_beneficiary].availedQuaterFour == true;
          require(_token.transfer(_beneficiary, quaterTokens));
          
      }else {

          revert();

      }
  }


  function releasebusinessTokens (address _beneficiary) onlyOwner external {
      
      require(_beneficiary != address(0));
      require(now>=businessTokensAllotedTime[_beneficiary].add(15552000),"time is not complete");
      require(businessTokensAlloted[_beneficiary] != 0,"business tokens alloted is zero");
      require(businessTokensReleased[_beneficiary]==false," Tokens are already released ");
      businessTokensReleased[_beneficiary]==true;
      require(_token.transfer(_beneficiary, businessTokensAlloted[_beneficiary]),"transfer fails");

      }


    function releaseContentTokens (address _beneficiary, uint256 _quater) onlyOwner external {
      

      require(_beneficiary != address(0));
      require(contentContributionInfo[_beneficiary].beneficiaryAddress != address(0x0),"beneficiary is not a member");

      uint256 tenPercentTokens;

      if(_quater == 1) //1st quater (3-6) 10%
      {

          require(contentContributionInfo[_beneficiary].tokenSent == 0,"token already sent");
          require(now>=contentContributionInfo[_beneficiary].timeAtAllocation.add(7776000),"time is not complete");
          require(contentContributionInfo[_beneficiary].quaterAvaild[1] ==  false,"quater 1 tokens already availed");
          
          tenPercentTokens = contentContributionInfo[_beneficiary].tokensAlloted.div(10);
          
          contentContributionInfo[_beneficiary].tokenSent = tenPercentTokens;
          contentContributionInfo[_beneficiary].tokensLeft = contentContributionInfo[_beneficiary].tokensAlloted.sub(tenPercentTokens);
          require(contentContributionInfo[_beneficiary].tokenSent<=contentContributionInfo[_beneficiary].tokensAlloted,"token sent is higher than token availed");
          contentContributionInfo[_beneficiary].quaterAvaild[1] =  true;
          require(_token.transfer(_beneficiary, tenPercentTokens),"token transfer failed");


      }else if (_quater == 2) // 2nd quater (6-9)10%
      {


          require(now>=contentContributionInfo[_beneficiary].timeAtAllocation.add(15552000));
          require(contentContributionInfo[_beneficiary].quaterAvaild[2] ==  false);
          
          tenPercentTokens = contentContributionInfo[_beneficiary].tokensAlloted.div(10);
          
          contentContributionInfo[_beneficiary].tokenSent = contentContributionInfo[_beneficiary].tokenSent.add(tenPercentTokens);
          contentContributionInfo[_beneficiary].tokensLeft = contentContributionInfo[_beneficiary].tokensAlloted.sub(tenPercentTokens.mul(2));
          require(contentContributionInfo[_beneficiary].tokenSent<=contentContributionInfo[_beneficiary].tokensAlloted);
          contentContributionInfo[_beneficiary].quaterAvaild[2] =  true;

          require(_token.transfer(_beneficiary, tenPercentTokens));



      }else if (_quater == 3) // 3rd quater 10%
      {

          require(now>=contentContributionInfo[_beneficiary].timeAtAllocation.add(23328000));
          require(contentContributionInfo[_beneficiary].quaterAvaild[3] ==  false);
          
          tenPercentTokens = contentContributionInfo[_beneficiary].tokensAlloted.div(10);
          
          contentContributionInfo[_beneficiary].tokenSent = contentContributionInfo[_beneficiary].tokenSent.add(tenPercentTokens);
          contentContributionInfo[_beneficiary].tokensLeft = contentContributionInfo[_beneficiary].tokensAlloted.sub(tenPercentTokens.mul(3));
          require(contentContributionInfo[_beneficiary].tokenSent<=contentContributionInfo[_beneficiary].tokensAlloted);
          contentContributionInfo[_beneficiary].quaterAvaild[3] =  true;

          require(_token.transfer(_beneficiary, tenPercentTokens));
  
      }else if (_quater == 4) // 4th quater (12-15)10%
      {

          require(now>=contentContributionInfo[_beneficiary].timeAtAllocation.add(31104000));
          require(contentContributionInfo[_beneficiary].quaterAvaild[4] ==  false);
          
          tenPercentTokens = contentContributionInfo[_beneficiary].tokensAlloted.div(10);
          
          contentContributionInfo[_beneficiary].tokenSent = contentContributionInfo[_beneficiary].tokenSent.add(tenPercentTokens);
          contentContributionInfo[_beneficiary].tokensLeft = contentContributionInfo[_beneficiary].tokensAlloted.sub(tenPercentTokens.mul(4));
          require(contentContributionInfo[_beneficiary].tokenSent<=contentContributionInfo[_beneficiary].tokensAlloted);
          contentContributionInfo[_beneficiary].quaterAvaild[4] =  true;

          require(_token.transfer(_beneficiary, tenPercentTokens));

          
      }else if (_quater == 5) // 5th quater (15-18)10%
      {

          require(now>=contentContributionInfo[_beneficiary].timeAtAllocation.add(38880000));
          require(contentContributionInfo[_beneficiary].quaterAvaild[5] ==  false);
          
          tenPercentTokens = contentContributionInfo[_beneficiary].tokensAlloted.div(10);
          
          contentContributionInfo[_beneficiary].tokenSent = contentContributionInfo[_beneficiary].tokenSent.add(tenPercentTokens);
          contentContributionInfo[_beneficiary].tokensLeft = contentContributionInfo[_beneficiary].tokensAlloted.sub(tenPercentTokens.mul(5));
          require(contentContributionInfo[_beneficiary].tokenSent<=contentContributionInfo[_beneficiary].tokensAlloted);
          contentContributionInfo[_beneficiary].quaterAvaild[5] =  true;

          require(_token.transfer(_beneficiary, tenPercentTokens));
          
      }else if (_quater == 6) // 6th quater (18-21)10%
      {

          require(now>=contentContributionInfo[_beneficiary].timeAtAllocation.add(41472000));
          require(contentContributionInfo[_beneficiary].quaterAvaild[6] ==  false);
          
          tenPercentTokens = contentContributionInfo[_beneficiary].tokensAlloted.div(10);
          
          contentContributionInfo[_beneficiary].tokenSent = contentContributionInfo[_beneficiary].tokenSent.add(tenPercentTokens);
          contentContributionInfo[_beneficiary].tokensLeft = contentContributionInfo[_beneficiary].tokensAlloted.sub(tenPercentTokens.mul(6));
          require(contentContributionInfo[_beneficiary].tokenSent<=contentContributionInfo[_beneficiary].tokensAlloted);
          contentContributionInfo[_beneficiary].quaterAvaild[6] =  true;

          require(_token.transfer(_beneficiary, tenPercentTokens));
          
      }else if (_quater == 7) // 7th quater (21-24) 10%
      {

          require(now>=contentContributionInfo[_beneficiary].timeAtAllocation.add(46656000));
          require(contentContributionInfo[_beneficiary].quaterAvaild[7] ==  false);
          
          tenPercentTokens = contentContributionInfo[_beneficiary].tokensAlloted.div(10);
          
          contentContributionInfo[_beneficiary].tokenSent = contentContributionInfo[_beneficiary].tokenSent.add(tenPercentTokens);
          contentContributionInfo[_beneficiary].tokensLeft = contentContributionInfo[_beneficiary].tokensAlloted.sub(tenPercentTokens.mul(7));
          require(contentContributionInfo[_beneficiary].tokenSent<=contentContributionInfo[_beneficiary].tokensAlloted);
          contentContributionInfo[_beneficiary].quaterAvaild[7] =  true;

          require(_token.transfer(_beneficiary, tenPercentTokens));
          
      }else if (_quater == 8) //8th quater 10% 
      {

          require(now>=contentContributionInfo[_beneficiary].timeAtAllocation.add(54432000));
          require(contentContributionInfo[_beneficiary].quaterAvaild[8] ==  false);
          
          tenPercentTokens = contentContributionInfo[_beneficiary].tokensAlloted.div(10);
          
          contentContributionInfo[_beneficiary].tokenSent = contentContributionInfo[_beneficiary].tokenSent.add(tenPercentTokens);
          contentContributionInfo[_beneficiary].tokensLeft = contentContributionInfo[_beneficiary].tokensAlloted.sub(tenPercentTokens.mul(8));
          require(contentContributionInfo[_beneficiary].tokenSent<=contentContributionInfo[_beneficiary].tokensAlloted);
          contentContributionInfo[_beneficiary].quaterAvaild[8] =  true;

          require(_token.transfer(_beneficiary, tenPercentTokens));

          
      }else if (_quater == 9) //9th quater 10% 
      {

          require(now>=contentContributionInfo[_beneficiary].timeAtAllocation.add(62208000));
          require(contentContributionInfo[_beneficiary].quaterAvaild[9] ==  false);
          
          tenPercentTokens = contentContributionInfo[_beneficiary].tokensAlloted.div(10);
          
          contentContributionInfo[_beneficiary].tokenSent = contentContributionInfo[_beneficiary].tokenSent.add(tenPercentTokens);
          contentContributionInfo[_beneficiary].tokensLeft = contentContributionInfo[_beneficiary].tokensAlloted.sub(tenPercentTokens.mul(9));
          require(contentContributionInfo[_beneficiary].tokenSent<=contentContributionInfo[_beneficiary].tokensAlloted);
          contentContributionInfo[_beneficiary].quaterAvaild[9] =  true;

          require(_token.transfer(_beneficiary, tenPercentTokens));
      
      }else if (_quater == 10) //10th quater 10% 
      {

          require(now>=contentContributionInfo[_beneficiary].timeAtAllocation.add(69984000));
          require(contentContributionInfo[_beneficiary].quaterAvaild[10] ==  false);
          
          tenPercentTokens = contentContributionInfo[_beneficiary].tokensAlloted.div(10);
          
          contentContributionInfo[_beneficiary].tokenSent = contentContributionInfo[_beneficiary].tokenSent.add(tenPercentTokens);
          contentContributionInfo[_beneficiary].tokensLeft = contentContributionInfo[_beneficiary].tokensAlloted.sub(tenPercentTokens.mul(10));
          require(contentContributionInfo[_beneficiary].tokenSent == contentContributionInfo[_beneficiary].tokensAlloted);
          contentContributionInfo[_beneficiary].quaterAvaild[10] =  true;

          require(_token.transfer(_beneficiary, tenPercentTokens));
          
      }else {

          revert();

      }
  }

    function transferAnyERC20Token(address tokenAddress, uint tokens) external onlyOwner returns (bool success) {
        require(tokenAddress != address(0));

        return _token.transfer(msg.sender, tokens);
    }
    
    
}

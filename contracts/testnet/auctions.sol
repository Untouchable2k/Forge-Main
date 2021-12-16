//                        //MAKE SURE TO CHANGE TO REGULAR BLOCK TIMES 36 * 60 MAKE SURE TO CHANGE

//  Auctions Contract
//TESTNET MODE!!! MUST CHANGE THE Daily Time!! Current Days are 30 seconds long for testing!!
//   Auctions 8,192 tokens every 3 days and users are able to withdraw anytime after!

//   All proceeds of auctions go back into the miners pockets, by going directly to the Proof of Work Contract!

// 10,500,000 tokens are Auctioned off over 100 years in this contract! In the first era ~5,250,000 are auctioned and half every era after!

//   Distributes 8,192 tokens every 3 days for the first era(5 years) and halves every era after

// By sending Fantom (FTM) directly to this contract and recieve your share of the 8,192 tokens auctioned every 3 days!


pragma solidity ^0.8.0;

contract Ownabled {
    address public owner22;
    event TransferOwnership(address _from, address _to);

    constructor() public {
        owner22 = msg.sender;
        emit TransferOwnership(address(0), msg.sender);
    }

    modifier onlyOwner22() {
        require(msg.sender == owner22, "only owner");
        _;
    }
    function setOwner22(address _owner22) external onlyOwner22 {
        emit TransferOwnership(owner22, _owner22);
        owner22 = _owner22;
    }
}

library SafeMath {
    function add(uint256 x, uint256 y) internal pure returns (uint256) {
        uint256 z = x + y;
        require(z >= x, "Add overflow");
        return z;
    }

    function sub(uint256 x, uint256 y) internal pure returns (uint256) {
        require(x >= y, "Sub underflow");
        return x - y;
    }

    function mult(uint256 x, uint256 y) internal pure returns (uint256) {
        if (x == 0) {
            return 0;
        }

        uint256 z = x * y;
        require(z / x == y, "Mult overflow");
        return z;
    }

    function div(uint256 x, uint256 y) internal pure returns (uint256) {
        require(y != 0, "Div by zero");
        return x / y;
    }

    function divRound(uint256 x, uint256 y) internal pure returns (uint256) {
        require(y != 0, "Div by zero");
        uint256 r = x / y;
        if (x % y != 0) {
            r = r + 1;
        }

        return r;
    }
}

library ExtendedMath {


    //return the smaller of the two inputs (a or b)
    function limitLessThan(uint a, uint b) internal pure returns (uint c) {

        if(a > b) return b;

        return a;

    }
}
interface IERC20 {

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
   
    
}

contract GasPump {
    bytes32 private stub;

    modifier requestGas(uint256 _factor) {
        if (tx.gasprice == 0 || gasleft() > block.gaslimit) {
            uint256 startgas = gasleft();
            _;
            uint256 delta = startgas - gasleft();
            uint256 target = (delta * _factor) / 100;
            startgas = gasleft();
            while (startgas - gasleft() < target) {
                // Burn gas
                stub = keccak256(abi.encodePacked(stub));
            }
        } else {
            _;
        }
    }
}

contract ProofOfWork{
    function getEpoch() public view returns (uint) {}
    }

  contract Auctions is  GasPump, IERC20, Ownabled
{
    using SafeMath for uint;
    using ExtendedMath for uint;
    address public ZeroXBTCAddress;
    // ERC-20 Parameters
    uint256 public extraGas;
    bool runonce = false;
    uint256 oneEthUnit = 1000000000000000000; 
    uint256 one0xBTCUnit =         100000000;
    string public name; string public symbol; address public rewardTokenContract;
    uint public decimals;

    // ERC-20 Mappings
    mapping(address => uint) private _balances;
    mapping(address => mapping(address => uint)) private _allowances;

    // Public Parameters
    uint public coin; uint public emission;
    uint public currentEra; uint public currentDay;
    uint public daysPerEra; uint public secondsPerDay;
    uint public upgradeHeight; uint public upgradedAmount;
    uint public genesis; uint public nextEraTime; uint public nextDayTime;
    address public burnAddress; address deployer;
    uint public totalFees; uint public totalBurnt; uint public totalEmitted;
    address[] public excludedArray; uint public excludedCount;
    // Public Mappings
    
    mapping(uint=>uint) public mapEra_Emission;                                             // Era->Emission
    mapping(uint=>mapping(uint=>uint)) public mapEraDay_MemberCount;                        // Era,Days->MemberCount
    mapping(uint=>mapping(uint=>address[])) public mapEraDay_Members;                       // Era,Days->Members
    mapping(uint=>mapping(uint=>uint)) public mapEraDay_Units;                              // Era,Days->Units
    mapping(uint=>mapping(uint=>uint)) public mapEraDay_UnitsRemaining;                     // Era,Days->TotalUnits
    mapping(uint=>mapping(uint=>uint)) public mapEraDay_EmissionRemaining;                  // Era,Days->Emission
    mapping(uint=>mapping(uint=>mapping(address=>uint))) public mapEraDay_MemberUnits;      // Era,Days,Member->Units
    mapping(address=>mapping(uint=>uint[])) public mapMemberEra_Days;                       // Member,Era->Days[]
    mapping(address=>bool) public mapAddress_Excluded;     
    ProofOfWork pow;
    // fee whitelist
    mapping(address => bool) public whitelistFrom;
    mapping(address => bool) public whitelistTo;
    // Address->Excluded
    event WhitelistFrom(address _addr, bool _whitelisted);
    event WhitelistTo(address _addr, bool _whitelisted);
    // Events
        event SetExtraGas(uint256 _prev, uint256 _new);
    event NewEra(uint era, uint emission, uint time, uint totalBurnt);
    event NewDay(uint era, uint day, uint time, uint previousDayTotal, uint previousDayMembers);
    event Burn(address indexed payer, address indexed member, uint era, uint day, uint units, uint dailyTotal);
    //event transferFrom2(address a, address _member, uint value);
    event Withdrawal(address indexed caller, address indexed member, uint era, uint day, uint value, uint vetherRemaining);
    //ProofofWorkStuff
    uint256 starttime = 0;
    uint256 public lastepoch = 0;
    uint256 public blocktime = 36 * 60; //36 min blocks in ProofOfWork
    uint256 public epochPer3Day = 60 * 60 * 24 * 3 / (blocktime); //120 blocks per auction
    //=====================================CREATION=========================================//

    //testing//

    uint256 public bug1=0;
    address public bug2;
    address public bug3;
    // Constructor
    constructor () public {
        upgradeHeight = 1; 
        name = "Auction Contract"; symbol = "BID"; decimals = 18; 
        coin = 10**decimals; 
        genesis = block.timestamp; emission = 2048*coin;
        currentEra = 1; currentDay = upgradeHeight; 
        daysPerEra = 600; secondsPerDay = 30; // MUST REMOVE 30 AND KEEP -> 60*60*24*3; //   = 155,520,000 seconds per era = 5 years 3 day auctions
        totalBurnt = 0; totalFees = 0;
        totalEmitted = (upgradeHeight-1)*emission;
        burnAddress = 0x0111011001100001011011000111010101100101; deployer = msg.sender;
        nextEraTime = genesis + (secondsPerDay * daysPerEra);
        nextDayTime = block.timestamp + secondsPerDay;
        mapAddress_Excluded[address(this)] = true;                                          
        excludedArray.push(address(this)); excludedCount = 1;                               
        mapAddress_Excluded[burnAddress] = true;
        excludedArray.push(burnAddress); excludedCount +=1; 
        mapEra_Emission[currentEra] = emission; 
        mapEraDay_EmissionRemaining[currentEra][currentDay] = emission; 
                                                              
    }
    
    
    
    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }


    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }
    // ERC20 Transfer function
    function transfer(address to, uint value) public override returns (bool success) {
        _transfer(msg.sender, to, value);
        return true;
    }
    // ERC20 Approve function
    function approve(address spender, uint value) public override returns (bool success) {
        _allowances[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }
    // ERC20 TransferFrom function
    function transferFrom(address from, address to, uint value) public override returns (bool success) {
        require(value <= _allowances[from][msg.sender], 'Must not send more than allowance');
        _allowances[from][msg.sender] = _allowances[from][msg.sender].sub(value);
        _transfer(from, to, value);
        return true;
    }
    

    // Internal transfer function which includes the Fee
    function _transfer(address _from, address _to, uint _value) private {
        require(_balances[_from] >= _value, 'Must not send more than balance');
        require(_balances[_to] + _value >= _balances[_to], 'Balance overflow');
        _balances[_from] =_balances[_from].sub(_value);                                          // Get fee amount
        _balances[_to] += (_value);                                               // Add to receiver
                                              // Add fee to self
                                              // Track fees collected
        emit Transfer(_from, _to, (_value));                                      // Transfer event
    }
    


        function SetUP1(address token, address _ZeroXBTCAddress) public onlyOwner22 {
        rewardTokenContract = token;
        burnAddress = rewardTokenContract;
        owner22 = address(0);
        lastepoch =  0;
        ZeroXBTCAddress = _ZeroXBTCAddress;
        pow = ProofOfWork(token);
        lastepoch = pow.getEpoch();
        starttime = block.timestamp;

    }


    function changeAuctionTime() internal {
        uint256 epoch = pow.getEpoch();
        uint256 daysLeft = daysPerEra - currentDay;
        if(daysLeft > 0)
        {


             uint epochsMined = (epoch - lastepoch); 
            if(epochsMined != 0)
            {
             uint targetTime = 36*60; //36 min per block 60 sec * 12
             uint ethBlocksSinceLastDifficultyPeriod2 = epochsMined * targetTime;

            if( ethBlocksSinceLastDifficultyPeriod2 < secondsPerDay )
            {
                uint excess_block_pct = (secondsPerDay.mult(100)).div( ethBlocksSinceLastDifficultyPeriod2 );

                 uint excess_block_pct_extra = excess_block_pct.sub(100).limitLessThan(1000);
          // If there were 5% more blocks mined than expected then this is 5.  If there were 100% more blocks mined than expected then this is 100.

          //make it harder
                  secondsPerDay = secondsPerDay.add(secondsPerDay.mult(excess_block_pct_extra).div(2000));   //by up to 50 %
             }else{
                 uint shortage_block_pct = (ethBlocksSinceLastDifficultyPeriod2.mult(100)).div( secondsPerDay );

                 uint shortage_block_pct_extra = shortage_block_pct.sub(100).limitLessThan(1000); //always between 0 and 1000

                 //make it easier
                secondsPerDay = secondsPerDay.sub(secondsPerDay.mult(shortage_block_pct_extra).div(2000));   //by up to 50 %
            }
            }else{
                secondsPerDay = secondsPerDay * 2;
            }
            if(secondsPerDay <= 5)
            {
                secondsPerDay == 10;
            }

        lastepoch = epoch;
        starttime = block.timestamp;
    }
    }

    //==================================AUCTIONEER======================================//

    // Calls when sending Fantom


/*
    receive() external payable {
        burnFANTOMForMember(msg.sender);
    }
    */

    //fuction to get all the days bidders and attempt to cash them out


/*
function WIthdrawls for a previous day, all holders with over _percent starting at spot startdig(usually 0), and maxdig incase list grows large, Spots are the number to payout
good settings _percent=5, startdig=0, maxdig=10000(doesnt hurt if too big), spots=20, _percent=100% (meaning anyone with 1% of the pot gets rewards)
*/



    function superEZBid(uint256 total) public returns (bool success)
    {
        uint256 daysleft = daysPerEra - currentDay - 1 ;//just incase
        require(easyBid(total, daysleft));
    }



    function easyBid(uint256 total, uint256 _days) public returns (bool success) {

    
        require(futurebidder(msg.sender, currentEra, currentDay, _days, total));
        return true;

    }

    function futurebidder(address member, uint256 era, uint256 startingday, uint256 daystobid, uint256 amtTotal) public returns (bool success)
    {
        require((startingday + daystobid) < daysPerEra, "WE ONLY HAVE SO MANY DAYS");
        require(startingday >= currentDay, "Must not bid behind the days");
        require(era >= currentEra, "no knucklehead");
        require((amtTotal/daystobid) > (one0xBTCUnit/(era)/3), "0.333 0xBitcoin per Day required, sendmore");
        require(IERC20(ZeroXBTCAddress).transferFrom(msg.sender, burnAddress, amtTotal), "NO WAY");
        uint256 amt = amtTotal/daystobid;
        for(uint256 x=startingday; x< (startingday + daystobid); x++)
        {
            _recordBurn(msg.sender, member, era, x, amt);          
        }
        return true;
    }




    function burn0xBTCForMember(address member, uint256 amt) public  {

        
        //address payable receive21r = payable(burnAddress);
        require(IERC20(ZeroXBTCAddress).transferFrom(msg.sender, burnAddress, amt), "NO WAY");
        //receive21r.call{value:msg.value}("");
        //receive21r.send(msg.value);
        


        _recordBurn(msg.sender, member, currentEra, currentDay, amt);
            
}
/*
    function burnFANTOMForMember(address member) public payable requestGas(extraGas)  {
        
        address payable receive21r = payable(burnAddress);
        
        receive21r.call{value:msg.value}("");
        //receive21r.send(msg.value);
        
        _recordBurn(msg.sender, member, currentEra, currentDay, msg.value);
            
}
*/
    
    
    // Internal - Withdrawal function
    
    // Internal - Records burn
    function _recordBurn(address _payer, address _member, uint _era, uint _day, uint _eth) private {
        if (mapEraDay_MemberUnits[_era][_day][_member] == 0){                               // If hasn't contributed to this Day yet
            mapMemberEra_Days[_member][_era].push(_day);                                    // Add it
            mapEraDay_MemberCount[_era][_day] += 1;                                         // Count member
            mapEraDay_Members[_era][_day].push(_member);                                    // Add member
        }
        mapEraDay_MemberUnits[_era][_day][_member] += _eth;                                 // Add member's share
        mapEraDay_UnitsRemaining[_era][_day] += _eth;                                       // Add to total historicals
        mapEraDay_Units[_era][_day] += _eth;                                                // Add to total outstanding
        totalBurnt += _eth;                                                                 // Add to total burnt
        emit Burn(_payer, _member, _era, _day, _eth, mapEraDay_Units[_era][_day]);          // Burn event
        _updateEmission();                                                                  // Update emission Schedule
    }
    
        //======================================WITHDRAWAL======================================//
    // Used to efficiently track participation in each era
    function getDaysContributedForEra(address member, uint era) public view returns(uint){
        return mapMemberEra_Days[member][era].length;
    }
    // Call to withdraw a claim
    function withdrawShare(uint era, uint day) external returns (uint value) {
        uint memberUnits = mapEraDay_MemberUnits[era][day][msg.sender];  
        assert (memberUnits != 0); // Get Member Units
        value = _withdrawShare(era, day, msg.sender);
    }
    // Call to withdraw a claim for another member
    function withdrawShareForMember(uint era, uint day, address member) public returns (uint value) {
        uint memberUnits = mapEraDay_MemberUnits[era][day][member];  
        assert (memberUnits != 0); // Get Member Units
        value = _withdrawShare(era, day, member);
        return value;
    }
    // Internal - withdraw function
    function _withdrawShare (uint _era, uint _day, address _member) private returns (uint value) {
        _updateEmission(); 
        if (_era < currentEra) {                                                            // Allow if in previous Era
            value = _processWithdrawal(_era, _day, _member);                                // Process Withdrawal
        } else if (_era == currentEra) {                                                    // Handle if in current Era
            if (_day < currentDay) {                                                        // Allow only if in previous Day
                value = _processWithdrawal(_era, _day, _member);                            // Process Withdrawal
            }
        }  
        return value;
    }
    
    
    function _processWithdrawal (uint _era, uint _day, address _member) private returns (uint value) {
        uint memberUnits = mapEraDay_MemberUnits[_era][_day][_member];                      // Get Member Units
        if (memberUnits == 0) { 
            value = 0;                                                                      // Do nothing if 0 (prevents revert)
        } else {
            value = getEmissionShare(_era, _day, _member);                                  // Get the emission Share for Member
            mapEraDay_MemberUnits[_era][_day][_member] = 0;                                 // Set to 0 since it will be withdrawn
            mapEraDay_UnitsRemaining[_era][_day] = mapEraDay_UnitsRemaining[_era][_day].sub(memberUnits);  // Decrement Member Units
            mapEraDay_EmissionRemaining[_era][_day] = mapEraDay_EmissionRemaining[_era][_day].sub(value);  // Decrement emission
            totalEmitted += value;            
            emit Withdrawal(msg.sender, _member, _era, _day, value, mapEraDay_EmissionRemaining[_era][_day]);
            
            // ERC20 transfer function
            IERC20(rewardTokenContract).transfer(_member, value*4); // 8,192 tokens a auction aka almost half the supply an era!
        }
        return value;
    }
    
    
    function getEmissionShare(uint era, uint day, address member) public view returns (uint value) {
        uint memberUnits = mapEraDay_MemberUnits[era][day][member];                         // Get Member Units
        if (memberUnits == 0) {
            return 0;                                                                       // If 0, return 0
        } else {
            uint totalUnits = mapEraDay_UnitsRemaining[era][day];                           // Get Total Units
            uint emissionRemaining = mapEraDay_EmissionRemaining[era][day];                 // Get emission remaining for Day
            uint balance = IERC20(rewardTokenContract).balanceOf(address(this));                                      // Find remaining balance
            if (emissionRemaining > balance) { emissionRemaining = balance; }               // In case less than required emission
            value = (emissionRemaining * memberUnits) / totalUnits;                         // Calculate share
            return  value;                            
        }
    }
    //======================================EMISSION========================================//
    // Internal - Update emission function
    function _updateEmission() private {
        uint _now = block.timestamp;                                                                    // Find now()
        if (_now >= nextDayTime) {                                                          // If time passed the next Day time
            if (currentDay >= daysPerEra) {                                                 // If time passed the next Era time
                currentEra += 1; currentDay = 0;                                            // Increment Era, reset Day
                nextEraTime = _now + (secondsPerDay * daysPerEra);                          // Set next Era time
                emission = getNextEraEmission();                                            // Get correct emission
                mapEra_Emission[currentEra] = emission;                                     // Map emission to Era
                emit NewEra(currentEra, emission, nextEraTime, totalBurnt); 
            }
            changeAuctionTime();
            currentDay += 1;                                                                // Increment Day
            nextDayTime = _now + secondsPerDay;                                             // Set next Day time
            emission = getDayEmission();                                                    // Check daily Dmission
            mapEraDay_EmissionRemaining[currentEra][currentDay] = emission;                 // Map emission to Day
            uint _era = currentEra; uint _day = currentDay-1;
            if(currentDay == 1){ _era = currentEra-1; _day = daysPerEra; }                  // Handle New Era
            emit NewDay(currentEra, currentDay, nextDayTime, 
            mapEraDay_Units[_era][_day], mapEraDay_MemberCount[_era][_day]);
            
        }
    }
    // Calculate Era emission
    function getNextEraEmission() public view returns (uint) {
        if (emission > coin) {                                                              // Normal Emission Schedule
            return emission / 2;                                                            // Emissions: 2048 -> 1.0
        } else{                                                                             // Enters Fee Era
            return coin;                                                                    // Return 1.0 from fees
        }
    }
    // Calculate Day emission
    function getDayEmission() public view returns (uint) {
        uint balance = IERC20(rewardTokenContract).balanceOf(address(this));                                            // Find remaining balance
        if (balance > emission) {                                                           // Balance is sufficient
            return emission;                                                                // Return emission
        } else {                                                                            // Balance has dropped low
            return balance;                                                                 // Return full balance
        }
    }
    function transferERC20TokenToMinerContract(address tokenAddress, uint tokens) public returns (bool success) {
        require((tokenAddress != address(this)) && tokenAddress != rewardTokenContract);
        return IERC20(tokenAddress).transfer(rewardTokenContract, IERC20(tokenAddress).balanceOf(address(this))); 

    }
}

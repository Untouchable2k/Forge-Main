//FORGE ZAPs
//ZAP to Staking //Zap Out of Staking // Zap zap

pragma solidity ^0.8.0;

contract OwnableAndMods{
    address public owner;
    address [] public moderators;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        owner = msg.sender;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "Ownable: caller is not the owner");
        _;
    }
    modifier OnlyModerators() {
    bool isModerator = false;
    for(uint x=0; x< moderators.length; x++){
    	if(moderators[x] == msg.sender){
		isModerator = true;
		}
		}
        require(msg.sender == owner || isModerator, "Ownable: caller is not the owner/mod");
        _;
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
contract SwapRouter {
    function swapExactTokensForTokens(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external returns (uint[] memory amounts){}
    function swapExactETHForTokens(uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external payable returns (uint[] memory amounts){}
   function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity){
    }
}
contract LiquidityPool{
    function getReserves() public returns (uint112, uint112, uint32) {}
    function getMiningReward() public view returns (uint) {}
    }
contract ForgeAuctions{
    mapping(uint=>mapping(uint=>uint)) public mapEraDay_Units;  
    uint public currentDay;
    uint public currentEra;
    uint public daysPerEra; 
    uint public secondsPerDay;
    uint public nextDayTime;
    function getMiningMinted() public view returns (uint) {}
    function WithdrawEz(address) public {}
    function FutureBurn0xBTCArrays(uint , uint[] memory , address, uint[] memory ) public payable returns (bool) {}
    function FutureBurn0xBTCEasier(uint, uint, uint, address , uint ) public payable returns (bool) {}
    function WholeEraBurn0xBTCForMember(address, uint256) public payable returns (bool){}
    function burn0xBTCForMember(address, uint256) public payable  {}
    }
contract ForgeStaking{
    function stakeFor(address forWhom, uint256 amount) public payable virtual {}
    function getMiningReward() public view returns (uint) {}
    }

  contract ForgeZap is  GasPump, OwnableAndMods
{
    
    using SafeMath for uint;
    using ExtendedMath for uint;
    address public AddressZeroXBTC;
    address public AddressForgeToken;
    // ERC-20 Parameters
    uint256 public extraGas;
    bool runonce = false;
    uint256 oneEthUnit = 1000000000000000000; 
    uint256 one0xBTCUnit =         100000000;
    string public name;
    uint public decimals;

    // ERC-20 Mappings
    mapping(address => uint) private _balances;
    mapping(address => mapping(address => uint)) private _allowances;

    uint256 public Total0xBTCToRecieve = 0;
     uint256 public sixsevenths = 0;
    // Public Parameters
     uint public timescalled;
    uint256 public amountZapped; uint public currentDay;
    uint public daysPerEra; uint public secondsPerDay;
    uint public nextDayTime;
    uint public totalBurnt; uint public totalEmitted; uint public TotalForgeToRecieve;
    // Public Mappings
    address AddressUSDC;
    address AddressMatic;
    address AddressLP3;
    address AddressStake;

    SwapRouter Quickswap;
    ForgeAuctions Forge_Auction;
    ForgeStaking Forge_Staking;
    LiquidityPool LP3; //0xBTC/Polygon
    // Events
        event Zap(uint256 ZeroXBitcoinAmount, uint256 ForgeAmount);
        event Burn(uint256 totalburn, address burnedFor, uint TotalDaysBurned);
    //=====================================CREATION=========================================//

    //testing//

    // Constructor
    
      constructor()  {
        AddressForgeToken = address(0xF44fB43066F7ECC91058E3A614Fb8A15A2735276);
        AddressZeroXBTC = address(0x71B821aa52a49F32EEd535fCA6Eb5aa130085978);
        Forge_Auction = ForgeAuctions(0xBb1fA87A4738B22F7d2D5EC34bA349375B4D86F0);
        Quickswap = SwapRouter(0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff);
        LP3 = LiquidityPool(0x562322F8E7131D0bB9f487AE566935d3be96406B);
        AddressUSDC = address(0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174);
        AddressMatic = address(0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270);
        AddressLP3 = address(0x562322F8E7131D0bB9f487AE566935d3be96406B);
        AddressStake = address(0x7d28fa576a4e08922B01e897CE4f5517AD351578);
        Forge_Staking = ForgeStaking(0x7d28fa576a4e08922B01e897CE4f5517AD351578);
        // [0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270, 0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174, 0x71B821aa52a49F32EEd535fCA6Eb5aa130085978]
    }
//function ZeroxBTCToForge(uint256 amountIn0xBTC, uint256 haircut, address whoToStakeFor) public payable returns (bool success) {
function perfect (uint256 amt) public payable returns (bool success){
    //Get polygon
    //Trade polygon for 0xbtc
    //trade 1/2 0xbtc for forge
    //Add to LP
    //Stake
    //Return Leftovers
    ZeroxBTCToForge(2, 11 ); //Polygon to 0xBTC here even though it says different
    amt = IERC20(AddressZeroXBTC).balanceOf(address(this));
    uint256 amt2 = (amt / 2 * 1003)/1000;
    ZeroxBTCToForge(0, amt2); //0xBTC to Forge here
    LPandStake();
    IERC20(AddressZeroXBTC).transfer(msg.sender, IERC20(AddressZeroXBTC).balanceOf(address(this)));
    IERC20(AddressForgeToken).transfer(msg.sender, IERC20(AddressForgeToken).balanceOf(address(this)));
    return true;
}


function perfectLP (uint256 amt) public payable returns (bool success){
    //Get polygon
    //Trade polygon for 0xbtc
    //trade 1/2 0xbtc for forge
    //Add to LP
    //Stake
    //Return Leftovers
    require(IERC20(AddressForgeToken).approve(address(Quickswap), 100 * 10 ** 18), 'approve failed.');
        
    ZeroxBTCToForge(2, 11 ); //Polygon to 0xBTC here even though it says different
    amt = IERC20(AddressZeroXBTC).balanceOf(address(this));
    uint256 amt2 = (amt / 2 * 1003)/1000;
    ZeroxBTCToForge(0, amt2); //0xBTC to Forge here
    LP();
    //IERC20(AddressZeroXBTC).transfer(msg.sender, IERC20(AddressZeroXBTC).balanceOf(address(this)));
    //IERC20(AddressForgeToken).transfer(msg.sender, IERC20(AddressForgeToken).balanceOf(address(this)));
    return true;
}
function perfectNoStake (uint256 amt) public payable returns (bool success){
    //Get polygon
    //Trade polygon for 0xbtc
    //trade 1/2 0xbtc for forge
    //Add to LP
    //Stake
    //Return Leftovers
    require(IERC20(AddressForgeToken).approve(address(Quickswap), 100 * 10 ** 18), 'approve failed.');
        
    ZeroxBTCToForge(2, 11 ); //Polygon to 0xBTC here even though it says different
    amt = IERC20(AddressZeroXBTC).balanceOf(address(this));
    uint256 amt2 = (amt / 2 * 1003)/1000;
    ZeroxBTCToForge(0, amt2); //0xBTC to Forge here
    //LPandStake();
    IERC20(AddressZeroXBTC).transfer(msg.sender, IERC20(AddressZeroXBTC).balanceOf(address(this)));
    IERC20(AddressForgeToken).transfer(msg.sender, IERC20(AddressForgeToken).balanceOf(address(this)));
    return true;
}
function LPandStake() public returns (bool success){
        require(IERC20(AddressLP3).approve(AddressStake, 1000000000 * 10 ** 18), 'approve failed.');
    require(IERC20(AddressForgeToken).approve(address(Quickswap), 100 * 10 ** 18), 'approve failed.');
    require(IERC20(AddressZeroXBTC).approve(address(Quickswap), 100 * 10 ** 18), 'approve failed.');
        uint256 total0xBTCin = IERC20(AddressZeroXBTC).balanceOf(address(this));
        uint256 totalForgein = IERC20(AddressForgeToken).balanceOf(address(this));
        //call LP
        Quickswap.addLiquidity(AddressZeroXBTC, AddressForgeToken, total0xBTCin, totalForgein, 1, 1, address(this), block.timestamp + 1000);
        
        Forge_Staking.stakeFor(msg.sender, IERC20(AddressLP3).balanceOf(address(this)));
    return true;
    }

function LP() public returns (bool success){
    
    require(IERC20(AddressForgeToken).approve(address(Quickswap), 100 * 10 ** 18), 'approve failed.');
    require(IERC20(AddressZeroXBTC).approve(address(Quickswap), 100 * 10 ** 18), 'approve failed.');
        uint256 total0xBTCin = IERC20(AddressZeroXBTC).balanceOf(address(this));
        uint256 totalForgein = IERC20(AddressForgeToken).balanceOf(address(this));
        //call LP
        Quickswap.addLiquidity(AddressZeroXBTC, AddressForgeToken, total0xBTCin, totalForgein, 1, 1, address(this), block.timestamp + 1000);
        
    return true;
    }

function perfectONETEST (uint256 choice, uint256 amt) public payable returns (bool success){
       ZeroxBTCToForge(choice, amt);
    
    }
    
    
function ZeroxBTCToForge(uint choice, uint256 amountIn) public payable returns (bool success) {

    address[] memory path = new address[](2);
         if(choice == 2){
        path = new address[](3);
        path[0] = AddressMatic;
        path[1] = AddressUSDC;
        path[2] = AddressZeroXBTC;  // [0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270, 0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174, 0x71B821aa52a49F32EEd535fCA6Eb5aa130085978]
        PolygonTOZeroX(amountIn, 1, msg.sender, path);
        }else if(choice == 1){
        path[0] = AddressForgeToken;
        path[1] = AddressZeroXBTC;
        ForgeToZeroXBTC(amountIn, 1, msg.sender, path);
        }else{
        path[0] = AddressZeroXBTC;
        path[1] = AddressForgeToken;
        ZeroxBTCToForge2(amountIn, 1, msg.sender, path);
        }
}
  
  
function PolygonTOZeroX(uint256 amountInPolygon, int256 haircut, address whoToStakeFor, address[] memory path) public payable returns (bool success) {
	//haircut is what % we will loose in a trade if someone frontruns set at 97% in contract now change for public
         SwapRouter(address(Quickswap)).swapExactETHForTokens{value: msg.value}(1, path,  address(this), block.timestamp + 10000);
        //forgeZAP(startBalForge, path, startBal0xBTC,  whoToStakeFor);
    return true;
    }
function ForgeToZeroXBTC(uint256 amountInForge, uint256 haircut, address whoToStakeFor, address[] memory path) public payable returns (bool success) {
	//haircut is what % we will loose in a trade if someone frontruns set at 97% in contract now change for public
         require(IERC20(AddressForgeToken).approve(address(Quickswap), 100 * 10 ** 18), 'approve failed.');
         SwapRouter(address(Quickswap)).swapExactTokensForTokens(amountInForge, 1, path, address(this), block.timestamp); //swap to Forge from 0xBTC
        //forgeZAP(startBalForge, path, startBal0xBTC,  whoToStakeFor);
    return true;
    }

function ZeroxBTCToForge2(uint256 amountIn0xBTC, uint256 haircut, address whoToStakeFor, address[] memory path) public payable returns (bool success) {
	//haircut is what % we will loose in a trade if someone frontruns set at 97% in contract now change for public
        require(IERC20(AddressZeroXBTC).approve(address(Quickswap), 100 * 10 ** 18), 'approve failed.');
         SwapRouter(address(Quickswap)).swapExactTokensForTokens(amountIn0xBTC, 1, path, address(this), block.timestamp); //swap to Forge from 0xBTC
        //forgeZAP(startBalForge, path, startBal0xBTC,  whoToStakeFor);
    return true;
    }


function OneTeste0(uint256 amountOutMin) public  {
require(IERC20(AddressForgeToken).transferFrom(msg.sender, address(this), IERC20(AddressForgeToken).balanceOf(msg.sender)), 'transferFrom2 failed.');
}

function OneTeste1(uint256 amountOutMin) public  {

            uint112 _reserve0; // 0xBTC ex 2 in getReserves
            uint112 _reserve1; // Forge
            uint32 _blockTimestampLast;
            (_reserve0, _reserve1, _blockTimestampLast) = LP3.getReserves(); //0xBTC/Forge

            uint256 maxAuc = 8192 * 10 ** 18;
            uint256 Total0xBTCToSend = (maxAuc * _reserve1) / ( _reserve0 + maxAuc);
            uint256 Total0xBTCToRec = Total0xBTCToSend * 95 / 100; //Must get 90% possibly let this be passed as haircut
                        
            }

function OneTeste32(uint256 amountOutMin) public  {
require(IERC20(AddressForgeToken).transferFrom(msg.sender, address(this), 100000000000000), 'transferFrom2 failed.');
    
require(IERC20(AddressForgeToken).approve(address(Quickswap), 100 * 10 ** 18), 'approve failed.');
address[] memory path = new address[](2);
path[0] = AddressForgeToken;
path[1] = AddressZeroXBTC;
SwapRouter(address(Quickswap)).swapExactTokensForTokens(100000000000000, 1, path, msg.sender, 99999999999999999999);
}
    

function OneTeste2(uint256 amountOutMin) public  {
address[] memory path = new address[](2);
path[0] = AddressForgeToken;
path[1] = AddressZeroXBTC;
SwapRouter(Quickswap).swapExactTokensForTokens(IERC20(AddressZeroXBTC).balanceOf(msg.sender) / 1000, 1, path, 0xbb3a3D4A665Ab4E9D5594077163C0044d1290699, 99999999999999999999);
}


    
    
        receive() external payable {

        perfect(msg.value);


    }
    
}

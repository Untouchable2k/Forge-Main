Skip to content
Search or jump to…
Pull requests
Issues
Marketplace
Explore
 
@CrazyCaptian 
CrazyCaptian
/
Forge-Main
Private
Code
Issues
Pull requests
Actions
Projects
Security
Insights
Settings
Forge-Main
/
update
/
auctions.sol
in
main
 

Spaces

4

No wrap
1
//  Forge Auctions Contract
2
//   Auctions 8,192 tokens every 3 days and users are able to withdraw anytime after!
3
​
4
//   Proceeds of auctions go back into the miners pockets, by going directly to the Proof of Work Contract!
5
​
6
// 10,500,000 tokens are Auctioned off over 100 years in this contract! In the first era ~5,000,000 are auctioned and half every era after!
7
​
8
//   Distributes 8,192 tokens every 3 days for the first era(5 years) and halves every era after
9
​
10
// By using the burn0xBTCForMember function
11
//       0xBitcoin Token is taken from the user and used to recieve your share of the 8,192 tokens auctioned every 3 days which varies with Forge epoch speeds!  
12
​
13
​
14
pragma solidity ^0.8.0;
15
​
16
contract Ownabled {
17
    address public owner22;
18
    event TransferOwnership(address _from, address _to);
19
​
20
    constructor() public {
21
        owner22 = msg.sender;
22
        emit TransferOwnership(address(0), msg.sender);
23
    }
24
​
25
    modifier onlyOwner22() {
26
        require(msg.sender == owner22, "only owner");
27
        _;
28
    }
29
    function setOwner22(address _owner22) external onlyOwner22 {
30
        emit TransferOwnership(owner22, _owner22);
31
        owner22 = _owner22;
32
    }
33
}
34
​
35
library SafeMath {
36
    function add(uint256 x, uint256 y) internal pure returns (uint256) {
37
        uint256 z = x + y;
38
        require(z >= x, "Add overflow");
39
        return z;
40
    }
41
​
42
    function sub(uint256 x, uint256 y) internal pure returns (uint256) {
43
        require(x >= y, "Sub underflow");
44
        return x - y;
45
    }

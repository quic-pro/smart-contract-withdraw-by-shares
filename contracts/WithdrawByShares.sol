// SPDX-License-Identifier: MIT


pragma solidity ^0.8.0;


import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";


contract WithdrawByShares is Ownable, ERC721 {
    using SafeMath for uint;


    struct Partner {
        address adr;
        uint weight;
    }
    

    uint public _numberOfTokens = 16;
    uint256 public _totalSupply = 0;
    uint public _price = 1 ether;

    Partner[] public _partners;


    constructor(string memory name_, string memory symbol_) ERC721(name_, symbol_) {}


    function setPartnerWeight(address address_, uint weight_) external onlyOwner {
        uint i = 0;
        while (i < _partners.length) {
            if (address_ == _partners[i].adr) {
                break;
            }
            i++;
        }

        if (i == _partners.length) {
            _partners.push(
                Partner(
                    address_, weight_
                )
            );
        }
        else {
            _partners[i].weight = weight_;
        }
    }

    function mint() public payable {
        require(_totalSupply < _numberOfTokens, "NFTs are out of stock!");
        require(msg.value >= _price, "Value sent is not correct!");

        _safeMint(msg.sender, _totalSupply);
        _totalSupply += 1;
    }

    function withdraw() external onlyOwner {
        uint balance =  address(this).balance;

        uint totalWeight = 0;
        for (uint i = 0; i < _partners.length; i++) {
            totalWeight += _partners[i].weight;
        }
        if (totalWeight == 0) {
            totalWeight = _partners.length;
        }

        for (uint i = 0; i < _partners.length; i++) {
            payable(_partners[i].adr).transfer(
                balance.div(totalWeight).mul(_partners[i].weight)
            );
        }
    }
}

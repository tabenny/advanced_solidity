pragma solidity ^0.5.0;

import "./PupperCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

// @TODO: Inherit the crowdsale contracts
contract PupperCoinSale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, RefundablePostDeliveryCrowdsale{


      
        //check the constructors of  Crowdsale,MintedCrowdsale,CappedCrowdsale,TimedCrowdsale and RefundablePostDeliveryCrowdsale
        // and pass those variables for constructor
 
    constructor(uint256 rate,address payable wallet,PupperCoin token,uint256 goal,uint256 openingTime,uint256 closingTime) public {
        Crowdsale(rate, wallet, token);
        MintedCrowdsale();
        CappedCrowdsale(goal);
        TimedCrowdsale(openingTime, closingTime) ;
        RefundableCrowdsale(goal);
    }
}

contract PupperCoinSaleDeployer {

    address public token_sale_address;
    address public token_address;

    constructor(string memory name,string memory symbol,address payable wallet) public {
        // @TODO: create the PupperCoin and keep its address handy
        
        PupperCoin token = new PupperCoin(name, symbol, 0);
        token_address = address(token);

        // @TODO: create the PupperCoinSale and tell it about the token, set the goal, and set the open and close times to now and now + 24 weeks.
        PupperCoinSale Pupper_Sale = new PupperCoinSale(1, wallet, token, now, now + 24 weeks, 100, 50 );
        token_sale_address = address(Pupper_Sale);

        // make the PupperCoinSale contract a minter, then have the PupperCoinSaleDeployer renounce its minter role
        token.addMinter(token_sale_address);
        token.renounceMinter();
    }
}

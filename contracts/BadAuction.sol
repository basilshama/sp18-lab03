pragma solidity 0.4.19;

import "./AuctionInterface.sol";

/*
Basil Abushama -- bshama@berkeley.edu -- 3031845454
Uriel Rodriguez -- urodriguezg@berkeley.edu -- 24484915
*/

/** @title BadAuction */
contract BadAuction is AuctionInterface {


	/* Bid function, vulnerable to re-entrency attack.
	 * Must return true on successful send and/or bid,
	 * bidder reassignment
	 * Must return false on failure and send people
	 * their funds back
	 */
	function bid() payable external returns (bool) {
		// YOUR CODE HERE
		if (msg.value > getHighestBid() && msg.value > 0) {
			if (!getHighestBidder().send(getHighestBid()) && getHighestBid() > 0) {
				msg.sender.send(msg.value);
				return false;
			}
			highestBid = msg.value;
			highestBidder = msg.sender;
			return true;
		}
		msg.sender.send(msg.value);
		return false;
	}


	/* 	Reduce bid function. Vulnerable to attack.
		Allows current highest bidder to reduce
		their bid by 1. Do NOT make changes here.
		Instead notice the vulnerabilities, and
		implement the function properly in GoodAuction.sol  */

	function reduceBid() external {
		if (highestBid >= 0) {
			highestBid = highestBid - 1;
			require(highestBidder.send(1));
		} else {
			revert();
		}
	}


	/* 	Remember this fallback function
		gets invoked if somebody calls a
		function that does not exist in this
		contract. But we're good people so we don't
		want to profit on people's mistakes.
		How do we send people their money back?  */

	function () payable {
		// YOUR CODE HERE
		revert();
	}

}

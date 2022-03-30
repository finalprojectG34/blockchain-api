// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@opengsn/contracts/src/BaseRelayRecipient.sol";

contract MyContract is BaseRelayRecipient {
    string public override versionRecipient = "2.2.0";
    uint public data = 5;

    constructor(address _trustedForwarder){
        _setTrustedForwarder(_trustedForwarder);
    }

    function set(uint val) public {
        data += val;
    }

    function getMyData() public view returns(uint d){
        return data;
    }
  
}

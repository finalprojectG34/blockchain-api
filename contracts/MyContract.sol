// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract MyContract {
    uint public data = 5;

    function set(uint val) public {
        data += val;
    }

    function getMyData() public view returns(uint d){
        return data;
    }
  
}

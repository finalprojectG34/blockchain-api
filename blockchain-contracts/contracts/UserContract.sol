// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Library.sol";

contract UserContract {
    /*
        The owner of the contract is the deployer
    */
    address _owner;
    address public supplyChainAddress;
    // address payable public owner;

    /*
        Set owner of the contract to the deployer
    */
    constructor() {
        _owner = msg.sender;
    }

    function setSupplyChainAddress(address add) external {
        require(msg.sender == _owner, "Unauthorized access!");
        supplyChainAddress = add;
    }

    uint id;

    /*
        Any registered user can sell and buy a product
    */
    struct User {
        address id;
        string mongoId;
        string name;
        string email;
        string deliveryAddress;
        string role;
        bool isCreated;
        uint createdAt;
        uint updatedAt;
    }
    struct UserView {
        string mongoId;
        string name;
        string email;
        string deliveryAddress;
        address id;
    }

    mapping (address => User) users;
    address[] public allUsers;

    function userSignUp(
        string memory _mongoId,
        string memory _name,
        string memory _email,
        string memory _deliveryAddress,
        string memory _role,
        address userAddress
    ) public { //payable
        require(msg.sender == supplyChainAddress, "Unauthorized access!");
        require(!users[userAddress].isCreated, "You are Already Registered!");
        require(
            !Library.compareStrings(_mongoId, "") ||
        !Library.compareStrings(_name, "") ||
        !Library.compareStrings(_email, ""),
            "Please fill in the required fields!"
        );

        // owner.transfer(msg.value);
        User memory user = User(
            userAddress,
            _mongoId,
            _name,
            _email,
            _deliveryAddress,
            _role,
            true,
            block.timestamp,
            block.timestamp
        );

        users[userAddress] = user;
        allUsers.push(userAddress);
    }

    function getUserByAddress(address _userId) public view returns (User memory){
        require(msg.sender == supplyChainAddress, "Unauthorized access!");
        User memory res = users[_userId];
        return res;
    }

    function getAllUser() public view returns (UserView[] memory){
        require(msg.sender == supplyChainAddress, "Unauthorized access!");
        UserView[] memory res = new UserView[](allUsers.length);
        for(uint i = 0; i < allUsers.length; i++) {
            string memory mongoId = users[allUsers[i]].mongoId;
            string memory name = users[allUsers[i]].name;
            string memory email = users[allUsers[i]].email;
            string memory deliveryAddress = users[allUsers[i]].deliveryAddress;
            address uid = users[allUsers[i]].id;
            res[i] = UserView(mongoId, name, email, deliveryAddress, uid);
        }
        return res;
    }

}
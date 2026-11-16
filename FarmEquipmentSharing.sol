// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract FarmEquipmentSharing {
    address public immutable manager;
    uint256 public constant RATE_PER_DAY = 0.07 ether;

    struct Tractor {
        bool registered;
        address renter;
        uint256 dueAt;
    }

    mapping(uint256 => Tractor) private tractors;

    event TractorRegistered(uint256 indexed id);
    event TractorRented(
        uint256 indexed id,
        address indexed renter,
        uint256 daysCount,
        uint256 fee,
        uint256 dueAt
    );
    event TractorReturned(uint256 indexed id, address indexed renter);

    constructor() {
        manager = msg.sender;
    }

    modifier onlyManager() {
        require(msg.sender == manager, "Only manager");
        _;
    }

    modifier validId(uint256 id) {
        require(id >= 1 && id <= 6, "Tractor ID must be 1 to 6");
        _;
    }

    function registerTractor(uint256 id)
        external
        onlyManager
        validId(id)
    {
        Tractor storage tractor = tractors[id];
        require(!tractor.registered, "Tractor already registered");

        tractor.registered = true;
        emit TractorRegistered(id);
    }

    function rentTractor(uint256 id, uint256 daysCount)
        external
        payable
        validId(id)
    {
        Tractor storage tractor = tractors[id];

        require(tractor.registered, "Tractor not registered");
        require(tractor.renter == address(0), "Tractor already rented");
        require(daysCount > 0, "Days must be positive");

        uint256 fee = RATE_PER_DAY * daysCount;
        require(msg.value == fee, "Incorrect rental fee");

        tractor.renter = msg.sender;
        tractor.dueAt = block.timestamp + daysCount * 1 days;

        emit TractorRented(id, msg.sender, daysCount, fee, tractor.dueAt);
    }

    function returnTractor(uint256 id) external validId(id) {
        Tractor storage tractor = tractors[id];

        require(tractor.registered, "Tractor not registered");
        require(tractor.renter == msg.sender, "Only current renter");

        tractor.renter = address(0);
        tractor.dueAt = 0;

        emit TractorReturned(id, msg.sender);
    }

    function getTractorStatus(uint256 id)
        external
        view
        validId(id)
        returns (bool registered, address renter, uint256 dueAt)
    {
        Tractor storage tractor = tractors[id];
        return (tractor.registered, tractor.renter, tractor.dueAt);
    }

    function withdrawFees() external onlyManager {
        uint256 amount = address(this).balance;
        require(amount > 0, "No fees to withdraw");

        (bool sent, ) = payable(manager).call{value: amount}("");
        require(sent, "Withdrawal failed");
    }
}
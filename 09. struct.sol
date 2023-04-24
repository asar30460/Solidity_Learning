// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract Structs{
    struct Car{
        string model;
        uint year;
        address owner;
    }

    Car public car;
    Car[] public cars;
    mapping(address => Car[]) public carsByOwner;

    function isntance_operation() external {
        // Initialize
        Car memory toyota = Car('toyora', 1990, msg.sender);
        Car memory lambo = Car({model: 'Lamborghini', year: 1990, owner: msg.sender});
        Car memory tesla;
        tesla.model = 'Tesla';
        tesla.year = 2010;
        tesla.owner = msg.sender;

        cars.push(toyota);
        cars.push(lambo);
        cars.push(tesla);
        cars.push(Car('Ferrari', 2020, msg.sender));

        // Update
        // Not like 'memory' stores data in memory and then deleted after execute function. 'storage' otherwise store in the contract.
        Car storage _car = cars[0];
        _car.year = 1999;

        // Delete
        delete _car.owner;
        delete cars[1]; // All members set to default value.
    }
}
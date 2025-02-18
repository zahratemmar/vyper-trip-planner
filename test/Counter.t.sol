// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import {Test, console} from "../lib/forge-std/src/Test.sol";
import "../utils/VyperDeployer.sol";
import "./interface/ITripPlanner.sol";

contract CounterTest is Test {
    VyperDeployer dep = new VyperDeployer();
    ITripPlanner tripContract ;

    function setUp() public {
        tripContract = ITripPlanner(dep.deployContract("tripPlanner"));
    }

    function test_tripPlanning() public {
        tripContract.add_transportation(12, "oran" ,20250212,20250228,3);
        tripContract.add_guiding(7, "oran" ,20250213,20250222,2);
        tripContract.add_housing(3, "oran" ,20250214,20250224,7);
        (uint id, uint hid,uint gid,uint tid, string memory location, uint startDate, uint endDate, uint256 price) = tripContract.get_planned_trip(1);
        assertEq(id, 1);
        assertEq(hid, 3);
        assertEq(gid, 7);
        assertEq(tid, 12);
        assertEq(startDate, 20250214);
        assertEq(endDate, 20250222);
        assertEq(location, "oran");
        assertEq(price, ((7+3+2)*8));

    }

}

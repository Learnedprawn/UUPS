// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {BoxV2} from "../src/BoxV2.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract UpgradeBox is Script {
    function run() external returns (address) {
        address mostRecentDeployment = DevOpsTools.get_most_recent_deployment("ERC1967Proxy", block.chainid);
        vm.startBroadcast();
        BoxV2 newBox = new BoxV2();
        vm.stopBroadcast();
        address proxy = upgradeBox(mostRecentDeployment, address(newBox));
        return proxy;
    }

    function upgradeBox(address _proxyAddress, address _newBox) public returns (address) {
        vm.startBroadcast();
        BoxV1 proxy = BoxV1(_proxyAddress);
        proxy.upgradeToAndCall(address(_newBox), "");
        vm.stopBroadcast();
        return address(proxy);
    }
}

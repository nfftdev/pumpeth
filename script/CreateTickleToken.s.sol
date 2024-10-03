// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/TickleToken.sol";
import "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";

contract CreateTickleToken is Script {
    function run() external {
        address initialOwner = 0xF51F97A20C4e00fd4d8F85462cf344Bb152B10a3;
        uint256 initialNewTokenLiquidity = 100 ether;
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);
        uint256 gasPrice = 30 gwei;
        vm.txGasPrice(gasPrice);

        // Deploy the implementation contract
        TickleToken tickleTokenImpl = new TickleToken();

        // Deploy ProxyAdmin with the initialOwner as the admin
        ProxyAdmin proxyAdmin = new ProxyAdmin(initialOwner);

        // Encode the initialize function call
        bytes memory initializeData = abi.encodeWithSelector(
            TickleToken.initialize.selector,
            initialOwner
        );

        // Deploy the proxy
        TransparentUpgradeableProxy proxy = new TransparentUpgradeableProxy(
            address(tickleTokenImpl),
            address(proxyAdmin),
            initializeData
        );

        // Create an instance of TickleToken pointing to the proxy
        TickleToken tickleToken = TickleToken(address(proxy));

        // Mint initial tokens
        tickleToken.mint(initialOwner, initialNewTokenLiquidity);
        
        console.log("Tickle Token Proxy deployed at:", address(proxy));
        console.log("Tickle Token Implementation deployed at:", address(tickleTokenImpl));
        console.log("ProxyAdmin deployed at:", address(proxyAdmin));

        vm.stopBroadcast();
    }
}

// POLYGON MAIN
// forge script script/CreateTickleToken.s.sol:CreateTickleToken --rpc-url $POLYGON_RPC_URL --broadcast --sender 0xF51F97A20C4e00fd4d8F85462cf344Bb152B10a3 -vvvv
// forge inspect TickleToken abi > TickleToken.abi
// == Logs ==
//   Tickle Token Proxy deployed at: 0xDE59B204d83E7F0Dd580439912EB28EC9333c24e
//   Tickle Token Implementation deployed at: 0x8941CFB6367ac6CA12E7be5bc49255FA928eb323
//   ProxyAdmin deployed at: 0x7DeDC30ED9877d26FD15a72A87af65a3AF7F6994

// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

// Import the standard ERC20 implementation from OpenZeppelin
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title TokenA
 * @author Gisela Celeste Yede
 * @notice ERC20 token used in a DEX environment.
 * @dev This token has unrestricted minting in the constructor for initial distribution.
 *      No access control is applied beyond the initial mint.
 */
contract TokenB is ERC20 {
    /**
     * @notice Deploys TokenB and mints an initial supply to the deployer's address.
     * @dev The token has a fixed name "Token B" and symbol "TB".
     *      The initial supply is 1000 tokens with full decimal precision (usually 18).
     *      This constructor does not restrict who can deploy or own the tokens.
     */
    constructor() ERC20("Token A", "TA") {
        // Mint 1000 tokens (multiplied by 10^decimals) to the deployer
        _mint(msg.sender, 1000 * 10 ** decimals());
    }
}

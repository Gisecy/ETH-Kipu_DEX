// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title LiquidityToken
 * @author Gisela Celeste Yede
 * @notice ERC20 token used to represent shares in a liquidity pool for a decentralized exchange (DEX).
 * @dev Only the designated "owner" can mint and burn tokens. Ownership can be transferred via "setOwner".
 */
contract LiquidityToken is ERC20 {
    /// @notice Address with permission to mint and burn tokens
    address public owner;

    /**
     * @notice Deploys the liquidity token with predefined name and symbol.
     * @dev Sets the initial owner to the deployer address.
     */
    constructor() ERC20("LiquidityToken", "LT") {
        owner = msg.sender;
    }

    /**
     * @notice Transfers the ownership of the minting and burning rights.
     * @dev Only the current owner can call this function.
     * @param _owner The new owner address.
     */
    function setOwner(address _owner) external {
        require(msg.sender == owner, "Not current owner");
        owner = _owner;
    }

    /**
     * @notice Mints new liquidity tokens to a specified address.
     * @dev Only callable by the current owner.
     * @param to The address to receive the minted tokens.
     * @param amount The number of tokens to mint.
     */
    function mint(address to, uint256 amount) external {
        require(msg.sender == owner, "Only owner can mint");
        _mint(to, amount);
    }

    /**
     * @notice Burns liquidity tokens from a specified address.
     * @dev Only callable by the current owner.
     * @param from The address whose tokens will be burned.
     * @param amount The number of tokens to burn.
     */
    function burn(address from, uint256 amount) external {
        require(msg.sender == owner, "Only owner can burn");
        _burn(from, amount);
    }
}

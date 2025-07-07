// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "./LiquidityToken.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title SimpleSwap
 * @author Gisela Celeste Yede
 * @notice A decentralized exchange (DEX) that allows users to add and remove liquidity,
 *         perform token swaps, and query prices and expected output amounts.
 * @dev This contract is compatible with SwapVerifier for automated testing.
 *      It uses a separate LiquidityToken to represent user shares in the liquidity pool.
 */
contract SimpleSwap {
    /// @notice Address of TokenA 
    address public immutable tokenA;

    /// @notice Address of TokenB 
    address public immutable tokenB;

    /// @notice Liquidity token representing pool shares
    LiquidityToken public immutable liquidityToken;

    /// @dev Internal storage of reserves for TokenA and TokenB
    struct Reserves {
        uint128 reserveA;
        uint128 reserveB;
    }

    /// @dev Current reserves of TokenA and TokenB
    Reserves private reserves;

    /**
     * @notice Initializes the token pair for the exchange
     * @param _tokenA Address of TokenA
     * @param _tokenB Address of TokenB
     */
    constructor(address _tokenA, address _tokenB) {
        require(_tokenA != _tokenB, "Tokens must differ");
        tokenA = _tokenA;
        tokenB = _tokenB;
        liquidityToken = new LiquidityToken();
        liquidityToken.setOwner(address(this));
    }

  /**
    * @notice Allows users to add liquidity to the pool of TokenA and TokenB.
    * @dev Liquidity tokens are minted based on added token ratios and existing reserves.
    * @param amountADesired Desired amount of TokenA to add.
    * @param amountBDesired Desired amount of TokenB to add.
    * @param amountAMin Minimum acceptable amount of TokenA (slippage protection).
    * @param amountBMin Minimum acceptable amount of TokenB (slippage protection).
    * @param to The address that will receive the minted liquidity tokens.
    * @param deadline Timestamp by which the transaction must be executed.
    * @return amountA The actual amount of TokenA used.
    * @return amountB The actual amount of TokenB used.
    * @return liquidity The amount of liquidity tokens minted.
    */
    function addLiquidity(
        address, // tokenA
        address, // tokenB
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity) {
        require(block.timestamp <= deadline, "Transaction expired");

        (uint256 rA, uint256 rB) = (reserves.reserveA, reserves.reserveB);

        if (rA == 0 && rB == 0) {
            amountA = amountADesired;
            amountB = amountBDesired;
        } else {
            uint256 bOptimal = (amountADesired * rB) / rA;
            if (bOptimal <= amountBDesired) {
                amountA = amountADesired;
                amountB = bOptimal;
            } else {
                amountB = amountBDesired;
                amountA = (amountBDesired * rA) / rB;
            }
        }

        require(amountA >= amountAMin, "TokenA amount below minimum");
        require(amountB >= amountBMin, "TokenB amount below minimum");

        require(IERC20(tokenA).transferFrom(msg.sender, address(this), amountA), "TokenA transfer failed");
        require(IERC20(tokenB).transferFrom(msg.sender, address(this), amountB), "TokenB transfer failed");

        uint256 totalSupply = liquidityToken.totalSupply();
        
        liquidity = (totalSupply == 0)
            ? amountA
            : _min((amountA * totalSupply) / rA, (amountB * totalSupply) / rB);
        require(liquidity > 0, "Zero liquidity");

        liquidityToken.mint(to, liquidity);
        
        // @dev Attempts to mint liquidity tokens to the "to" address and ensures the minting succeeded.
        //      Reverts the transaction if minting fails.
        bool success = tryMint(to, liquidity); 
        require(success, "Mint failed");

        reserves.reserveA = uint128(rA + amountA);
        reserves.reserveB = uint128(rB + amountB);
    }

    /**
     * @notice Internal helper to safely mint liquidity tokens.
     * @dev This function is only used for local testing in Remix.
     * @param to Receiver of the liquidity tokens.
     * @param amount Number of tokens to mint.
     * @return success Whether the minting succeeded.
     */
    function tryMint(address to, uint256 amount) internal returns (bool) {
        try liquidityToken.mint(to, amount) {
            return true;
        } catch {
            return false;
        }
    }


    /**
    * @notice Allows users to remove their liquidity and receive back TokenA and TokenB.
    * @param liquidity Amount of liquidity tokens to redeem.
    * @param amountAMin Minimum acceptable amount of TokenA (slippage protection).
    * @param amountBMin Minimum acceptable amount of TokenB (slippage protection).
    * @param to The address that will receive TokenA and TokenB.
    * @param deadline Expiration timestamp for this transaction.
    * @return amountA The amount of TokenA received.
    * @return amountB The amount of TokenB received.
    */
    function removeLiquidity(
        address, // tokenA
        address, // tokenB
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB) {
        require(block.timestamp <= deadline, "Transaction expired");

        uint256 totalSupply = liquidityToken.totalSupply();
        (uint256 rA, uint256 rB) = (reserves.reserveA, reserves.reserveB);

        amountA = (liquidity * rA) / totalSupply;
        amountB = (liquidity * rB) / totalSupply;

        require(amountA >= amountAMin, "TokenA amount too low");
        require(amountB >= amountBMin, "TokenB amount too low");

        liquidityToken.burn(msg.sender, liquidity);
        require(IERC20(tokenA).transfer(to, amountA), "TokenA transfer failed");
        require(IERC20(tokenB).transfer(to, amountB), "TokenB transfer failed");

        reserves.reserveA = uint128(rA - amountA);
        reserves.reserveB = uint128(rB - amountB);
    }


    /**
    * @notice Swaps an exact amount of one token for another using the pool's liquidity.
    * @param amountIn The amount of input token to swap.
    * @param amountOutMin The minimum amount of output token expected (slippage protection).
    * @param path An array with [tokenIn, tokenOut] addresses.
    * @param to The recipient address of the output token.
    * @param deadline Timestamp until when this swap is valid.
    * @return amounts An array [amountIn, amountOut] with swap details.
    */
    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts) {
        require(block.timestamp <= deadline, "Transaction expired");
        require(path.length == 2, "Path must have 2 tokens");
        address tokenIn = path[0];
        address tokenOut = path[1];

        (uint256 rIn, uint256 rOut) = tokenIn == tokenA
            ? (reserves.reserveA, reserves.reserveB)
            : (reserves.reserveB, reserves.reserveA);

        require(IERC20(tokenIn).transferFrom(msg.sender, address(this), amountIn), "Input transfer failed");
        uint256 amountOut = (amountIn * rOut) / (rIn + amountIn);
        require(amountOut >= amountOutMin, "Insufficient output");
        require(IERC20(tokenOut).transfer(to, amountOut), "Output transfer failed");

        if (tokenIn == tokenA) {
            reserves.reserveA = uint128(rIn + amountIn);
            reserves.reserveB = uint128(rOut - amountOut);
        } else {
            reserves.reserveB = uint128(rIn + amountIn);
            reserves.reserveA = uint128(rOut - amountOut);
        }

        // Return result array
        amounts = new uint256[] (2);
        amounts[0] = amountIn;
        amounts[1] = amountOut;
    }

    /**
     * @notice Returns the price of one token in terms of the other based on current reserves.
     * @param _tokenA The base token address.
     * @param _tokenB The quote token address.
     * @return price The price scaled by 1e18.
     */
    function getPrice(address _tokenA, address _tokenB) external view returns (uint256 price) {
        (uint256 rA, uint256 rB) = (reserves.reserveA, reserves.reserveB);
        if (_tokenA == tokenA && _tokenB == tokenB) {
            price = (rB * 1e18) / rA;
        } else if (_tokenA == tokenB && _tokenB == tokenA) {
            price = (rA * 1e18) / rB;
        } else {
            revert("Invalid token pair");
        }
    }

    /**
    * @notice Calculates output amount based on constant product formula.
    * @param amountIn The amount of input token.
    * @param reserveIn The reserve of the input token.
    * @param reserveOut The reserve of the output token.
    * @return amountOut The estimated output amount.
    */
    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountOut) {
        require(amountIn > 0, "AmountIn zero");
        require(reserveIn > 0 && reserveOut > 0, "Insufficient reserves");
        amountOut = (amountIn * reserveOut) / (reserveIn + amountIn);
    }

    /**
     * @notice Returns the current reserves of the token pair.
     * @dev This function is only used for local testing in Remix.
     * @return reserveA Current reserve of token A.
     * @return reserveB Current reserve of token B.
     */
    function getReserves() external view returns (uint128, uint128) {
        return (reserves.reserveA, reserves.reserveB);
    }
    
    /**
     * @notice Returns the minimum of two values.
     * @param a First value.
     * @param b Second value.
     * @return The smaller of a and b.
     */
    function _min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

}



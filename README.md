# ETH-Kipu_DEX
Smart Contract de un DEX.

# SimpleSwap DEX 💱

> Final Project - Module 3  
> Author: Gisela Celeste Yede

## 🧠 Overview

**SimpleSwap** is a decentralized exchange (DEX) smart contract inspired by Uniswap V2. It allows users to:

- Add and remove liquidity
- Swap tokens
- Get price quotes
- Calculate swap output amounts

This implementation is designed to meet the requirements of a decentralized liquidity pool using ERC-20 tokens and a custom liquidity token.

---

## 📦 Contracts Included

| Contract Name        | Description                                                                                   |
|----------------------|-----------------------------------------------------------------------------------------------|
| `TokenA.sol`         | Basic ERC-20 token ("Token A", symbol: TA) with initial mint                                  |
| `TokenB.sol`         | Basic ERC-20 token ("Token B", symbol: TB) with initial mint                                  |
| `LiquidityToken.sol` | ERC-20 token representing shares in the liquidity pool (mint/burn controlled by `SimpleSwap`) |
| `SimpleSwap.sol`     | The main DEX contract implementing all required functionalities                               |

---

## ✨ Features


### 1️⃣ Add Liquidity

function addLiquidity(
    address tokenA,
    address tokenB,
    uint amountADesired,
    uint amountBDesired,
    uint amountAMin,
    uint amountBMin,
    address to,
    uint deadline
) external returns (uint amountA, uint amountB, uint liquidity);

* Transfers TokenA and TokenB to the pool.

* Calculates fair share based on current reserves.

* Mints LiquidityToken to the liquidity provider.


2️⃣ Remove Liquidity

function removeLiquidity(
    address tokenA,
    address tokenB,
    uint liquidity,
    uint amountAMin,
    uint amountBMin,
    address to,
    uint deadline
) external returns (uint amountA, uint amountB);

* Burns liquidity tokens.

* Returns proportional amounts of TokenA and TokenB to the user.


3️⃣ Swap Exact Tokens

function swapExactTokensForTokens(
    uint amountIn,
    uint amountOutMin,
    address[] calldata path,
    address to,
    uint deadline
) external returns (uint[] memory amounts);

* Executes a swap using constant product formula.

* Supports [TokenA → TokenB] or [TokenB → TokenA] paths.

* Enforces slippage protection.


4️⃣ Get Price

function getPrice(address tokenA, address tokenB) external view returns (uint price);

*Returns price of one token in terms of the other based on reserves.

* Result is scaled by 1e18.


5️⃣ Calculate Output Amount

function getAmountOut(
    uint amountIn,
    uint reserveIn,
    uint reserveOut
) external pure returns (uint amountOut);

* Uses the constant product formula to estimate output tokens from an input amount.



🔧 Testing and Verification


The contract was verified against an external pre-deployed SwapVerifier contract available at:


🔗 SwapVerifier on Sepolia Etherscan


The verifier tests the full flow:

- Minting tokens

- Adding liquidity

- Querying price and amountOut

- Performing a swap

- Removing liquidity



🧪 Local Testing

You can test this contract using Remix IDE with JavaScript VM or by deploying to a testnet like Sepolia.


Example steps:

- Deploy TokenA, TokenB with 1000 tokens each

- Deploy SimpleSwap passing both token addresses

- Approve SimpleSwap to transfer user tokens

- Call addLiquidity, swapExactTokensForTokens, and removeLiquidity

- Query reserves, price and amountOut via respective functions



📁 File Structure

contracts/

│
├── TokenA.sol          # ERC20 Token A (TA)

├── TokenB.sol          # ERC20 Token B (TB)

├── LiquidityToken.sol  # Pool token (LT)

└── SimpleSwap.sol      # Main DEX contract


🗓 Project Requirements


✅ All 5 functions implemented
✅ Compatible with SwapVerifier
✅ Includes inline NatSpec comments
✅ Written entirely in English
✅ Structured for clarity and gas optimization
✅ Verified on Sepolia via Etherscan



📚 References

- Uniswap V2 Smart Contract Docs

- OpenZeppelin Contracts

- Solidity NatSpec Format



🧾 License

This project is licensed under the GPL-3.0 License.



👩‍💻 Author

Gisela Celeste Yede
Final Project – Solidity Module 3
Cohort 2025

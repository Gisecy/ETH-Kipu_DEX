## 🇬🇧 English

# SimpleSwap DEX 💱
**ETH-Kipu_DEX (SimpleSwap)** is a decentralized exchange (DEX) smart contract inspired by Uniswap V2. 


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

--

### 2️⃣ Remove Liquidity

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

--

### 3️⃣ Swap Exact Tokens

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

--

### 4️⃣ Get Price

function getPrice(address tokenA, address tokenB) external view returns (uint price);

*Returns price of one token in terms of the other based on reserves.

* Result is scaled by 1e18.

--

### 5️⃣ Calculate Output Amount

function getAmountOut(
    uint amountIn,
    uint reserveIn,
    uint reserveOut
) external pure returns (uint amountOut);

* Uses the constant product formula to estimate output tokens from an input amount.


---

### 🔧 Testing and Verification


The contract was verified against an external pre-deployed SwapVerifier contract available at:


🔗 SwapVerifier on Sepolia Etherscan


The verifier tests the full flow:

- Minting tokens

- Adding liquidity

- Querying price and amountOut

- Performing a swap

- Removing liquidity


---

### 🧪 Local Testing

You can test this contract using Remix IDE with JavaScript VM or by deploying to a testnet like Sepolia.


Example steps:

- Deploy TokenA, TokenB with 1000 tokens each

- Deploy SimpleSwap passing both token addresses

- Approve SimpleSwap to transfer user tokens

- Call addLiquidity, swapExactTokensForTokens, and removeLiquidity

- Query reserves, price and amountOut via respective functions


---

### 📁 File Structure

contracts/

│

├── TokenA.sol          # ERC20 Token A (TA)

├── TokenB.sol          # ERC20 Token B (TB)

├── LiquidityToken.sol  # Pool token (LT)

└── SimpleSwap.sol      # Main DEX contract

---

### 🗓 Project Requirements


✅ All 5 functions implemented

✅ Compatible with SwapVerifier

✅ Includes inline NatSpec comments

✅ Written entirely in English

✅ Structured for clarity and gas optimization

✅ Verified on Sepolia via Etherscan



---

### 📚 References

- Uniswap V2 Smart Contract Docs

- OpenZeppelin Contracts

- Solidity NatSpec Format


---

### 🧾 License

This project is licensed under the GPL-3.0 License.


---

### 👩‍💻 Author

Gisela Celeste Yede
Final Project – Solidity Module 3
Cohort 2025

---
# 🇪🇸 Español

# SimpleSwap DEX 💱
**ETH-Kipu_DEX (SimpleSwap)** es un contrato inteligente de exchange descentralizado (DEX) inspirado en Uniswap V2.


> Proyecto Final - Módulo 3

> Autora: Gisela Celeste Yede

## 🧠 Descripción general

SimpleSwap es un contrato inteligente para un exchange descentralizado (DEX), inspirado en Uniswap V2. Permite a los usuarios:

- Agregar y remover liquidez

- Intercambiar tokens

- Obtener cotizaciones de precios

- Calcular el monto esperado de salida en un swap

- Esta implementación está diseñada para cumplir con los requisitos de un pool de liquidez descentralizado usando tokens ERC-20 y un token de liquidez personalizado.

--- 

📦 Contratos incluidos

| Nombre del COntrato  | Descripción                                                                                  |
|----------------------|----------------------------------------------------------------------------------------------|
| `TokenA.sol`         | Token ERC-20 básico ("Token A", símbolo: TA) con acuñación inicial                           |
| `TokenB.sol`         | Token ERC-20 básico ("Token B", símbolo: TB) con acuñación inicial                           |
| `LiquidityToken.sol` | Token ERC-20 que representa participaciones del pool de liquidez (controlado por SimpleSwap) |
| `SimpleSwap.sol`     | Contrato principal del DEX que implementa todas las funcionalidades requeridas               |


---

✨ Funcionalidades

### 1️⃣ Agregar Liquidez

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

* Transfiere TokenA y TokenB al pool

* Calcula la participación justa según las reservas actuales

* Emite LiquidityTokens al proveedor de liquidez

--

### 2️⃣ Remover Liquidez

function removeLiquidity(
    address tokenA,
    address tokenB,
    uint liquidity,
    uint amountAMin,
    uint amountBMin,
    address to,
    uint deadline
) external returns (uint amountA, uint amountB);

* Quema tokens de liquidez

* Devuelve cantidades proporcionales de TokenA y TokenB al usuario

--

### 3️⃣ Intercambiar Tokens Exactos

function swapExactTokensForTokens(
    uint amountIn,
    uint amountOutMin,
    address[] calldata path,
    address to,
    uint deadline
) external returns (uint[] memory amounts);

* Realiza un swap utilizando la fórmula de producto constante

* Soporta rutas [TokenA → TokenB] o [TokenB → TokenA]

* Aplica protección contra deslizamiento (slippage)

--

### 4️⃣ Obtener Precio

function getPrice(address tokenA, address tokenB) external view returns (uint price);

* Devuelve el precio de un token en términos del otro según las reservas

* El resultado está escalado por 1e18

--

### 5️⃣ Calcular Cantidad de Salida

function getAmountOut(
    uint amountIn,
    uint reserveIn,
    uint reserveOut
) external pure returns (uint amountOut);

* Utiliza la fórmula de producto constante para estimar la cantidad de tokens de salida a partir de una entrada

---

🔧 Verificación y Testing

El contrato fue verificado usando un contrato externo SwapVerifier previamente desplegado y disponible en Sepolia.


🔗 Ver SwapVerifier en Etherscan de Sepolia


El verificador realiza pruebas de flujo completo:


- Acuñación de tokens

- Agregado de liquidez

- Consultas de precio y cantidad esperada

- Ejecución de swap

- Remoción de liquidez

---

### 🧪 Pruebas Locales

Podés probar este contrato usando Remix IDE con JavaScript VM o desplegarlo en una testnet como Sepolia.


Pasos de ejemplo:

- Deploy TokenA y TokenB con 1000 tokens cada uno

- Deploy SimpleSwap pasando ambas direcciones de tokens

- Aprobar a SimpleSwap para transferir tokens del usuario

- Ejecutar addLiquidity, swapExactTokensForTokens y removeLiquidity

- Consultar reservas, precios y valores de salida usando las funciones respectivas

---

### 📁 Estructura de Archivos

contracts/

├── TokenA.sol          # Token ERC20 A (TA)

├── TokenB.sol          # Token ERC20 B (TB)

├── LiquidityToken.sol  # Token del pool (LT)

└── SimpleSwap.sol      # Contrato principal del DEX

---

### 🗓 Requisitos del Proyecto

✅ Las 5 funciones requeridas implementadas

✅ Compatible con SwapVerifier

✅ Comentarios inline en formato NatSpec

✅ Documentado completamente en inglés

✅ Código claro y optimizado para gas

✅ Verificado en Sepolia mediante Etherscan

---

### 📚 Referencias

- Documentación de contratos Uniswap V2

- OpenZeppelin Contracts

- Formato de comentarios NatSpec
  
---

### 🧾 Licencia

Este proyecto está licenciado bajo la GPL-3.0 License.

---

👩‍💻 Autora

Gisela Celeste Yede

Proyecto Final – Módulo Solidity 3

Cohorte 2025


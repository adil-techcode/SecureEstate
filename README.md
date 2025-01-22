# RealTok and SecureEstate Contracts

This repository contains  smart contracts designed for real estate and token management.

---

## 1. RealTok Contract

The **RealTok** contract is a prototype for managing real estate properties, enabling efficient storage and retrieval of property data linked to societies.

### Features
- **Property Management**: Add, view, and manage property details such as size, location, electricity availability, owner name, and associated society.
- **Token Verification**: Restricts access to property details to verified token holders.
- **Society Integration**: Fetch plots based on societies for structured data retrieval.
- **Admin Controls**: Only the owner can update the token contract or add new properties.

### Key Functionalities
- Add a new plot.
- View all plots or plots by society.
- Update token contract address.
- Verify token holders for restricted access.

---

## 2. SecureEstate Contract

The **SecureEstate** contract is an ERC20 token implementation tailored for real estate use cases, with additional features for token minting, burning, and transactions.

### Features
- **ERC20 Token**: Implements standard ERC20 functionality with the `SecureEstate` token (symbol: `SEH`).
- **Minting and Burning**: Allows the owner to mint or burn tokens.
- **Transaction Logging**: Emits events for all token transactions, including minting, transfers, and burns.
- **Token Balance Check**: Verify if a wallet owns tokens.

### Key Functionalities
- Mint tokens to an address (owner only).
- Burn tokens to reduce supply (owner only).
- Transfer tokens between addresses.
- Check wallet token ownership.

---

## How to Use

1. **Deploy Contracts**:
   - Deploy `RealTok` with the token contract address as an argument.
   - Deploy `SecureEstate` without additional arguments.

2. **RealTok Setup**:
   - Use the admin account to add plots and manage society data.
   - Update the token contract address as needed.

3. **SecureEstate Setup**:
   - Mint tokens to users as needed.
   - Burn tokens to reduce supply or manage token lifecycle.
   - Log transactions for transparency.

---

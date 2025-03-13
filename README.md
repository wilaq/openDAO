# TACO DAO

A decentralized autonomous organization (DAO) framework built on the Internet Computer Protocol, designed for continuous allocation voting and treasury management.

## Overview

TACO DAO provides a complete system for decentralized governance, voting power calculation, and treasury management. The DAO allows SNS neuron holders to influence treasury allocations through a continuous voting mechanism, where each holder's voting power is proportional to their neuron's stake, dissolve delay, and age.

## Repository Structure

This repository contains the core components of the TACO DAO system:

- **DAO**: The main governance canister, handling allocation voting, user follows, and aggregation logic
- **neuron_snapshot**: Tracks SNS neurons and calculates voting power based on neuron parameters
- **helper**: Utility modules including spam protection and logging functionality
- **minting_vault**: Type definitions for the token minting and liquidity provision system
- **treasury**: Type definitions for the treasury management system

## Key Features

- **Continuous Voting**: Users can update their allocation preferences at any time
- **Follow Mechanism**: Users can follow other users' allocation strategies
- **Neuron Voting Power**: Voting power calculated based on the same principles as in SNS
- **Treasury Management**: Types for the treasury system that executes trades based on aggregated allocations
- **Spam Protection**: Rate limiting and access control mechanisms
- **Allocation Aggregation**: Weighted aggregation of all user votes based on voting power

## Coming Soon

The complete testing suite and additional components (Treasury and Minting Vault canisters) will be open-sourced in future updates. These components handle:

- Automated portfolio rebalancing based on voting results
- DEX integrations (ICPSwap and KongSwap)
- Token price monitoring and slippage controls
- Liquidity provision through the minting vault

## System Architecture

The TACO DAO system consists of several interconnected canisters:

1. **DAO Canister**: Central governance, manages user allocations and aggregation
2. **Neuron Snapshot**: Tracks SNS neurons and calculates voting power
3. **Treasury**: Executes trades based on aggregated allocations
4. **Minting Vault**: Provides liquidity in exchange for token deposits

The system operates through a continuous feedback loop:
- Users vote on desired token allocations
- Votes are aggregated, weighted by voting power
- Treasury executes trades to align with the target allocation
- Minting vault provides additional liquidity for portfolio adjustments

## Development

More detailed development and contribution guidelines will be provided as additional components are open-sourced.

## License

Licensed with GNU General Public License v3.0

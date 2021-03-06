Summary

> enter a summary of your proposal here

Abstract

> enter your proposal's abstract here

Motivation

> enter the motivation behind your proposal here

# YCabal

> Monopolizing transaction flow for arbitrage batching with miner
> support

## Overview

<pre>
Proposal: YCabal
Project: SushiSwap / DEX's
Status: Active
Version: Draft 0.4.0
Timeframe: 60d
</pre>

This is a strategy that realizes a profit by smart transaction batching
for the purposes of arbitrage by controlling transaction ordering.

Right now every user sends a transaction directly to the network mempool
and thus gives away the arbitrage, front-running, back-running
opportunities to miners(or random bots).

YCabal creates a virtualized mempool (i.e. a MEV-relay network) that
aggregates transactions (batching), such transactions include:

DEX trades <br> Interactions with protocols <br> Auctions <br> etc <br>

#### TL;DR - Users can opt in and send transactions to YCabal and in return for not having to pay for gas for their transaction we batch process it and take the arbitrage profit from it. Risk by inventory price risk is carried by a Vault, where Vault deposits are returned the profit the YCabal realizes

## Background

Preliminary estimates obtained from MEV-Inspect show the following lower
bounds:

10k of 443k blocks analyzed were wasted on inefficient MEV extraction
bots extracted 0.34 ETH of MEV per block through arbitrage and
liquidations 18.7% of MEV extracted by bots is paid to miners through
gas fees which makes up 3.7% of all transaction fees

## Efficiency by Aggregation

By leveraging batching, miner transaction flow, and providing additional
performant utilities (e.g. faster calculations for finalizing), we can
realize the following potential avenues for realizing profitable
activities:

- Meta Transaction Functionality
- Order trades in different directions sequentially to produce positive
  slippage
- Backrun Trades
- Frontrun Trades
- At least 21k in the base cost on every transaction is saved

> **If we have access to transactions before the network we can generate
> value because we can calculate future state, off-chain**

> Think of this as creating a Netting Settlement System (whereas
> blockchains are a real-time gross settlement system)

## User Capture

The whole point of Backbone Cabal is to maximize profits from user
actions which gets distributed for free to miners and bots.

- We intend to extract this value and provide these profits as
  `**cashback**` to users.
- Another possibility is providing a 'boost' to user accounts that are
  farming. Basically use the profits to increase yield on farming
  activities to those who use the service and are farming an eligible
  market (this is sushiswap specific).

**For example**: A SushiSwap trader who loses `X%` to slippage during
his trade can now get `X-Y %` slippage on his trade because we were able
to back run his trade and give him the arbitrage profits.

Backbone Cabal gets better and better as more transactions flow because
there is less uncertainty about the future state of the network.

### Gas Free Trading

- SushiSwap as an example

### Rebates

Profits can be rebated to end-users

### Volume Mining

Other protocols can join the network and turn their transaction flow
into a book of business with our network of participants

<br>

### `skim(address)`

> UniSwapV2

[skim**address**](https://github.com/Uniswap/uniswap-v2-core/blob/master/contracts/UniswapV2Pair.sol#L190-L195)
lets anyone claim a positive discrepancy between the actual token
balance in the contract and the reserve number stored in the Pair
contract.

## Solution Set

ArcherDAO <br> Manifold Finance <br> Kafka based JSON RPC and API
Gateway <br> kdb+ <br>

## Attack Vectors against the Backbone

DDoS <br> Exploits <br> Additional Disclosures forthcoming <br>

## Ecosystem Benefits

- Can act as a failover web3 provider (e.g. Infura/AlchemyAPI outage)
- Transaction Monitoring
- Security Operations for Contracts

### User Example

Proposed end-user transaction example for interacting with the YCabal

> NOTE: Since the JSON-RPC spec allows responses to be returned in a
> different order than sent, we need a mechanism for choosing a
> canonical id from a list that doesn't depend on the order. This
> chooses the "minimum" id by an arbitrary ordering: the smallest string
> if possible, otherwise the smallest number, otherwise null.

```jsx
order = {
	Give: ETH,
	Want: DAI,
	SlippageLimit: 10%,
	Amount: 1000ETH,
	Cabal: 0xabc...,
	FeesIn: DAI,
	TargetDEX: SushiSwap,
	Deadline: time.Now() + 1*time.Minute
	Signature: sign(order.SignBytes())
}
```

Now if the Cabal broadcasts this transaction with an arbitrage order,
the transaction contains 2 orders:

> Note: the transaction below is a mock-up for the proposed _data
> fields_

```jsx
transactions = [
	{
		Give: ETH,
		Want: DAI,
		SlippageLimit: 10%,
		Amount: 1000ETH,
		Cabal: 0xabc...,
		FeesIn: DAI,
		TargetDEX: SushiSwap,
		Deadline: time.Now() + 1*time.Minute
		Signature: sign(order.SignBytes())
	},
	{
		Give: DAI,
		Want: ETH,
		SlippageLimit: 1%,
		Amount: 10ETH,
		Cabal: 0xabc...,
		FeesIn: DAI,
		TargetDEX: SushiSwap,
		Deadline: time.Now() + 1*time.Minute
		Signature: sign(order.SignBytes()),
		IsBackbone Cabal: true,
		TransferProfitTo: transactions[0].signer
	}
]
```

The arbitrage profit generated by second order is sent to the
`msg.sender` of the first order.

The first order will still lose 5%(assumption) in slippage.

Arbitrage profits will rarely be more than the slippage loss.

If someone front runs the transaction sent by the Cabal:

1. They pay for the gas while post confirmation of transaction the fees
   for order1 goes to the relayer in the signed order.
2. They lose 5% in slippage as our real user does.

## Engine

YCabal uses a batch auction-based matching engine to execute orders.
Batch auctions were chosen to reduce the impact of frontrunning on the
exchange.

1. All orders for the given market are collected.

2. Orders beyond their time-in-force are canceled.

3. Orders are placed into separate lists by market side, and aggregate
   supply and demand curves are calculated.

4. The matching engine discovers the price at which the aggregate supply
   and demand curves cross, which yields the clearing price. If there is
   a horizontal cross - i.e., two prices for which aggregate supply and
   demand are equal - then the clearing price is the midpoint between
   the two prices.

5. If both sides of the market have equal volume, then all orders are
   completely filled. If one side has more volume than the other, then
   the side with higher volume is rationed pro-rata based on how much
   its volume exceeds the other side. For example, if aggregate demand
   is 100 and aggregate supply is 90, then every order on the demand
   side of the market will be matched by 90%.

Orders are sorted based on their price, and order ID. Order IDs are
generated at post time and is the only part of the matching engine that
is time-dependent. However, the oldest order IDs are matched first so
there is no incentive to post an order ahead of someone else’s.

## Links

[Manifold RPC Inspector for Backbone Cabal](https://backbone-rpc.netlify.app/)

[Provisional Public API](https://ybackbone.netlify.app/)

For

> enter the outcome of the For side

Against

> enter the outcome of the Against side

Poll

> Build a poll using the Build Poll function, check out this link
> (https://meta.discourse.org/t/how-to-create-polls/77548) for a guide
> on how to build a poll

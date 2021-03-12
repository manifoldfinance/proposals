---
document: Backbone Cabal
topic: clearing and settlement
version: draft
---

## Abstract

> `BACKBONE` is a _placeholder_ name for now: this is seperate from Backbone Cabal

A protocol that provides secure, high throughput settlement on the
Ethereum Blockchain for central order book exchanges. Processing every
trade individually on the Blockchain is too slow and costly for modern
markets. Exchanges using the BACKBONE aggregate trades into a list of
balance updates to be processed by the Blockchain. This shifts the
amount of data the Blockchain must process from number of trades to
number of active market participants. Trading limits are used to
restrict unfavorable settlement. Introduction

Looking to the security markets, we can see a clear separation of
concerns. There exists exchanges, central depositories, and clearing
houses, each with distinct roles and regulations. With programmable
contracts on the Blockchain, the BACKBONE is able to fill the role of
both central depository and clearing house. Because the BACKBONE can
provide these services, the exchange has a smaller attack surface and
can focus on processing orders.

The BACKBONE is an Ethereum Smart Contract that handles trade settlement
for ERC-20 Tokens. While the BACKBONE supports multiple exchanges and
ERC-20 Tokens, for simplicity, this whitepaper will focus on a single
exchange with a single market. A market facilitates exchange between two
ERC-20 Tokens, the base asset and the quote asset. Prices on the market
are provided in units of quote asset per base asset. Quantities have
units of the base asset. For example, the market ETH-USD has Ethereum
(ETH) as the base asset and US Dollar (US) as the quote asset. Prices in
this market would be in USD per ETH and quantities in ETH. Orders are
stated as “buy 1 ETH for 100USD/ETH” or “sell 1.2 ETH for 120 USD/ETH”.
Settlement

Settlement is the process of applying trades to user balances. The naive
approach is to apply the following for each trade

quantity := trade.quantity cost := trade.quantity \* trade.price

buyer_quote_balance -= cost seller_quote_balance += cost
seller_base_balance -= quantity buyer_base_balance += quantity

Using this method, a single trade requires 4 balance updates. Let’s
propose a market with 2 sell orders, each for 1 Ethereum at a price of
100 USD. A single buy order for 2 Ethereum would create two trades, one
for each sell order. Using the naive approach, this would require 8
balance updates. We know both trades have the same buyer; so in truth,
only 6 balance updates are required. If the two sellers happen to be the
same user, a total of only 4 balances updates are required. The number
of balance updates required is 2x the number of distinct users in a set
of trades. Using this knowledge, a batching optimization can be made.

Instead of directly updating user balances for each trade, we can update
a temporary balance for each user that starts at zero. Then by using the
commutative property of addition, we can add the temporary balances
directly to the user balances.

```swift
temporary_balances = {} for (trade in trades) { 
 quantity :=
    trade.quantity cost := trade.quantity \* trade.price
    temporary_balances[trade.buyer]['quote'] -= cost
    temporary_balances[trade.buyer]['base'] += quantity
    temporary_balances[trade.seller]['quote'] += cost
    temporary_balances[trade.seller]['base'] -= quantity 
}

for (user in keys(temporary_balances)) { 
  real_balances[user]['quote'] +=
    temporary_balances[user]['quote'] real_balances[user]['base'] +=
    temporary_balances[user]['base']
}
```

In the above pseudocode, temporary_balances is what the BACKBONE refers
to as a settlement group. The settlement group is a transformation of
the data in a set of trades that can be more efficiently applied to
update user balances. An exchange using the BACKBONE will periodically
submit settlement groups to be applied. The BACKBONE validates a
settlement group by ensuring the net of each asset sums to zero. Trading
Limits

For settlement to be secure, the balance updates must be preauthorized
by the user. In systems where each trade is applied individually, the
system can require a signed message from each side of the trade. For
example, the buyer may sign a message like “willing to buy 1 ETH at 90
USD”. The seller would then sign a complimentary message such as
“authorize sell of 1 ETH at 90 USD with order …”. Systems such as 0x and
IDEX use this method.

The BACKBONE takes a new approach to secure settlements. Off-chain, the
user signs a trading limit with the exchange. The trading limit has the
following attributes:

`min_quote_qty`: The smallest value the quote balance can be updated to.
Limits the quantity that can be purchased.

`min_base_qty`: The smallest value the base balance can be updated to.
Limits the quantity that can be sold.

`max_long_price`: The maximum average price allowed to purchase the asset.

`min_short_price`: The minimum average price allowed to sell the asset.

`quote_shift`: A value used to shift the quote_quantity used in
calculation to realize a loss / profit in the quote asset.

`base_shift`: A value used to shift the base_quantity used in calculation
to realize a loss / profit in the base asset.

As an example, here are a few values with a description of the limit.

`min_quote_qty`: -10 min_base_qty: 0 max_long_price: 123.45
`min_short_price`: 99999999999

Can spend upto 10 USD on ETH at a maximum price of 123.45 USD/ETH

`min_quote_qty`: 0 min_base_qty: -0.3 max_long_price: 0 min_short_price:
100.0

Can sell upto 0.3 ETH at a minimum price of 100.00 USD/ETH.

`min_quote_qty`: -10 min_base_qty: -0.3 max_long_price: 123.45
min_short_price: 100.0

Can spend upto 10 USD on ETH at a maximum price of 123.45 USD/ETH or
sell upto 0.3 ETH at a minimum price of 100.00 USD/ETH.

The balance update can only be applied if it fits within the trading
limit. The pseudocode for verifying a staged balance update is the
following.

/_ limit does not apply for deposits / widthdraws _/ quote_qty :=
staged.quote_balance + total_quote_withdraws - total_quote_deposits
base_qty := staged.base_balance + total_base_withdraws -
total_base_deposits

quote_qty += limit.quote_shift base_qty += limit.base_shift

if (quote_qty < limit.min_quote_qty) REVERT; if (base_qty <
limit.min_base_qty) REVERT;

if (base_qty >= 0 && quote_qty >= 0) COMMIT; if (base_qty <= 0 &&
quote_qty <= 0) REVERT;

#### long position 

/_ Long position _/ if (base_qty > 0) { current_price :=
(-quote_qty \* 100000000) / base_qty; if (current_price <=
limit.max_long_price) COMMIT; REVERT; }

#### short position

/_ Short position _/ else { current_price := (quote_qty \* 100000000) /
-base_qty; if (current_price >= asset_state.min_short_price) COMMIT;
REVERT; }

## Deposits

All deposits are held and managed by the BACKBONE. Users lock deposits
for trading with an exchange using a timestamp. When locked, users are
unable to directly withdraw or transfer their deposits. This ensures the
exchange is able to prepare settlement groups with the confidence that
when applied, the deposits will be available for settlement. When
locked, withdraws can only occur with cooperation from the exchange.
Once the timestamp is reached, the deposits are unlocked and are
returned to the full unimpeded control of the user.

## Exchange

A settlement group can only be applied if it fits within the trading
limit registered in the BACKBONE. Therefore before an exchange allows an
order to be placed, it should first collect a signed trading limit from
the user which allows for the order. If the order creates trades, the
exchange should submit the signed trading limit to the BACKBONE, then
submit a settlement group accounting for the order’s trades. Reliance On
Centralized Exchange

In settlement, the BACKBONE verifies the settlement group sums to zero
and that the resulting balance of each user fits within their trading
limits. The BACKBONE does not verify that the settlement groups
represent the trading activity on the exchange. For example, if a user
signs a trading agreement with Manifold Finance or the underlying 
venue/protocol (e.g. Sushiswap).

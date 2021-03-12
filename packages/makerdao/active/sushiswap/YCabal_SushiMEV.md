# YCabal: SushiSwap MEV Strategy

> This is a formal proposal to the community, with the
> [original discussion starting here: forum.sushiswapclassic.org/t/ycabal-monopolizing-transaction-flow-for-arbitrage-batching-with-miner-support/1910](https://forum.sushiswapclassic.org/t/ycabal-monopolizing-transaction-flow-for-arbitrage-batching-with-miner-support/1910)

#### [Full Proposal Details, Rulebook, Governance and API Documentation can be found at the Backbone Knowledge Base :link: backbone-kb.netlify.app](https://backbone-kb.netlify.app)

## 📚 Summary

> Introduce a permissioned RPC network layer connected to MEV-enabled
> mining pools so that we can aggregate transactions en-route to be
> mined, analyze them, create the necessary arbitrage transactions from
> those aggregated transactions (in real time) and batch send them to
> the mining pools. Arbitrage profits are then refunded back to the
> originating user account in the form of either:

- Ethereum
- XSushi
- Stablecoin
- Other Asset

Arbitrage profits are split between:

- Mining pools (25%)
- SushiSwap community (50%)
- Manifold Finance (25%)

### 📈 Financial Estimations

Estimates can be drilled down once market scope is established. Rough
estimates based on trailing 30 day volume of the top 10 markets ranges
from a low of $40,000 USD to a high of $380,000 weekly in potential
arbitrage profits (gross). _Note that this is an estimation and should
not be taken as financial advice or any sort of guarantee of profits_.

## 🔮 Abstract

> BackBone Cabal is a 'strategy' that utilizes MEV, or Miner Extracted
> Value. By leveraging the **transactional flow of the sushiswap
> community** we can provide **near feeless transactions for the
> sushiswap community, in a 100% sustainable, non-subsidizing way.** The
> potential for 'surplus' profits also exists, which means the community
> will have to decide how best to allocate such returns (e.g. funding
> developer grants, etc).

As SushiSwap grows, so does the potential for _multichain_ arbitrage
opportunities. Additional expanded avenues also arise as new products
come into production (e.g. protecting liquidations from being front run,
etc).

## ✅ Motivation

> The Motivation behind this can be seen between these two images below.
> Right now, all trades are public. This means that arbitrage bots can
> front run and back run transactions much more easily as the entire
> _transactional state_ can be seen. **By deploying a two step process
> of 1) Aggregation and 2) Bundling our own Arbitrage transactions, we
> are able to return these arbitrage profits to the people who created
> those opportunities in the first place: you.**

### Transactions as they are now

![normal_tx_flow|690x408](upload://dcPAL0R20FzdeWSVsILDq2ysGu2.png)

### Transactions as they would be

![backbone_tx_flow|689x426](upload://rJp3ix9El7iBGGK4HZIxxQHkSru.png)

## 🧰 Specification

> Implementation details are important, but what is most important is UX
> (user experience). Metamask is finally enabling a 1-click Network RPC
> configuration mechanism. This means you will just have to click a
> button as opposed to manually copy and pasting information into
> Metamask.

In fact, we have re-examined the entire ecosystem for better ways of
communicating gas costs to users and have came with a few takeaways and
services for the Sushiswap community:

- ercgas.org - EthGasStation as it should be. Gwei prices are given in
  terms of percentile distribution.

- [SushiSwap Chrome Extension](https://github.com/backbonecabal/sushiswap-gas-watcher):
  This chrome extension (and firefox) provides gwei pricing. We plan on
  implementing a websocket and Web3 Provider through this extension down
  the line to help provide real time updates for the exchange front end
  and to help facilitate better connectivity for more sophisticated
  traders (Metamask does not support Websockets).

- SushiSwap MEV API: An
  [OpenAPI3 contract specification lives here: manifoldfinance.github.io/open-sushi/](https://manifoldfinance.github.io/open-sushi/).
  Take note that we plan on providing useful endpoints like
  `/api/v1/solvable_orders` as an example.

### 📐 Backbone Specification

[Backbone Knowledge Base](http://backbone-kb.netlify.app/) - This
contains documentation relating to the technical and authoritative
implementation details for Backbone Cabal. This is where the
documentation for the strategy lives. Details like _the rulebook_ can be
found here.

#### 🔓 Formally Verified Specification

[Defined in TLA+, the reference for the network concurrency model can be found via: github.com/manifoldfinance/tla-spec](https://github.com/manifoldfinance/tla-spec).

[A concurrency and _naive_ simulator built in Go if you would like something a bit more hands on: github.com/sambacha/capacity](https://github.com/sambacha/capacity).

[DevOps/Infrastructure Specification and Requirements can be found here: github.com/sambacha/ycabal-spec](https://github.com/sambacha/ycabal-spec)

## 📍 Questions for the community

- **Which markets should be eligible?** Almost 'gas free' transactions
  are a huge incentive to bring liquidity, so by identifying specific
  markets the possibility for larger effects is possible vs. every
  market being eligible

- **Surplus profits**: How should thi be accounted?

- **Rulebook**: while still a _draft_ document, we tried to anticipate
  any potential issues (i.e. _misbehavior_) on the part of malicious
  actors. We also realize that managing such a platform brings the
  possibility of DDoS and other Outages. In the event of a network
  outage the rulebook defines the terms for reimbursement and other
  obligations. _Note_: this scenario wouldn't affect more than 5-8
  blocks worth of trades at most, as our fail safe would just broadcast
  transactions on the public mempool.

### 💯 TL:DR

Monopolize SushiSwap transaction flow and leverage that into arbitrage
trades that no one else can see. Profits are redistributed back to users
who submitted trades in the first place in the form of eliminating their
transaction cost (up to 90%). This enables scaling SushiSwap without
having to change any of the contracts, and provides SushiSwap users with
an advantage against other exchanges / pools by having its transactional
flow sent privately (as opposed to public).

SushiSwap pays $0 upfront or ongoing.

SushiSwap users get to claw back slippage and gas costs, seamlessly,
with the click of a button (opt-in).

A beta test network can be live in production by mid April, with full
scale production in early May.

### 🦍 Closing Remarks

https://youtu.be/9Qj0RrSmQEo

## Poll

[poll type=regular results=always chartType=bar]

# Proposal: YCabal MEV Strategy

- yes lets be like the bulls (yes to proposal)
- no for the proposal [/poll]

#### Links / Contact

<pre>
discord: meridian 'Sam Bacha'
email: sam@manifoldfinance.com 
telegram: @sambacha
github.com/backbonecabal
github.com/manifoldfinance
t.me/manifoldfinance
https://twitter.com/foldfinance

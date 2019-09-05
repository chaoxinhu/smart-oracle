# Smart-oracle
A lightweight Ethereum based Oracle for to-B business partners usage.

# Architecture

A typical Oracle contains the following roles:

- Blockchain: the P2P networking gear, and smart contract residence to store on-chain data (which might even be Hash value).
- Consumer: the data requester and consumer on- or off-chain and will request data onto blockchain.
- Data source: the actual data source owner OFF-blockchain.

Basic architecture diagram is shown below:

```text

+------------+    +-------------+
|            |    |             |
|  Consumer  |    | Data Source |
|            |    |             |
+-------^----+ +-->-------------+
        |      |
        |      |
+------+v------v+---+-----------+
|      |        |   | Datastore |
|      | Oracle +<->+-----------+
|      |        |               |
|      +--------+               |
|                               |
|          Blockchain           |
|                               |
+-------------------------------+


```

# Workflow

Smart-oracle supports two types of query routine:

- Static dApp query.
This routine assumes that the data source can access blockchain, and the data source itself will be able to upload the data to the pre-defined or self-created smart contracts, named as "Datastore", in a self-managing period. The Oracle, on the other hand, works as a Contract Proxy which can direct inbound flows to multiple Datastore. The workflow is shown as below:

```text

+----------+                           +-------------+
| Consumer |                           | Data Source |
+----+-----+                           +----+--+-----+
     |                                      |  |
+----v--------+-----------------------+-----v--v-----+
| query       |                       |              |
|    Oracle   +----------------------->   Datastore  |
|             <-----------------------+              |
+-------------+                       |              |
|                                     +--------------+
|                    Blockchain                      |
|                                                    |
+----------------------------------------------------+

```

- The pros and cons for this routine:
    - Pros: External data source owner does not require to expose an endpoint service for clients to query, neither will it need a hidden service to track the blockchain events for all unheeded requests. Instead it only needs to send the data to Blockchain DataSource contract; therefore, any suspect on endpoint service reliability can be omitted. Oracle works in a dApp level manner and henceforth is MUCH more reliable since networking in inside the blockchain.
    - Cons: External data source must be able to send transactions to Blockchain with a signature from their private key. Also the data might experience some delays in between the data source upload period.

- Dynamic external query.
This routine assumes that the data source is unable to access blockchain and henceforth it requires explicit off-chain requests. In light of this case, Smart-oracle is using a similar approach as in Oraclize/DOS Network/Provable.

To be specific, a standard OracleInterface will be created including a dApp side *query*(), an external side whitelisted *callback*(), and optionally, a *get*(). Now dApp caller can implement this Interface and fillin their own request details in *query*(), write their own processing logic in *callback*() and obtain the results from *get*().

Aiming to improve the developing experience, we provide an OracleFactory for dApp caller and even SDK user to quickly instantiate Oracles. We also provide a standard CallbackHandler interface and several examples, which can be inserted in the *callback*() procedure to perform the real callback to caller's own function, so that caller does not need to periodically call *get*() any more.

Under the hood, there is a backend service running on top of blockchain which is tracking over all blockchain events about all unanswered requests. It reroutes them to an endpoint service handler to any possible registered endpoints to external network world. The workflow is shown as below:

```text

                                       +-----------------+
                                       |                 |
                               +-------+   Data Source   |
                               |       |                 |
+-------------+                |       +-----------------+
|             |   1            |            5            |
|  Consumer   +------+   +-----+------+                  |
|             <----+ |   |  Backend   |                  |
+-------------+  7 | |   +-----+------+                  |
                   | |         |                         |
+------------------+-v---------v----------------------+  |
|                |query   callback|                   |  |
|       2 +------+                +-----+ 3           |  |
|         |      |     Oracle     |     |             |  |
|         |      |Datastore       |     |             |  |
+---------v--+   +----------------+   +-v-------------+  |
|            |                        |               |4 |
|  Datastore |       Blockchain       |    Event      +--+
|            |                        |               |  |
+---------^--+------------------------+---------------+  |
          |                                            6 |
          +----------------------------------------------+


```

- The pros and cons for this routine:
    - Pros: External data source does not require to connect to Blockchain - only an exposed API endpoint is required.
    - Cons: Limited types of API handling technique is supported. Also, endpoint service must be reliable and robust.

# Components

In this part, the relevant smart contracts and their function signatures are listed (might change in future).

Common component:
- OracleInterface: the basic instance of an Oracle instance
    - *query*() returns (id)
    - *callback*(id, calldata bytes)
    - *get*(id) returns (bytes)
    - *setStaticDatastore*(address)
    - *setDynamicDatastore*(id, bytes)
- OracleFactory: the Oracle factory contract
    - *createOracle*(type) returns (address)
- Datastore: the on-Chain datastore contract
    - *put*(id, bytes)
    - *get*(id) returns (bytes)

For dynamic query explicitly:

- CallbackHandler: An interface contract
    - *processCallback*() method to define the following actions *after* the callback is obtained 

# Miscs

Smart-oracle is currently maintained and tested on FISCO-BCOS 2.0 Consortium Chain and will be part of the WeBankFinTech's WeLedger project.
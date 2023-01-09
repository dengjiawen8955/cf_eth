# cf_eth

Constracts of crowdfunding system based on Ethereum (blockchain)

* truffle version: 4.1.14

```go
// Interface
interface ICrowdfunding3 {
    function createActivity(uint targetMoney, uint dayNum, string memory data) external;
    function getActivity(uint id) external view returns (Activity memory);
    function getActivities(uint[] memory ids) external view returns (Activity[] memory);
    function readerJoin(uint id, string memory comment) external payable;
    function authorWithdraw(uint id) external;
    function readerWithdraw(uint aid, uint recordID) external;
    function myRecords() external view returns (JoinRecord[] memory, uint[] memory);
}
```

## Quick Start for learning

I suggest you to Remix to compile, deploy and test contracts.

* [Remix](https://remix.ethereum.org/)

## Quick Start for development

TODO:

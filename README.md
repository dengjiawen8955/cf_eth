# cf_eth

English | [简体中文](./README-zh.md)

Contracts of crowdfunding system based on Ethereum (blockchain)

* web client base on vue/web3.js: <https://github.com/dengjiawen8955/cf_web>

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

### compile

![compile1](https://markdown-1304103443.cos.ap-guangzhou.myqcloud.com/2022-02-0420230109183117.png)

## deploy

Use Remix VM to deploy contracts you don't need to pay gas fee.

Deploy to other network you need choose other options

![deploy1](https://markdown-1304103443.cos.ap-guangzhou.myqcloud.com/2022-02-0420230109183546.png)

![deploy2](https://markdown-1304103443.cos.ap-guangzhou.myqcloud.com/2022-02-0420230109183620.png)

### test

After deploy, you can test your contract.

![test1](https://markdown-1304103443.cos.ap-guangzhou.myqcloud.com/2022-02-0420230109183719.png)

### ABI

Copy ABI (Json) for client call.

![abi1](https://markdown-1304103443.cos.ap-guangzhou.myqcloud.com/2022-02-0420230109183855.png)

## Quick Start for development

install development tools

TODO:

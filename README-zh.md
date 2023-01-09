# cf_eth

基于以太坊（区块链）的众筹系统合约

* 基于 vue/web3.js 的 Web 客户端: <https://github.com/dengjiawen8955/cf_web>

```go
// 接口
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

## 快速入门学习

我建议你使用 Remix 来编译、部署和测试合约。

* [Remix](https://remix.ethereum.org/)

### compile

![compile1](https://markdown-1304103443.cos.ap-guangzhou.myqcloud.com/2022-02-0420230109183117.png)

## deploy

使用 Remix VM 部署合约无需支付 gas 费用。

部署到您需要的其他网络选择其他选项

![deploy1](https://markdown-1304103443.cos.ap-guangzhou.myqcloud.com/2022-02-0420230109183546.png)

![deploy2](https://markdown-1304103443.cos.ap-guangzhou.myqcloud.com/2022-02-0420230109183620.png)

### test

部署后，您可以测试您的合约。

![test1](https://markdown-1304103443.cos.ap-guangzhou.myqcloud.com/2022-02-0420230109183719.png)

### ABI

复制 ABI (Json) 以供客户端调用。

![abi1](https://markdown-1304103443.cos.ap-guangzhou.myqcloud.com/2022-02-0420230109183855.png)

## 开发快速入门

安装开发工具

TODO:

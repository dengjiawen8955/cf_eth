// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;


contract SingleCrowdfunding {
    // 创作者
    address public author;

    // 参与金额
    mapping(address => uint) public joined;

    // 众筹目标
    uint constant Target = 10 ether;

    // 众筹截止时间
    uint public endTime;

    // 记录当前众筹价格
    uint public price  = 0.02 ether ;

    // 作者提取资金之后，关闭众筹
    bool public closed = false;

    // 部署合约时调用，初始化作者以及众筹结束时间
    constructor() {
        author = msg.sender;
        endTime = block.timestamp + 30 days;
    }

    // 更新价格，这是一个内部函数
    function updatePrice() internal {
        uint rise = address(this).balance / 1 ether * 0.002 ether;
        price = 0.02 ether + rise;
    }

    // 用户向合约转账时 触发的回调函数
    receive () external payable {
        require(block.timestamp < endTime && !closed  , "cf is end");
        require (msg.value >= price, "less than price");
        joined[msg.sender] = msg.value;

        updatePrice();
    } 

    // 作者提取资金
    function withdrawFund() external {
        require(msg.sender == author, "you are not author");
        require(address(this).balance >= Target, "not reach target");
        closed = true;   
        payable(msg.sender).transfer(address(this).balance);
    }

    // 读者赎回资金
    function withdraw() external {
        require(block.timestamp > endTime, "end time not reach");
        require(!closed, "cf is closed, already withdraw");
        require(Target > address(this).balance, "not reach target, can not withdraw");
        
        payable(msg.sender).transfer(joined[msg.sender]);
    }
}


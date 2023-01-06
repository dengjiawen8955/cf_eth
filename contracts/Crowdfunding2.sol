// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

interface ICrowdfunding {
    // 发起一个众筹
    function createActivity(uint targetMoney, uint dayNum, string memory title, string memory desc) external;
    // 查询众筹列表
    function getActivities() external view returns (uint[] memory);
    // 查询众筹详情
    function getActivity(uint id) external view returns (uint, address, uint, uint, uint, bool, string memory, string memory);
    // 参与众筹
    function join(uint id) external payable;
    // 作者提取资金
    function authorWithdraw() external;
    // 读者提取资金
    function readerWithdraw() external;
}

struct Activity {
    uint id;
    address beneficiary;     // 发起人, 受益人
    string title;            // 标题
    string desc;             // 描述
    uint targetMoney; // 目标金额, wei
    uint currentMoney; // 当前金额, wei
    uint endTime; // 截止时间
    bool closed;  // 是否关闭
    mapping(address => uint) joined; // 参与者 -> 金额
}

contract Crowdfunding2 {
    // 创作者
    address public author;

    // id => 众筹活动
    mapping(uint => Activity) public activities;

    // 当前众筹活动id
    uint public activityId = 0;

    // 部署合约时调用，初始化作者以及众筹结束时间
    constructor() {
        author = msg.sender;
    }

    // 发起一个众筹
    function createActivity(uint targetMoney, uint dayNum, string memory title, string memory desc) external {
        activityId++;
        Activity storage newActivity = activities[activityId];
        newActivity.id = activityId;
        newActivity.beneficiary = msg.sender;
        newActivity.title = title;
        newActivity.desc = desc;
        newActivity.targetMoney = targetMoney;
        newActivity.endTime = block.timestamp + dayNum * 1 days;
        newActivity.closed = false;
        newActivity.currentMoney = 0;
    }

    // 查询众筹列表
    function getActivities() external view returns (uint[] memory) {
        uint[] memory ids = new uint[](activityId);
        for (uint i = 0; i < activityId; i++) {
            ids[i] = i + 1;
        }
        return ids;
    }

    // 查询众筹详情
    function getActivity(uint id) external view returns (uint, address, uint, uint, uint, bool, string memory, string memory) {
        Activity storage activity = activities[id];
        return (activity.id, activity.beneficiary, activity.targetMoney, activity.currentMoney, activity.endTime, activity.closed, activity.title, activity.desc);
    }

    // 读者参与众筹
    function readerJoin(uint id) external payable {
        Activity storage activity = activities[id];
        require(activity.id != 0, "a activity not exist");
        require(activity.closed == false, "a activity is closed");
        require(activity.endTime > block.timestamp, "a activity is expired");
        require(msg.value > 0, "a activity need money");
        require(msg.sender != activity.beneficiary, "a activity is author");
        activity.joined[msg.sender] += msg.value;
        activity.currentMoney += msg.value;
    }

    // 作者提取资金
    function authorWithdraw() external {
        Activity storage activity = activities[activityId];
        require(activity.id != 0, "a activity not exist");
        require(activity.closed == false, "a activity is closed");
        // require(activity.endTime < block.timestamp, "a activity is not expired");
        require(activity.beneficiary == msg.sender, "a activity is not author");
        require(activity.currentMoney >= activity.targetMoney, "a activity is not reach target money");
        activity.closed = true;
        payable(msg.sender).transfer(activity.currentMoney);
    }

    // 读者提取资金
    function readerWithdraw() external {
        Activity storage activity = activities[activityId];
        require(activity.id != 0, "a activity not exist");
        require(activity.closed == false, "a activity is closed");
        require(activity.endTime < block.timestamp, "a activity is not expired");
        require(activity.beneficiary != msg.sender, "a activity is author");
        require(activity.joined[msg.sender] > 0, "reader not joined");
        payable(msg.sender).transfer(activity.joined[msg.sender]);
    }
    
}


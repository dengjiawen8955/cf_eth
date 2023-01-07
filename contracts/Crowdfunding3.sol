// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

interface ICrowdfunding3 {
    // 发起一个众筹
    function createActivity(uint targetMoney, uint dayNum, string memory data) external;
    // 查询众筹ID列表
    function getActivitieIDs() external view returns (uint[] memory);
    // 查询众筹详情
    function getActivity(uint id) external view returns (Activity memory);
    // 批量查询众筹详情
    function getActivities(uint[] memory ids) external view returns (Activity[] memory);
    // 参与众筹
    function join(uint id, string memory comment) external payable;
    // 作者提取资金
    function authorWithdraw() external;
    // 读者退回资金
    function readerWithdraw() external;
    // 查询个人捐款记录
    function getPersonalJoinRecords() external view returns (JoinRecord[] memory);
    // 查询个人发起的众筹活动
    function getPersonalActivities() external view returns (Activity[] memory);
}

struct Activity {
    uint id;
    address beneficiary;      // 发起人, 受益人
    string data;              // 直接标题描述或者数据hash
    uint targetMoney;         // 目标金额, wei
    uint currentMoney;        // 当前金额, wei
    uint endTime;             // 截止时间
    bool closed;              // 是否关闭
    uint joinRecordID;        // 捐款记录id  
    JoinRecord[] joinRecords; // 捐款记录
}

// 捐款记录
struct JoinRecord {
    uint id;
    uint activityID;     // 捐款活动id
    address joiner; // 捐款人
    uint ts;        // 捐款时间
    uint amount;    // 捐款金额
    string comment; // 捐款留言
}

contract Crowdfunding3 {
    // 合约创作者
    address public author;

    // 所有众筹活动
    // activityID => 众筹活动
    uint public activityID = 0;
    mapping(uint => Activity) public activities;

    // 个人捐款记录
    mapping(address => JoinRecord[]) public personalJoinRecords;

    // 个人发起的众筹活动
    mapping(address => uint[]) public personalActivities;

    constructor() {
        author = msg.sender;
    }

    // 发起一个众筹
    function createActivity(uint targetMoney, uint dayNum, string memory data) external {
        activityID++;
        Activity storage activity = activities[activityID];
        activity.id = activityID;
        activity.beneficiary = msg.sender;
        activity.data = data;
        activity.targetMoney = targetMoney;
        activity.currentMoney = 0;
        activity.endTime = block.timestamp + dayNum * 1 days;
        activity.closed = false;
        activity.joinRecordID = 0;

        // 添加个人发起的众筹活动
        personalActivities[msg.sender].push(activityID);
    }

    // 查询众筹ID列表
    function getActivitieIDs() external view returns (uint[] memory) {
        uint[] memory ids = new uint[](activityID);
        for (uint i = 0; i < activityID; i++) {
            ids[i] = i + 1;
        }
        return ids;
    }

    // 查询众筹详情
    function getActivity(uint id) external view returns (Activity memory) {
        return activities[id];
    }

    // 批量查询众筹详情
    function getActivities(uint[] memory ids) external view returns (Activity[] memory) {
        Activity[] memory ret = new Activity[](ids.length);
        for (uint i = 0; i < ids.length; i++) {
            ret[i] = activities[ids[i]];
        }
        return ret;
    }

    // 读者参与众筹
    function readerJoin(uint id, string memory comment) external payable {
        Activity storage activity = activities[id];
        require(activity.id != 0, "a activity not exist");                     // 需要众筹活动存在
        require(activity.closed == false, "a activity is closed");             // 需要众筹活动未关闭 
        require(activity.endTime > block.timestamp, "a activity is expired");  // 需要众筹活动未过期
        require(msg.value > 0, "a activity need money");                       // 需要捐款金额大于0
        // require(msg.sender != activity.beneficiary, "a activity is author");   // 需要不是作者自己捐款

        // 添加读者捐款记录
        activity.joinRecordID++;
        JoinRecord memory record = JoinRecord({
            id: activity.joinRecordID,
            activityID: id,
            joiner: msg.sender,
            ts: block.timestamp,
            amount: msg.value,
            comment: comment
        });
        activity.joinRecords.push(record);
        activity.currentMoney += msg.value;

        // 个人捐款记录
        personalJoinRecords[msg.sender].push(record);
    }

    // 作者提取资金
    function authorWithdraw(uint id) external {
        Activity storage activity = activities[id];
        require(activity.id != 0, "a activity not exist");                                                // 需要众筹活动存在
        require(activity.closed == false, "a activity is closed");                                        // 需要众筹活动未关闭
        // require(activity.endTime < block.timestamp, "a activity is not expired");                      // 需要众筹活动已过期

        require(activity.beneficiary == msg.sender, "a activity is not author");                          // 需要是作者自己提取资金
        require(activity.currentMoney >= activity.targetMoney, "a activity is not reach target money");   // 需要众筹金额达到目标金额

        activity.closed = true;
        payable(msg.sender).transfer(activity.currentMoney);
    }

    // 读者退回资金
    function readerWithdraw(uint id) external {
        Activity storage activity = activities[id];
        require(activity.id != 0, "a activity not exist");                          // 需要众筹活动存在
        require(activity.closed == false, "a activity is closed");                  // 需要众筹活动未关闭
        require(activity.endTime < block.timestamp, "a activity is not expired");   // 需要众筹活动已过期
        uint amount = 0;
        for (uint i = 0; i < activity.joinRecords.length; i++) {
            if (activity.joinRecords[i].joiner == msg.sender) {
                amount += activity.joinRecords[i].amount;
            }
        }
        require(amount > 0, "a activity is not join");
        payable(msg.sender).transfer(amount);
    }
    
    // 查询个人的捐款记录
    function getPersonalJoinRecords() external view returns (JoinRecord[] memory) {
        return personalJoinRecords[msg.sender];
    }

    // 查询个人发起的众筹活动
    function getPersonalActivities() external view returns (uint[] memory) {
        return personalActivities[msg.sender];
    }
}


pragma solidity ^0.5.0;
// contract DateTimeAPI {
//         /*
//          *  Abstract contract for interfacing with the DateTime contract.
//          *
//          */
//         function isLeapYear(uint16 year) constant returns (bool);
//         function getYear(uint timestamp) constant returns (uint16);
//         function getMonth(uint timestamp) constant returns (uint8);
//         function getDay(uint timestamp) constant returns (uint8);
//         function getHour(uint timestamp) constant returns (uint8);
//         function getMinute(uint timestamp) constant returns (uint8);
//         function getSecond(uint timestamp) constant returns (uint8);
//         function getWeekday(uint timestamp) constant returns (uint8);
//         function toTimestamp(uint16 year, uint8 month, uint8 day) constant returns (uint timestamp);
//         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour) constant returns (uint timestamp);
//         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute) constant returns (uint timestamp);
//         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute, uint8 second) constant returns (uint timestamp);
// }

contract TeamManagement {
    
    struct Task {
        string description;
        uint taskId;
        string assignDate;
        string expireDate;
        uint respect;
        uint penalty;
        address assignee;
        address assigner;
        string state;
    }
     
    Task[] public tasks;
//     address public dateTimeAddr = 
//   0x92482Ba45A4D2186DafB486b322C6d0B88410FE7;
//   DateTime dateTime = DateTime(dateTimeAddr);
    
     
    // constructor TeamManagement(address creator) public{
    //   leader = creator;
    // }
    
    function getCount() public view returns(uint count) {
        return tasks.length;
    }
    
    function createTask(address assignee, string memory description, string memory assignDate,string memory expireDate, uint respect) public returns(bool success){
        Task memory t;
        t.taskId = getCount();
        t.assigner = msg.sender;
        t.assignee = assignee;
        t.state="active";
        t.respect=respect;
        t.penalty=0;
        t.description=description;
        t.assignDate= assignDate;
        t.expireDate=expireDate;
        tasks.push(t);
        return true;
    }
    
}

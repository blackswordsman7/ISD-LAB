pragma solidity ^0.4.21;
contract TeamManagement {
    
    struct Task {
        string description;
        uint taskId;
        uint256 assignDate;
        uint256 expireDate;
        uint respect;
        uint penalty;
        address assignee;
        address assigner;
        string state;
        address reviewer;  //@abhi
    }

    Task[] public tasks;
    uint[] public taskIdList;
    mapping(address => uint[]) taskByAssignee;
    mapping(address => uint[]) taskByAssigner;
    mapping(address => uint[]) taskByReviewer;
    
    address public leader;
    event taskCompleted(uint indexed _taskId, address indexed _assignee, uint indexed _respect);  //@abhi
    event taskSubmitted(uint indexed taskId , address indexed assignee  , address indexed reviewer);
     
    function TeamManagement(address creator) public{
       leader = creator;
    }
    function getCount() public view returns(uint count) {
        return tasks.length;
    }
    
    function createTask(address assignee, address _reviewer, string memory description, uint256  assignDate,uint256  expireDate, uint respect) public returns(bool success){ //@abhi added _reviewer
        Task memory t;
        t.taskId = getCount();
        t.assigner = msg.sender;
        t.assignee = assignee;
        t.reviewer = _reviewer;
        t.state="Active";   //@abhi active -> Active
        t.respect=respect;
        t.penalty=0;
        t.description=description;
        t.assignDate= assignDate;
        t.expireDate=expireDate;
        
        tasks.push(t);
        taskByAssignee[assignee].push(t.taskId);
        taskByAssigner[msg.sender].push(t.taskId);
        taskByReviewer[_reviewer].push(t.taskId);
        return true;
    }
    
    
    function SubmitWork(uint _taskId) public {
        Task storage task = tasks[_taskId];
        if(task.expireDate < now)
            task.state = "Expired";
        require(msg.sender == task.assignee && keccak256(task.state)==keccak256("Active"));
        
        //submit work 
        task.state = 'Submitted';  //@abhi
        emit taskSubmitted(_taskId, task.assignee, task.reviewer);
        
        
    }
    
    function taskOfAssignee(address _assignee) public view returns(uint[]){
        return taskByAssignee[_assignee];
    }
    
    function taskOfAssigner(address _assigner) public view returns(uint[]){
        return taskByAssigner[_assigner];
    }
    
    function taskOfReviewer(address _reviewer) public view returns(uint[]){
        return taskByAssigner[_reviewer];
    }
    
    function checkTask(uint taskId) view public returns(string){
       return tasks[taskId].state;
    }
    
    // @abhi
    function _reviewTask(uint _taskId, uint256 _expireDate)  public {
        require(msg.sender == tasks[_taskId].reviewer && keccak256(tasks[_taskId].state) == keccak256('Submitted'));
        if(true){    //conditions for review
           tasks[_taskId].state = 'Completed';
           
           //transfer (respect to assignee)
           
           emit taskCompleted(_taskId, tasks[_taskId].assignee, tasks[_taskId].respect);
        }
        else{
            // @dev deadline extension if reviewer wishes to
            tasks[_taskId].expireDate += _expireDate;  
            
            if(tasks[_taskId].expireDate > now){
                tasks[_taskId].state = 'Expired';
                
                //deduct penalty
            }
            else{
                tasks[_taskId].state = 'Active';
            }
        }
    }
    
    function updateTask(uint _taskId, address _assignee, address _reviewer, string _description, uint256 _expireDate, uint _respect, uint _penalty) public {
        require(msg.sender == tasks[_taskId].assigner && keccak256(tasks[_taskId].state) != keccak256('Completed'));
        tasks[_taskId].assignee = _assignee;
        tasks[_taskId].reviewer = _reviewer;
        tasks[_taskId].description = _description;
        tasks[_taskId].expireDate = _expireDate;
        tasks[_taskId].respect = _respect;
        tasks[_taskId].penalty =_penalty;    
        
    }  
}

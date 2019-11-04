pragma solidity ^0.4.21;

/// @title Team management appliction
/// @author ISD-14 Team
/// @notice this contract is to make a team management app on blockchain 
/// which will host a record of tasks being assigned, reviewed, completed etc.
contract TeamManagement {
    
    /// @notice this structure will hold all variables for a task
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
        address reviewer;
    }

    Task[] public tasks;
    uint[] public taskIdList;
    mapping(address => uint[]) taskByAssignee;
    mapping(address => uint[]) taskByAssigner;
    mapping(address => uint[]) taskByReviewer;
      
    address public leader;
    event taskCompleted(uint indexed _taskId, address indexed _assignee, uint indexed _respect);  //@abhi
    event taskSubmitted(uint indexed taskId , address indexed assignee  , address indexed reviewer);

    /// @notice team leader will call this function to create a instance of TeamManagement class
    /// @param address of creator  
    function TeamManagement(address creator) public{
       leader = creator;
    }

    /// @return function will return total number of tasks being assigned till now
    function getCount() public view returns(uint count) {
        return tasks.length;
    }
    
    /// @notice assigner will call this function to create a task
    /// @param assignee, reviewer, description of task, assign date, expiry date of task, respect of assignee to be increased once the task is finished on time
    /// @return task is created or not
    function createTask(address assignee, address _reviewer, string memory description, uint256 assignDate, uint256  expireDate, uint respect) public returns(bool success){
        Task memory t;
        t.taskId = getCount();
        t.assigner = msg.sender;
        t.assignee = assignee;
        t.reviewer = _reviewer;
        t.state="Active";
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
    
    /// @notice called by assignee to put a submit request
    /// @param task id
    function SubmitWork(uint _taskId) public {
        Task storage task = tasks[_taskId];
        if(task.expireDate < now)
            task.state = "Expired";
        require(msg.sender == task.assignee && keccak256(task.state)==keccak256("Active"));
        
        //submit work 
        task.state = 'Submitted';
        emit taskSubmitted(_taskId, task.assignee, task.reviewer);
        
        
    }
    
    /// @notice to get task assigned to a assignee
    /// @param assignee
    function taskOfAssignee(address _assignee) public view returns(uint[]){
        return taskByAssignee[_assignee];
    }

    /// @notice to get task assigned by assigner
    /// @param assigner
    function taskOfAssigner(address _assigner) public view returns(uint[]){
        return taskByAssigner[_assigner];
    }
    
    /// @notice to get task to be reviewed by a reviewer
    /// @param reviewer
    function taskOfReviewer(address _reviewer) public view returns(uint[]){
        return taskByAssigner[_reviewer];
    }
    
    /// @notice to check status of a task
    /// @param id of task
    function checkTask(uint taskId) view public returns(string){
       return tasks[taskId].state;
    }
    
    /// @notice to review a task by reviewer which has been submitted by assignee
    /// @param id of task, expiry date
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
    
    /// @notice called to update any parameter of a task
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

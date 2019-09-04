pragma solidity ^0.5.0;
contract SimpleBank {
    //Mapping the address of users to an unsigned integer which is his userBalance
    //Making it private to protect from other contracts
    mapping(address=>uint) private userBalance;
    
    //if the user address is equal to default value then it is not present in mapping
    //and hence not a user
    function checkUser(address key) public view returns(bool){
        if(userBalance[key]==0)
            return false;
        return true;
    }
    
    //variable set to public so that everyone can know who is the owner of the bank
    address public owner;
    
    //event with 1 argument accountAddress
    event LogCustom(address accountAddress);
    
    //event with 2 arguments accountAddress and amount
    event LogCustom1(address accountAddress,uint amount);
    
    //event LogWithdrawal with 3 arguments accountAddress, withdrawAmount, newBalance
    event LogWithdrawal(address accountAddress, uint withdrawAmount, uint newBalance);
    
    //event
    event LogNotDeposited(address accountAddress, string s);
    
    //global variable for sender to be accessed only by functions in this contract
    //we can create a getter to view this
    address private sender;
    
    //Fallback Function
    function() external{
        revert();
    }
    
    //Function to get the balance of the user, view prevents the function from editing
    function getBalance() public view returns(uint){
        address user = msg.sender;
        return userBalance[user];
    }
    
    //enrolls a user in the bank
    function enroll() public returns(string memory enrollMsg){
        sender=msg.sender;
        userBalance[sender]=1000;
        emit LogCustom1(sender,userBalance[sender]);
        return "User Enrolled Successfully";
    }
    
    //deposits the money to the bank
    function deposit(uint amount) public payable returns(uint balanceAfterDeposit){
        sender=msg.sender;
        
        require(checkUser(sender));
        
        userBalance[sender]+=amount;
        emit LogCustom1(sender,userBalance[sender]);
        
        return userBalance[sender];
    }
    
    //function for withdrawal of money from bank
    function withdraw(uint moneyToWithdraw) public returns (uint remainingBalance){
        address payable user = msg.sender;
        require(userBalance[user]>=moneyToWithdraw);
        userBalance[user]-=moneyToWithdraw;
        user.transfer(moneyToWithdraw);
        return userBalance[user];
    }
}

// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;
import "hardhat/console.sol";

contract MultiStageEscrow {
    address public depositor;
    address payable public beneficiary;
    address public arbiter;
    bool public isApproved = false;

    bool[] public stagePaid;
    uint[] public stageFee;
    
    constructor(address _arbiter, address payable _beneficiary, address _depositor, uint[] memory _stageFee, bool[] memory _stagePaid) payable{
        arbiter = _arbiter;
        beneficiary = _beneficiary;
        depositor = _depositor;
        stageFee = _stageFee;
        stagePaid = _stagePaid;
    }

    event SufficientFunds(uint funds, uint balance, bool isApproved);
    function checkFunds() external{
        require(msg.sender == arbiter);
        uint totalFees = sumFees();
        if(address(this).balance >= totalFees){ 
            isApproved = true;
        }
        emit SufficientFunds(totalFees, address(this).balance, isApproved);
    }

    function sumFees() internal view returns(uint){
        uint sum = 0;
        for(uint i = 0 ; i < stageFee.length ; i++){
            sum += stageFee[i];
        }
        return sum;
    }

    event StagePaid(uint balanceSent, bool[] stage); 
    function approveStagePayment(uint stage) external{
        require(msg.sender == arbiter);
        require(address(this).balance >= stageFee[stage]);
        (bool sent, ) = beneficiary.call{ value:  stageFee[stage] }("");
        require(sent, "Failed to send ether");
        console.log('fee for stage' , stage, 'sent to beneficiary');
        stagePaid[stage] = true;
        emit StagePaid(stageFee[stage], stagePaid);
    }

    function logging() external view {
        console.log(beneficiary, depositor, arbiter);
        for(uint i = 0; i < stageFee.length ; i++){
            console.log('fees:', stageFee[i]);
        }
    }
    
    event ETHReceived(address senderAddr, uint value, uint balance, bool isApproved);
    receive() external payable {
        emit ETHReceived(msg.sender, msg.value, address(this).balance, isApproved);
    }

    function getStagePaid() public view returns(bool[] memory){
        return stagePaid;
    }

    function getStageFee() public view returns(uint[] memory){
        return stageFee;
    }

}


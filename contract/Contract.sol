// SPDX-License-Identifier: MIT

pragma solidity 0.8.11;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";


contract Contract is Ownable, Pausable {

    uint8 public population_max_base = 0; // Per team
    uint8 public number_of_team = 2;

    uint8 public number_investor = 0;

    uint256 public base_amount = 0;

    struct Investor{
        uint8 team_id;
        string discord_username;
        address investor_address;
        uint256 timestamp;
        bool isUser;
    }

    struct Team{
        string name;
        uint8 number_of_members;
        uint8 population_max;
        uint256 balance;
    }

    mapping(uint8 => Investor) public investors;


    mapping(uint8 => Team) public teams;

    constructor() {
        population_max_base = 10;
        base_amount = 0.08*10**18;

        teams[0] = Team("Equipe Dynatos", 0, population_max_base, 0);

        teams[1] = Team("Equipe Ryzer", 0, population_max_base, 0);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    modifier userDontExist() {
        bool userExist = false;
        for(uint8 i = 1; i <= number_investor; i++){
            if(investors[i].investor_address == msg.sender){
                userExist=true;
            }
        }
        require(!userExist, "Cet utilisateur existe deja");
        _;
    }


    function fund(uint8 _team_id, string memory _discord_username) public payable whenNotPaused userDontExist {
        string memory message = Strings.toString(base_amount);
        require(msg.value == base_amount, string(abi.encodePacked("The fund must be ", message, "BNB")));
        require(_team_id < number_of_team, "This team does not exist");
        require(teams[_team_id].number_of_members < teams[_team_id].population_max, "This team is full");

        teams[_team_id].balance += msg.value;
        teams[_team_id].number_of_members++;

        number_investor++;
        investors[number_investor] = Investor(_team_id, _discord_username, msg.sender, block.timestamp, true);
    }

    function withdraw(uint256 _amount, uint8 _team) public onlyOwner whenNotPaused {
        require(teams[_team].balance >= _amount, "Cette equipe ne dispose pas des fonds necessaires");
        teams[_team].balance -= _amount;
        payable(msg.sender).transfer(_amount);
    }

    function fundAdmin(uint8 _team) public payable onlyOwner whenNotPaused {
        teams[_team].balance += msg.value;
    }

    function withdrawAll() public onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    function get_total() public view returns(uint256){
        return address(this).balance;
    }

    function set_max_member(uint8 _number) public onlyOwner {
        teams[0].population_max = _number;
        teams[1].population_max = _number;
    }

    function get_all_investors() public view returns(Investor[] memory){
        Investor[] memory local_investors = new Investor[](number_investor);
        for(uint8 i = 0; i < number_investor; i++){
            if(investors[i+1].isUser){
                local_investors[i] = investors[i+1];
            }
        }
        
        return local_investors;
    }

    function fire(uint8 _investor) public onlyOwner {
        require(investors[_investor].isUser, "This user does not exist");

        Investor memory localSave = investors[_investor];
        delete investors[_investor];

        teams[localSave.team_id].balance -= base_amount;

        teams[localSave.team_id].number_of_members --;
    }
}
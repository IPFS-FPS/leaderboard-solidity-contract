pragma solidity >=0.6.6;

contract Leaderboard {
  address owner;

  uint leaderboardLength = 10;

  mapping (uint => User) public leaderboard;
    
  struct User {
    string user;
    uint score;
  }
    
  constructor() public{
    owner = msg.sender;
  }

  modifier onlyOwner(){
    require(owner == msg.sender, "Sender not authorized");
    _;
  }

  function addScore(string memory user, uint score) onlyOwner() public returns (bool) {
    if (leaderboard[leaderboardLength-1].score >= score) return false;

    for (uint i=0; i<leaderboardLength; i++) {
      if (leaderboard[i].score < score) {

        User memory currentUser = leaderboard[i];
        for (uint j=i+1; j<leaderboardLength+1; j++) {
          User memory nextUser = leaderboard[j];
          leaderboard[j] = currentUser;
          currentUser = nextUser;
        }

        leaderboard[i] = User({
          user: user,
          score: score
        });

        delete leaderboard[leaderboardLength];

        return true;
      }
    }
  }
}

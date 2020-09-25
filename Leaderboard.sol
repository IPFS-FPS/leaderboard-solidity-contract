pragma solidity >=0.6.6;

// lower score means higher ranking
contract Leaderboard {
  address owner;

  // list top 10 users
  uint leaderboardLength = 10;

  mapping (uint => User) public leaderboard;
    
  struct User {
    string user;
    uint score;
  }
    
  constructor() public{
    owner = msg.sender;
    // insert user with max scores
    for (uint i=0; i<leaderboardLength; i++) {
      leaderboard[i] = User({
        user: "---",
        score: 9999 // up to 2**256-1
      });
    }
  }

  modifier onlyOwner(){
    require(owner == msg.sender, "Sender not authorized");
    _;
  }

  function addScore(string memory user, uint score) onlyOwner() public returns (bool) {
    // user didn't make it to leaderboard
    if (leaderboard[leaderboardLength-1].score <= score) return false;

    for (uint i=0; i<leaderboardLength; i++) {
      if (leaderboard[i].score > score) {

        // shift leaderboard
        User memory currentUser = leaderboard[i];
        for (uint j=i+1; j<leaderboardLength+1; j++) {
          User memory nextUser = leaderboard[j];
          leaderboard[j] = currentUser;
          currentUser = nextUser;
        }

        // insert
        leaderboard[i] = User({
          user: user,
          score: score
        });

        // delete last from list
        delete leaderboard[leaderboardLength];

        return true;
      }
    }
  }
}

pragma solidity ^0.4.17;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/TicTacToe.sol";

contract TestTicTacToe {
  TicTacToe ticTacToe = TicTacToe(DeployedAddresses.TicTacToe());

  function testUserCanCreateGame() public {
    uint id = ticTacToe.createGame(this);
    Assert.equal(id, 1, 'User can create a game');
  }

  function testUserCanGetGame() public {
    uint id = ticTacToe.createGame(this);

    uint8[9] memory board;
    address xPlayer;
    address oPlayer;
    bool xTurn;
    bool gameOver;
    bool xWon;

    (board,xPlayer,oPlayer,xTurn,gameOver,xWon) = ticTacToe.getGame(id);
    Assert.equal(xPlayer, this, 'xPlayer address is set to this');
  }
}
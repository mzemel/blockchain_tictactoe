pragma solidity ^0.4.10;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/TicTacToe.sol";

contract TestTicTacToe {
  TicTacToe ticTacToe = TicTacToe(DeployedAddresses.TicTacToe());

  // Do I really need to copy over this data structure?
  struct Game {
    address xPlayer;
    address oPlayer;
    bool xTurn;
    bool gameOver;
    bool xWon;
    bytes32 board;
  }

  function testUserCanGetGame() {
    address gameAddress;

    var(xPlayer, oPlayer, xTurn, gameOver, xWon, board) = ticTacToe.games(gameAddress);

    Assert.equal(xTurn, false, 'New games start with Os turn.');
    Assert.equal(gameOver, false, 'New games are not over.');
  }

  function testUserCanCreateGame() {
    address gameAddress;
    address opponent;

    bool success = ticTacToe.createGame(gameAddress, opponent);

    Assert.equal(success, true, 'Game has been created.');

    var(xPlayer, oPlayer, xTurn, gameOver, xWon, board) = ticTacToe.games(gameAddress);

    Assert.equal(xPlayer, opponent, 'Opponent is X player.');
    Assert.equal(oPlayer, this, 'Self is O player.');
  }
}
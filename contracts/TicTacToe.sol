pragma solidity ^0.4.19;

contract TicTacToe {
  struct Game {
    uint[9] board;
    address xPlayer;
    address oPlayer;
    bool xTurn;
    bool gameOver;
    bool xWon;
  }

  Game[] public games;

  function createGame(address _oPlayerAddr) public returns(uint) {
    uint id = games.push(
      Game(
        [uint(0),uint(0),uint(0),uint(0),uint(0),uint(0),uint(0),uint(0),uint(0)],
        msg.sender,
        _oPlayerAddr,
        true,
        false,
        false
      )
    ) - 1;
    return id;
  }

  function getGame(uint _id) external view returns (
    uint[9] board,
    address xPlayer,
    address oPlayer,
    bool xTurn,
    bool gameOver,
    bool xWon
  ) {
    Game storage game = games[_id];

    board = game.board;
    xPlayer = game.xPlayer;
    oPlayer = game.oPlayer;
    xTurn = game.xTurn;
    gameOver = game.gameOver;
    xWon = game.xWon;
  }
}
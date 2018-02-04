pragma solidity ^0.4.17;

contract TicTacToe {
  struct Game {
    uint8[9] board;
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
        [0,0,0,0,0,0,0,0,0],
        msg.sender,
        _oPlayerAddr,
        true,
        false,
        false
      )
    );
    return id;
  }

  function getGame(uint _id) external view returns (
    uint8[9] board,
    address xPlayer,
    address oPlayer,
    bool xTurn,
    bool gameOver,
    bool xWon
  ) {
    Game memory game = games[_id];

    board = game.board;
    xPlayer = game.xPlayer;
    oPlayer = game.oPlayer;
    xTurn = game.xTurn;
    gameOver = game.gameOver;
    xWon = game.xWon;
  }
}
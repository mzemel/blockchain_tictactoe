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
    Game memory game = games[_id];

    board = game.board;
    xPlayer = game.xPlayer;
    oPlayer = game.oPlayer;
    xTurn = game.xTurn;
    gameOver = game.gameOver;
    xWon = game.xWon;
  }

  function enterMove(uint _id, uint position, uint value) public {
    Game storage game = games[_id];
    game.board[position] = value;
    game.xTurn = !game.xTurn;

    bool _gameOver;
    bool _xWon;

    (_gameOver, _xWon) = _checkGameOver(_id);

    if(_gameOver) {
      game.gameOver = _gameOver;
      game.xWon = _xWon;
    }
  }

  function _checkGameOver(uint _id) internal view returns (
    bool _gameOver,
    bool _xWon
  ) {
    uint[9] memory board = games[_id].board;

    _gameOver = false;
    _xWon = false;

    if(
      (board[0] == 1 && board[1] == 1 && board[2] == 1) ||
      (board[3] == 1 && board[4] == 1 && board[5] == 1) ||
      (board[6] == 1 && board[7] == 1 && board[8] == 1) ||
      (board[0] == 1 && board[3] == 1 && board[6] == 1) ||
      (board[1] == 1 && board[4] == 1 && board[7] == 1) ||
      (board[2] == 1 && board[5] == 1 && board[8] == 1) ||
      (board[0] == 1 && board[4] == 1 && board[8] == 1) ||
      (board[2] == 1 && board[4] == 1 && board[6] == 1)
    ) {
      _gameOver = true;
      _xWon = true;
    }

    if(
      (board[0] == 2 && board[1] == 2 && board[2] == 2) ||
      (board[3] == 2 && board[4] == 2 && board[5] == 2) ||
      (board[6] == 2 && board[7] == 2 && board[8] == 2) ||
      (board[0] == 2 && board[3] == 2 && board[6] == 2) ||
      (board[1] == 2 && board[4] == 2 && board[7] == 2) ||
      (board[2] == 2 && board[5] == 2 && board[8] == 2) ||
      (board[0] == 2 && board[4] == 2 && board[8] == 2) ||
      (board[2] == 2 && board[4] == 2 && board[6] == 2)
    ) {
      _gameOver = true;
    }
  }
}
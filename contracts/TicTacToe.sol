pragma solidity ^0.4.19;

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
  mapping (address => uint) public myLastGame;
  mapping (address => uint8) numberOfGames;

  function createGame(address _oPlayerAddr) public returns(uint) {
    uint id = games.push(
      Game(
        [uint8(0),uint8(0),uint8(0),uint8(0),uint8(0),uint8(0),uint8(0),uint8(0),uint8(0)],
        msg.sender,
        _oPlayerAddr,
        true,
        false,
        false
      )
    ) - 1;
    myLastGame[msg.sender] = id;
    numberOfGames[msg.sender]++;
    myLastGame[_oPlayerAddr] = id;
    numberOfGames[_oPlayerAddr]++;
    return id;
  }

  function clearGame() public {
    Game memory game = games[myLastGame[msg.sender]];
    myLastGame[msg.sender] = 0;
    numberOfGames[msg.sender]--;
    myLastGame[game.oPlayer] = 0;
    numberOfGames[game.oPlayer]--;
    // delete games[myLastGame[msg.sender]];
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

  function getNumberOfGames(address _address) public returns (uint8) {
    return numberOfGames[_address];
  }

  function enterMove(uint _id, uint position, uint value) public {
    Game storage game = games[_id];
    game.board[position] = uint8(value);
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
    uint8[9] memory board = games[_id].board;

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
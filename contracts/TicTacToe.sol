pragma solidity ^0.4.19;

contract TicTacToe {
  struct Game {
    uint tl;
    uint tc;
    uint tr;
    uint cl;
    uint cc;
    uint cr;
    uint bl;
    uint bc;
    uint br;
    address xPlayer;
    address oPlayer;
    bool xTurn;
    bool gameOver;
    bool xWon;
  }

  Game[] public games;
  mapping (address => uint) public myLastGame;

  function createGame(address _oPlayerAddr) public returns(uint) {
    uint id = games.push(
      Game(
        0,0,0,0,0,0,0,0,0,
        msg.sender,
        _oPlayerAddr,
        true,
        false,
        false
      )
    ) - 1;
    myLastGame[msg.sender] = id;
    myLastGame[_oPlayerAddr] = id;
    return id;
  }

  function clearGame() public {
    myLastGame[msg.sender] = 0;
  }

  function getGame(uint _id) external view returns (
    uint tl,
    uint tc,
    uint tr,
    uint cl,
    uint cc,
    uint cr,
    uint bl,
    uint bc,
    uint br,
    address xPlayer,
    address oPlayer,
    bool xTurn,
    bool gameOver,
    bool xWon
  ) {
    Game memory game = games[_id];

    tl = game.tl;
    tc = game.tc;
    tr = game.tr;
    cl = game.cl;
    cc = game.cc;
    cr = game.cr;
    bl = game.bl;
    bc = game.bc;
    br = game.br;
    xPlayer = game.xPlayer;
    oPlayer = game.oPlayer;
    xTurn = game.xTurn;
    gameOver = game.gameOver;
    xWon = game.xWon;
  }

  function enterMove(uint _id, uint position, uint value) public {
    Game storage game = games[_id];
    if (position == 0) { game.tl = value; }
    if (position == 1) { game.tc = value; }
    if (position == 2) { game.tr = value; }
    if (position == 3) { game.cl = value; }
    if (position == 4) { game.cc = value; }
    if (position == 5) { game.cr = value; }
    if (position == 6) { game.bl = value; }
    if (position == 7) { game.bc = value; }
    if (position == 8) { game.br = value; }
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
    Game memory game = games[_id];
    uint tl = game.tl;
    uint tc = game.tc;
    uint tr = game.tr;
    uint cl = game.cl;
    uint cc = game.cc;
    uint cr = game.cr;
    uint bl = game.bl;
    uint bc = game.bc;
    uint br = game.br;

    _gameOver = false;
    _xWon = false;

    if(
      (tl == 1 && tc == 1 && tr == 1) ||
      (cl == 1 && cc == 1 && cr == 1) ||
      (bl == 1 && bc == 1 && br == 1) ||
      (tl == 1 && cl == 1 && bl == 1) ||
      (tc == 1 && cc == 1 && bc == 1) ||
      (tr == 1 && cr == 1 && br == 1) ||
      (tl == 1 && cc == 1 && br == 1) ||
      (tr == 1 && cc == 1 && bl == 1)
    ) {
      _gameOver = true;
      _xWon = true;
    }

    if(
      (tl == 2 && tc == 2 && tr == 2) ||
      (cl == 2 && cc == 2 && cr == 2) ||
      (bl == 2 && bc == 2 && br == 2) ||
      (tl == 2 && cl == 2 && bl == 2) ||
      (tc == 2 && cc == 2 && bc == 2) ||
      (tr == 2 && cr == 2 && br == 2) ||
      (tl == 2 && cc == 2 && br == 2) ||
      (tr == 2 && cc == 2 && bl == 2)
    ) {
      _gameOver = true;
    }
  }
}
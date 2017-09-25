pragma solidity ^0.4.10;

contract TicTacToe {
  public games mapping(address => Game)

  Game {
    xPlayer: address,
    oPlayer: address,
    xTurn: bool,
    gameOver: bool,
    xWon: bool,
    board: square[9]
  }

  Square {
    hasPiece: bool,
    pieceIsX: bool
  }

  function getGame(address gameAddress) returns Game {
    games[gameAddress];
  }

  function createGame(address gameAddress, address opponent) returns Game {
    // Fetch Game struct by random address
    // Check to see it's not being used?
    // Initialize it and return its address
    Game game = games[gameAddress];
    require(game.xPlayer == address(0) && game.oPlayer == address(0));
    game.oPlayer = msg.sender;
    game.xPlayer = opponent;
  }

  function move(address gameAddress, int8 squareIndex) {
    Game game = games[gameAddress]; // TODO: Ensure there is a valid game at that address
    bool playerIsX;

    if(game.xTurn) {
      require(msg.sender == game.xAddress);
      playerIsX = true;
    } else {
      require(msg.sender == game.oAddress);
      playerIsX = false;
    }

    Square square = game.squares[squareIndex];
    require(square.hasPiece == false);

    square.hasPiece = true;
    square.pieceIsX = playerIsX;

    game.xTurn = !game.xTurn;
  }

  function winner(gameAddress) returns address {
    Game game = games[gameAddress];
    require(game.gameOver() == true);

    if (game.xWon) {
      return game.xPlayer;
    } else {
      return game.oPlayer;
    }
  }
}

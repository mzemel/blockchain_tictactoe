pragma solidity ^0.4.10;

contract TicTacToe {
  mapping(address => Game) public games;

  struct Game {
    address xPlayer;
    address oPlayer;
    bool xTurn;
    bool gameOver;
    bool xWon;
    bytes32 board;
  }

  function createGame(address gameAddress, address opponent) returns (bool) {
    Game game = games[gameAddress];
    require(game.xPlayer == address(0) && game.oPlayer == address(0));
    game.oPlayer = msg.sender;
    game.xPlayer = opponent;

    return true;
  }

  // function move(address gameAddress, int8 squareIndex) {
  //   Game game = games[gameAddress]; // TODO: Ensure there is a valid game at that address
  //   bool playerIsX;

  //   if(game.xTurn) {
  //     require(msg.sender == game.xAddress);
  //     playerIsX = true;
  //   } else {
  //     require(msg.sender == game.oAddress);
  //     playerIsX = false;
  //   }

  //   Square square = game.squares[squareIndex];
  //   require(square.hasPiece == false);

  //   square.hasPiece = true;
  //   square.pieceIsX = playerIsX;

  //   game.xTurn = !game.xTurn;
  // }

  // function winner(address gameAddress) returns (address) {
  //   Game game = games[gameAddress];
  //   require(game.gameOver == true);

  //   if (game.xWon) {
  //     return game.xPlayer;
  //   } else {
  //     return game.oPlayer;
  //   }
  // }
}

// Specifically request an abstraction for TicTacToe
var TicTacToe = artifacts.require("TicTacToe");

contract('TicTacToe', function(accounts) {
  var ticTacToe;

  function toGame(destructuredGame) {
    return {
      board: destructuredGame[0],
      xPlayer: destructuredGame[1],
      oPlayer: destructuredGame[2],
      xTurn: destructuredGame[3],
      gameOver: destructuredGame[4],
      xWon: destructuredGame[5]
    }
  }

  it("should let a user create a game", function() {
    return TicTacToe.deployed().then(function(instance) {
      return instance.createGame.call(accounts[0]);
    }).then(function(id) {
      assert.equal(id, 0, "test run succeeds");
    });
  });


  it("should let a user get a game", function() {
    return TicTacToe.deployed().then(function(instance) {
      ticTacToe = instance;
      return ticTacToe.createGame(accounts[1]);
    }).then(function(id) {
      return ticTacToe.getGame.call(0); // Infer game is created with ID 0
    }).then(function(destructuredGame) {
      var game = toGame(destructuredGame);
      assert.equal(accounts[1], game.oPlayer, "oPlayer is set correctly on the game");
      assert.equal(game.board[0], 0, "Board is initialized to 0");
    });
  })
});
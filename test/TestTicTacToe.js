// Specifically request an abstraction for TicTacToe
var TicTacToe = artifacts.require("TicTacToe");

contract('TicTacToe', function(accounts) {
  var ticTacToe;

  function toGame(data) {
    return {
      board: [
        data[0],
        data[1],
        data[2],
        data[3],
        data[4],
        data[5],
        data[6],
        data[7],
        data[8]
      ],
      xPlayer: data[9],
      oPlayer: data[10],
      xTurn: data[11],
      gameOver: data[12],
      xWon: data[13]
    }
  }

  it("should let a user create a game", function() {
    return TicTacToe.deployed().then(function(instance) {
      return instance.createGame.call(accounts[0]);
    }).then(function(id) {
      assert.equal(id, 0, "test run succeeds");
    });
  });

  it("should let a user get a game", () => {
    TicTacToe.deployed().then((instance) => {
      ticTacToe = instance;
      return ticTacToe.createGame(accounts[1]);
    }).then(id => ticTacToe.getGame.call(0))
      .then(toGame)
      .then(game => {
        assert.equal(game.oPlayer, accounts[1], "oPlayer is set correctly on the game");
        assert.equal(game.xPlayer, accounts[0], 'xPlayer is created using msg.sender')
        assert.equal(game.board[0], 0, "Board is initialized to 0");
      })
  });

  it("should let a user enter a move", function() {
    TicTacToe.deployed().then((instance) => {
      ticTacToe = instance;
      return ticTacToe.createGame(accounts[1]);
    }).then(id => ticTacToe.enterMove(0, 1, 1))
      .then(() => ticTacToe.getGame.call(0))
      .then(toGame)
      .then(game => {
        assert.equal(game.board[1], 1, "Move is applied to board");
        assert.equal(game.xTurn, false, "It is now oPlayer's turn");
      })
  });

  it("should be game over (top row, X)", function() {
    TicTacToe.deployed().then((instance) => {
      ticTacToe = instance;
      return ticTacToe.createGame(accounts[1]);
    }).then(id => ticTacToe.enterMove(1, 0, 1))
      .then(() => ticTacToe.enterMove(1, 1, 1))
      .then(() => ticTacToe.enterMove(1, 2, 1))
      .then(() => ticTacToe.getGame.call(1))
      .then(toGame)
      .then(game => {
        assert.equal(game.gameOver, true, "Game is over");
        assert.equal(game.xWon, true, "xPlayer has won");
      })
    });

  it("should be game over (left column, X)", function() {
    TicTacToe.deployed().then((instance) => {
      ticTacToe = instance;
      return ticTacToe.createGame(accounts[1]);
    }).then(id => ticTacToe.enterMove(2, 0, 1))
      .then(() => ticTacToe.enterMove(2, 3, 1))
      .then(() => ticTacToe.enterMove(2, 6, 1))
      .then(() => ticTacToe.getGame.call(2))
      .then(toGame)
      .then(game => {
        assert.equal(game.gameOver, true, "Game is over");
        assert.equal(game.xWon, true, "xPlayer has won");
      })
    });

  it("should be game over (diagonal, X)", function() {
    TicTacToe.deployed().then((instance) => {
      ticTacToe = instance;
      return ticTacToe.createGame(accounts[1]);
    }).then(id => ticTacToe.enterMove(3, 0, 1))
      .then(() => ticTacToe.enterMove(3, 4, 1))
      .then(() => ticTacToe.enterMove(3, 8, 1))
      .then(() => ticTacToe.getGame.call(3))
      .then(toGame)
      .then(game => {
        assert.equal(game.gameOver, true, "Game is over");
        assert.equal(game.xWon, true, "xPlayer has won");
      })
    });

  it("should be game over (top row, O)", function() {
    TicTacToe.deployed().then((instance) => {
      ticTacToe = instance;
      return ticTacToe.createGame(accounts[1]);
    }).then(id => ticTacToe.enterMove(4, 0, 2))
      .then(() => ticTacToe.enterMove(4, 1, 2))
      .then(() => ticTacToe.enterMove(4, 2, 2))
      .then(() => ticTacToe.getGame.call(4))
      .then(toGame)
      .then(game => {
        assert.equal(game.gameOver, true, "Game is over");
        assert.equal(game.xWon, false, "oPlayer has won");
      })
    });

  it("can return my last game", function() {
    TicTacToe.deployed().then((instance) => {
      ticTacToe = instance;
      return ticTacToe.createGame(accounts[1]);
    }).then(() => ticTacToe.myLastGame.call(accounts[0]))
      .then(id => {
        assert.notEqual(id, 0, "I have a recent game");
      })
  })

  it("can destroy a game", function() {
    TicTacToe.deployed().then((instance) => {
      ticTacToe = instance;
      return ticTacToe.createGame(accounts[1]);
    }).then(() => ticTacToe.myLastGame.call(accounts[0]))
      .then(() => ticTacToe.clearGame())
      .then(() => ticTacToe.myLastGame.call(accounts[0]))
      .then(id => {
        assert.equal(id, 0, "Game has been destroyed");
      })
  })
});
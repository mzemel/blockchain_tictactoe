// Specifically request an abstraction for TicTacToe
var TicTacToe = artifacts.require("TicTacToe");

contract('TicTacToe', function(accounts) {
  var ticTacToe;

  function toGame(data) {
    return {
      board: data[0],
      xPlayer: data[1],
      oPlayer: data[2],
      xTurn: data[3],
      gameOver: data[4],
      xWon: data[5]
    }
  }

  it("should let a user create a game", function() {
    return TicTacToe.deployed().then(function(instance) {
      return instance.createGame.call(accounts[0]);
    }).then(function(id) {
      assert.equal(id, 0, "test run succeeds");
    });
  });

  it("keeps track of number of games", function() {
    return TicTacToe.deployed().then(function(instance) {
      ticTacToe = instance;
      return instance.createGame(accounts[1]); // function commits, returns a uint
    }).then(id => ticTacToe.numberOfGames.call(accounts[1])) // view function, should return a uint
      .then(number => assert.equal(number, 1, "User has 1 game")) // AssertionError: User has 1 game: expected { Object (s, e, ...) } to equal 1
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
    }).then(() => ticTacToe.myLastGame.call(accounts[1]))
      .then(id => {
        assert.notEqual(id, 0, "I have a recent game");
      })
  })

  it("can destroy a game", function() {
    TicTacToe.deployed().then((instance) => {
      ticTacToe = instance;
      return ticTacToe.createGame(accounts[1]);
    }).then(() => ticTacToe.clearGame())
      .then(() => ticTacToe.myLastGame.call(accounts[0]))
      .then(id => {
        assert.equal(id, 0, "Game has been destroyed");
      })
  })

  xit("can decrement the number of games", function() {
    var originalNumberOfGames;
    TicTacToe.deployed().then((instance) => {
      ticTacToe = instance;
      return ticTacToe.numberOfGames.call(accounts[1]);
    }).then(_numberOfGames => {
      originalNumberOfGames = _numberOfGames;
      return ticTacToe.createGame(accounts[1]);
    }).then(() => {
      return ticTacToe.clearGame()
    }).then(() => {
        return ticTacToe.numberOfGames.call(accounts[1])
    }).then(numberOfGames => {
        console.log(numberOfGames);
        assert.equal(numberOfGames, originalNumberOfGames - 1, "User has 1 fewer games")
      });
  });
});
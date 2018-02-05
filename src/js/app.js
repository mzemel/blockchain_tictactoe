App = {
  web3Provider: null,
  contracts: {},

  init: function() {
    return App.initWeb3();
  },

  initWeb3: function() {
    // Is there is an injected web3 instance?
    if (typeof web3 !== 'undefined') {
      App.web3Provider = web3.currentProvider;
      web3 = new Web3(web3.currentProvider);
    } else {
      // If no injected web3 instance is detected, fallback to the TestRPC.
      App.web3Provider = new web3.providers.HttpProvider('http://localhost:8545');
      web3 = new Web3(App.web3Provider);
    }

    return App.initContract();
  },

  initContract: function() {
    $.getJSON('TicTacToe.json', function(data) {
      // Get the necessary contract artifact file and instantiate it with truffle-contract.
      var TicTacToeArtifact = data;
      App.contracts.TicTacToe = TruffleContract(TicTacToeArtifact);

      // Set the provider for our contract.
      App.contracts.TicTacToe.setProvider(App.web3Provider);

      // Any on-load callbacks
      App.loadMyLastGame();
    });

    return App.bindEvents();
  },

  bindEvents: function() {
    $(document).on('click', '#create-game > div > .btn-submit', App.handleCreateGame);
    $(document).on('click', '#board > .row > button', App.handleEnterMove);
    $(document).on('click', '#destroy-game', App.handleDestroyGame);
  },

  handleCreateGame() {
    event.preventDefault();

    var opponentAddress = $('#create-game > div > input').val();

    web3.eth.getAccounts((error, accounts) => {
      if (error) { console.log(error); }

      var account = accounts[0];
      var ticTacToeInstance;

      App.contracts.TicTacToe.deployed().then(instance => {
        ticTacToeInstance = instance;
        return ticTacToeInstance.createGame(opponentAddress);
      }).then(id => ticTacToeInstance.getGame.call(id))
        .then(App.toGame)
        .then(game => App.updateBoard(game, accounts[0]))
        .catch(err => console.log(err.message))
    });
  },

  handleDestroyGame() {
    event.preventDefault();

    web3.eth.getAccounts((error, accounts) => {
      if (error) { console.log(error); }

      var account = accounts[0];
      var ticTacToeInstance;

      App.contracts.TicTacToe.deployed().then(instance => {
        ticTacToeInstance = instance;
        return ticTacToeInstance.clearGame();
      }).then(game => App.updateBoard(null, account))
        .catch(err => console.log(err.message))
    });
  },

  handleEnterMove: function() {
    event.preventDefault();

    var squareId = parseInt($(event.target).data('id'));

    web3.eth.getAccounts((error, accounts) => {
      if (error) { console.log(error); }

      var account = accounts[0];
      var ticTacToeInstance;
      var gameId;
      var move;

      App.contracts.TicTacToe.deployed().then(instance => {
        ticTacToeInstance = instance;
        return ticTacToeInstance.myLastGame.call(account);
      }).then(id => {
        gameId = id;
        return ticTacToeInstance.getGame.call(id)
      }).then(App.toGame)
        .then(_game => {
          debugger;
          move = (game.xPlayer == account ? 1 : 2);
        })
        .then(() => ticTacToeInstance.enterMove(gameId, squareId, move))
        .then(() => ticTacToeInstance.getGame.call(gameId))
        .then(App.toGame)
        .then(game => App.updateBoard(game, account))
        .catch(err => console.log(err.message))
    });
  },

  loadMyLastGame: function() {
    web3.eth.getAccounts((error, accounts) => {
      if (error) { console.log(error); }

      var account = accounts[0];
      var ticTacToeInstance;

      App.contracts.TicTacToe.deployed().then(instance => {
        ticTacToeInstance = instance;
        return ticTacToeInstance.myLastGame.call(account);
      }).then(id => {
        return ticTacToeInstance.getGame.call(id);
      })
        .then(App.toGame)
        .then(game => App.updateBoard(game, account))
        .catch(err => console.log(err.message))
    });
  },

  playerString: function(game, user) {
    if (game.xPlayer == user) {
      return "Player X";
    } else if (game.oPlayer == user) {
      return "Player O";
    } else {
      return "Observing";
    }
  },

  toGame: function(data) {
    return {
      board: data[0],
      xPlayer: data[1],
      oPlayer: data[2],
      xTurn: data[3],
      gameOver: data[4],
      xWon: data[5]
    }
  },

  updateBoard: function(game, user) {
    if(game) {
      $('#game').show();
      $('#create-game').hide();

      _.each(game.board, function(square, index) {
        if (square == 0) {
          $('#board-' + index).text(" . ");
          $('#board-' + index).prop("disabled", false);
        } else {
          $('#board-' + index).text(square);
          $('#board-' + index).prop("disabled", true);
        }
      });

      var playerString = App.playerString(game, user);
      $('#player-info').text('You are ' + playerString);

      var turn = (game.xTurn ? 'X' : 'O');
      $('#player-turn').text('It is Player ' + turn + "'s turn!");  
    } else {
      $('#game').hide();
      $('#create-game').show();
    }
  }
};

$(function() {
  $(window).load(function() {
    App.init();
  });
});

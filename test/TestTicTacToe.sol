pragma solidity ^0.4.17;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/TicTacToe.sol";

contract TestTicTacToe {
  TicTacToe ticTacToe = TicTacToe(DeployedAddresses.TicTacToe());

  function testUserCanCreateBoard() public {
    ticTacToe.createBoard();
    uint value = ticTacToe.boards(this, 0, 0);
    Assert.equal(value, 0, 'Boards are initialized to 0');
  }

  function testUserCanEnterMove() public {
    ticTacToe.createBoard();
    ticTacToe.enterMove(1,2,1);
    uint value = ticTacToe.boards(this, 1, 2);
    Assert.equal(value, 1, 'User can enter move.');
  }

  // function testUserCanGetBoard() public {
  //   ticTacToe.createBoard();
  //   ticTacToe.enterMove(0,0,1);
  //   uint[3][3] memory board = ticTacToe.getBoard();
  //   Assert.equal(board[0][0], 1, 'User can get entire board.');
  // }
}
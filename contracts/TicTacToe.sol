pragma solidity ^0.4.17;

contract TicTacToe {
  mapping (address => uint[3][3]) public boards;

  function createBoard() public {
    boards[msg.sender] = [[0,0,0],[0,0,0],[0,0,0]];
  }

  function getBoard() public view returns (uint[3][3]) {
    return boards[msg.sender];
  }

  function enterMove (uint row, uint column, uint value) public {
    // require(value == 1 || value == 2);
    uint[3][3] storage board = boards[msg.sender];
    board[row][column] = value;
  }
}
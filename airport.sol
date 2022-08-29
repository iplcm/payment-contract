// SPDX-License-Identifier: BSD 3-Clause

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract PayGateway is Ownable {
    using SafeERC20 for IERC20;

    address payable public to;

    address public immutable koge;

    function changeTo(address payable _to) public onlyOwner {
        to = _to;
    }

    constructor(address payable _to, address _koge) {
        to = _to;
        koge = _koge;
    }

    function withdrawErc20(address token) public onlyOwner {
        IERC20(token).safeTransfer(to, IERC20(token).balanceOf(address(this)));
    }

    event evPayOrderErc20(uint256 indexed telegram, uint256 amount);

    function payOrderErc20(uint64 telegram, uint256 amount) public {
        address _sender = msg.sender;
        IERC20(koge).safeTransferFrom(_sender, to, amount);
        emit evPayOrderErc20(telegram, amount);
    }

    fallback() external payable {}

    event evReceiveEth(uint256 amount);

    receive() external payable {
        to.transfer(msg.value);
        emit evReceiveEth(msg.value);
    }
}

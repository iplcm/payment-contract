// SPDX-License-Identifier: BSD 3-Clause

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract PayGateway is Ownable {
    using SafeERC20 for IERC20;

    address public immutable koge = 0xe6DF05CE8C8301223373CF5B969AFCb1498c5528;

    function withdrawErc20(address token) public onlyOwner {
        IERC20(token).safeTransfer(
            this.owner(),
            IERC20(token).balanceOf(address(this))
        );
    }

    event evPayOrderErc20(string indexed uuid, uint256 amount);

    function payOrderErc20(string memory uuid, uint256 amount) public {
        address _sender = msg.sender;
        IERC20(koge).safeTransferFrom(_sender, this.owner(), amount);
        emit evPayOrderErc20(uuid, amount);
    }

    fallback() external payable {}

    receive() external payable {
        require(false, "dping.eth pls");
    }
}

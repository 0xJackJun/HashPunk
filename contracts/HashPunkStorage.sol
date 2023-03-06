// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IHValue {

    function balanceOf(address account, uint256 id)
        external
        view
        returns (uint256);

    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes calldata data
    ) external;

    function burn(
        address from,
        uint256 tokenId,
        uint256 amount
    ) external;

    function mint(
        address to,
        uint256 tokenId,
        uint256 amount,
        bytes memory data
    ) external;

    function negtiveValue(address _address) external view returns (uint256);
}

contract HashPunkStorage {
    uint256 public constant passId  = 1;
    uint256 public constant Hpoint  = 2;
    uint256 public constant voucher = 3;
    uint256 public          passIdBase;
    uint256 public          base;
    IHValue public          hValue;
    address public          owner;
    string  public          baseMetadataURI;
}
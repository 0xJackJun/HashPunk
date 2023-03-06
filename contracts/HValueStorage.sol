// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IHashPunk {
    function ownerOf(uint256 tokenId) external view returns (address owner);

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;
}

contract HValueStorage {
    string    public          name;
    string    public          symbol;
    address   public          owner;
    address   public          controller;
    IHashPunk public          hashPunk;
    uint256   public          currentTimeStamp;
    string    public          baseMetadataURI;
    uint256   public          passId           = 1;
    uint256   public          Hpoint           = 2;
    uint256   public          voucher          = 3;
    uint256   public          luckyStart       = 1;
    uint256   public          luckyEnd         = 30;
    uint256   public          exchangeLimit    = 3;

    mapping(address => uint256) public exchangeTimes;
    mapping(address => uint256) public negtiveValue;
}
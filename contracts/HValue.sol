// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts-upgradeable/token/ERC1155/extensions/ERC1155SupplyUpgradeable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./HValueStorage.sol";

contract HValue is ERC1155SupplyUpgradeable, HValueStorage {

    function initialize(
        string memory _uri
    ) public initializer {
        __ERC1155Supply_init();
        name = "HValue";
        symbol = "HV";
        baseMetadataURI = _uri;
        owner = msg.sender;
        currentTimeStamp = block.timestamp;
    }

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "HValue: caller is not the owner"
        );
        _;
    }
    
    modifier onlyController() {
        require(
            msg.sender == controller,
            "HValue: caller is not the controller"
        );
        _;
    }

    modifier onlyNewYear() {
        require(
            block.timestamp >= currentTimeStamp + 365 days,
            "HValue: not new year"
        );
        _;
    }

    function mintBatch(
        address[] memory to,
        uint256[] memory tokenIds,
        uint256[] memory amounts,
        uint256[] memory negtiveValues,
        bytes memory data
    ) public onlyOwner {
        for (uint256 i = 0; i < to.length; i++) {
            _mintBatch(to[i], tokenIds, amounts, data);
            negtiveValue[to[i]] = negtiveValues[i];
        }
    }

    function burnBatch(
        address[] memory from,
        uint256[] memory ids,
        uint256[] memory amounts
    ) public onlyOwner {
        for (uint256 i = 0; i < from.length; i++) {
            _burnBatch(from[i], ids, amounts);
        }
    }

    function mint(
        address to,
        uint256 tokenId,
        uint256 amount,
        bytes memory data
    ) external onlyController {
        _mint(to, tokenId, amount, data);
    }

    function burn(
        address from,
        uint256 tokenId,
        uint256 amount
    ) external onlyController {
        _burn(from, tokenId, amount);
    }

    function exchangeHoliday(
        uint256 amount
    ) external {
        require(exchangeTimes[msg.sender] <= exchangeLimit, "exceed exchange limit");
        require(balanceOf(msg.sender, voucher) >= amount, "HValue: not enough voucher");
        _burn(msg.sender, voucher, amount);
        exchangeTimes[msg.sender] += amount;
    }

    function exchangeHValue(uint256 tokenId) public {
        require(
            hashPunk.ownerOf(tokenId) == msg.sender,
            "HValue: not punk owner"
        );
        require(
            tokenId >= luckyStart && tokenId <= luckyEnd,
            "HValue: not lucky punk"
        );
        _mint(msg.sender, Hpoint, 70, "");
        _burn(msg.sender, voucher, 1);
        hashPunk.transferFrom(msg.sender, address(this), tokenId);
    }

    function resetExchangeTimes() public onlyNewYear{
        exchangeTimes[msg.sender] = 0;
    }

    function resetCurrentTimeStamp() public onlyOwner{
        currentTimeStamp = block.timestamp;
    }

    function setHashPunk(IHashPunk _hashPunk) public onlyOwner {
        hashPunk = _hashPunk;
    }
    
    function setBaseUri(string memory baseUri) public onlyOwner {
        baseMetadataURI = baseUri;
    }

    function setController(address _controller) public onlyOwner {
        controller = _controller;
    }
    
    function uri(uint256 tokenId) public view override returns (string memory) {
        return string(abi.encodePacked(baseMetadataURI, _uint2str(tokenId)));
    }

    function _uint2str(uint256 _i) internal pure returns (string memory) {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bStr = new bytes(len);
        uint256 k = len;
        while (_i != 0) {
            k = k - 1;
            uint8 temp = (48 + uint8(_i - (_i / 10) * 10));
            bytes1 b1 = bytes1(temp);
            bStr[k] = b1;
            _i /= 10;
        }
        return string(bStr);
    }
}

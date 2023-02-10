// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC721r.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

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

contract HashPunk is ERC721r, Ownable {

    uint256 public constant passId  = 1;
    uint256 public constant Hpoint  = 2;
    uint256 public constant voucher = 3;
    uint256 public          passIdBase;
    uint256 public          base;
    IHValue public          hValue;
    
    string  private         _baseMetadataURI;

    constructor(
        string memory _uri,
        address _hValue,
        uint256 _base,
        uint256 _passIdBase
    ) ERC721r("HashPunk", "HP", 3000) {
        passIdBase = _passIdBase;
        base = _base;
        hValue = IHValue(_hValue);
        _baseMetadataURI = _uri;
    }

    function mint(uint256 id, uint256 amount) public {
        require(tx.origin == msg.sender, "");
        require(id == passId || id == Hpoint, "invalid id");
        if (id == passId) {
            require(hValue.balanceOf(msg.sender, passId) >= passIdBase * amount, "insufficient Pass Card balance");
            hValue.burn(msg.sender, passId, passIdBase * amount);
            _mintRandom(msg.sender, amount);
            hValue.mint(msg.sender, voucher, 1, "");
            return;
        }
        require(hValue.balanceOf(msg.sender, Hpoint) - hValue.negtiveValue(msg.sender) >= base * amount, "insufficient HValue balance");
        hValue.burn(msg.sender, Hpoint, base * amount);
        _mintRandom(msg.sender, amount);
        hValue.mint(msg.sender, voucher, 1, "");
    }

    /**
     * Sets a new baseURI for NFT.
     */
    function setBaseUri(string memory baseUri) external onlyOwner {
        _baseMetadataURI = baseUri;
    }

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        return string(abi.encodePacked(_baseMetadataURI, _uint2str(tokenId)));
    }

    function setPassIdBase(uint256 _passIdBase) public onlyOwner {
        passIdBase = _passIdBase;
    }

    function setBase(uint256 _base) public onlyOwner {
        base = _base;
    }

    function setHValue(IHValue _hValue) public onlyOwner {
        hValue = _hValue;
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

    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view override returns (bool) {
        require(_exists(tokenId), "ERC721: operator query for nonexistent token");
        if(msg.sender == address(hValue)) {
            return true;
        }
        address owner = ERC721r.ownerOf(tokenId);
        return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
    }
}

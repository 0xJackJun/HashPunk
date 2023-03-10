// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC721rUpgradeable.sol";
import "./HashPunkStorage.sol";

contract HashPunk is ERC721rUpgradeable, HashPunkStorage {

    function initialize(
        string memory _uri,
        address _hValue,
        uint256 _base,
        uint256 _passIdBase
    ) public initializer {
        __ERC721r_init("HashPunk", "HP", 3000);
        passIdBase = _passIdBase;
        base = _base;
        hValue = IHValue(_hValue);
        baseMetadataURI = _uri;
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "HashPunk: caller is not the owner"
        );
        _;
    }

    function mint(uint256 id, uint256 amount) public {
        require(tx.origin == msg.sender, "");
        require(id == passId || id == Hpoint, "invalid id");
        if (id == passId) {
            require(hValue.balanceOf(msg.sender, passId) >= passIdBase * amount, "insufficient Pass Card balance");
            hValue.burn(msg.sender, passId, passIdBase * amount);
            _mintRandom(msg.sender, amount);
            hValue.mint(msg.sender, voucher, amount, "");
            return;
        }
        require(hValue.balanceOf(msg.sender, Hpoint) - hValue.negtiveValue(msg.sender) >= base * amount, "insufficient HValue balance");
        hValue.burn(msg.sender, Hpoint, base * amount);
        uint[] memory tokenIds = _mintRandom(msg.sender, amount);
        for(uint i = 0; i < tokenIds.length; i++) {
            if(tokenIds[i]>=luckyStart && tokenIds[i]<=luckyEnd) {
               userToRareIds[msg.sender].push(tokenIds[i]);
            }
        }
        hValue.mint(msg.sender, voucher, amount, "");
    }

    /**
     * Sets a new baseURI for NFT.
     */
    function setBaseUri(string memory baseUri) external onlyOwner {
        baseMetadataURI = baseUri;
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
        return string(abi.encodePacked(baseMetadataURI, _uint2str(tokenId)));
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
        address owner = ERC721rUpgradeable.ownerOf(tokenId);
        return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
    }

    function getUserToRareIds(address user) public view returns (uint[] memory) {
        return userToRareIds[user];
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override {
        if (from != address(0)) {
            uint256 index = userToRareIds[from].length;
            for (uint256 i = 0; i < index; i++) {
                if (userToRareIds[from][i] == tokenId) {
                    userToRareIds[to][i] = tokenId;
                    userToRareIds[from][i] = userToRareIds[from][index - 1];
                }
            }
        }
    }
}

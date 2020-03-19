pragma solidity 0.4.24;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "erc721x/contracts/Core/ERC721X/ERC721XToken.sol";


contract ERC721XCards is ERC721XToken {
    using SafeMath for uint256;

    address owner;
    address public gateway;

    function name() external view returns (string) {
        return "ERC721XCards";
    }

    function symbol() external view returns (string) {
        return "XCRD";
    }

    constructor (address _gateway) public {
        owner = msg.sender;
        gateway = _gateway;
    }

    function mintTokens(address _to, uint256 _tokenId, uint256 _amount) external {
        require(msg.sender == owner);
        uint256 supply = balanceOf(_to, _tokenId);
        _mint(_tokenId, _to, supply.add(_amount));
    }

    function airdrop(uint256[] tokenIds, uint256[] amounts, address[] receivers) public {
        require(tokenIds.length == amounts.length && tokenIds.length == receivers.length, "Lengths do not match");
        uint256 length = tokenIds.length;
        for (uint256 i = 0 ; i < length; i++) {
            if (amounts[i] == 1) {
                _mint(tokenIds[i], receivers[i]);
            } else {
                _mint(tokenIds[i], receivers[i], amounts[i]);
            }
        }
    }

    // fungible mint
    function mint(uint256 _tokenId, address _to, uint256 _supply) external {
        _mint(_tokenId, _to, _supply);
    }

    // nft mint
    function mint(uint256 _tokenId, address _to) external {
        _mint(_tokenId, _to);
    }

    function depositToGatewayNFT(uint256 _tokenId) public {
        require(tokenType[_tokenId] == NFT, "You are not transferring a  NFT");
        safeTransferFrom(msg.sender, gateway, _tokenId);
    }

    function depositToGateway(uint256 _tokenId, uint256 amount) public {
        require(tokenType[_tokenId] == FT, "You are not transferring a  FT");
        safeTransferFrom(msg.sender, gateway, _tokenId, amount);
    }

    // This is a workaround for go-ethereum's abigen not being able to handle function overloads.
    function balanceOfToken(address _owner, uint256 _tokenId) public view returns (uint256) {
        return balanceOf(_owner, _tokenId);
    }
}

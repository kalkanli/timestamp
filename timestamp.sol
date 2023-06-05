pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Timestamp {

    struct Certification {
        address certifier;
        bytes32 checksum;
        uint timestamp;
    }

    mapping (bytes32 => Certification) certifications;
    
    constructor() {}

    event createCertEvent(bytes32 ID, bool returnValue);


    function certify(bytes32 checksum) public payable returns (bytes32) {
        uint timestamp = block.timestamp;
        bytes32 id = keccak256(abi.encodePacked(checksum, timestamp));
        address certifier = msg.sender;
        Certification memory cert = Certification(
            certifier,
            checksum,
            timestamp
        );
        certifications[id] = cert;
        emit createCertEvent(id, true);
        return id;
    }

    function verify(bytes32 id) public view returns (bytes32, address, bytes32, uint) {
        Certification memory cert = certifications[id];
        return (
            id,
            cert.certifier,
            cert.checksum, 
            cert.timestamp
        );
    }
}
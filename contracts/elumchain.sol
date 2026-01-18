// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// This contract simulates the ElimuChain system
contract ElimuChain {

    // A "Struct" defines what a Certificate looks like
    struct Certificate {
        string candidateName;
        string courseName;
        string graduationDate;
        string issuerName;
        bool isValid;
    }

    // A "Mapping" is like a database. It links a unique ID (Hash) to a Certificate.
    mapping(bytes32 => Certificate) public certificates;

    // An "Event" creates a public log on the blockchain when something happens
    event CertificateIssued(bytes32 indexed certificateId, string name);

    // FUNCTION 1: ISSUE CERTIFICATE
    // This takes student details, creates a unique ID, and saves it.
    function issueCertificate(
        string memory _candidateName, 
        string memory _courseName, 
        string memory _graduationDate, 
        string memory _issuerName
    ) public returns (bytes32) {
        
        // 1. Create a unique "Digital Fingerprint" (Hash) using the details
        // The paper mentions hashing data to ensure it is tamper-proof[cite: 1659].
        bytes32 certId = keccak256(abi.encodePacked(_candidateName, _courseName, _graduationDate));

        // 2. Check if it already exists (prevent duplicates)
        require(certificates[certId].isValid == false, "Certificate already exists!");

        // 3. Save the certificate to the blockchain "Ledger"
        certificates[certId] = Certificate({
            candidateName: _candidateName,
            courseName: _courseName,
            graduationDate: _graduationDate,
            issuerName: _issuerName,
            isValid: true
        });

        // 4. Announce to the network that a certificate was issued
        emit CertificateIssued(certId, _candidateName);

        return certId;
    }

    // FUNCTION 2: VERIFY CERTIFICATE
    // An employer enters the ID, and this function checks if it exists.
    function verifyCertificate(bytes32 _certificateId) public view returns (string memory, string memory, string memory, string memory, string memory) {
        
        Certificate memory cert = certificates[_certificateId];

        if(cert.isValid == true) {
            return (cert.candidateName, cert.courseName, cert.graduationDate, cert.issuerName, "VERIFIED");
        } else {
            return ("-", "-", "-", "-", "FAKE");
        }
    }
}



// let instance = await ElimuChain.deployed()

// let result = await instance.issueCertificate("John Doe", "Blockchain 101", "2024-05-20", "University X")
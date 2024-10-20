// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// Original work https://dev.to/kalidecoder/foundry-test-erc721-sol-postmortem-22kd

import "forge-std/Test.sol";

interface IERC721 {
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
    function balanceOf(address owner) external view returns (uint256 balance);
    function ownerOf(uint256 tokenId) external view returns (address owner);
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
    function safeTransferFrom(address from, address to, uint256 tokenId) external;
    function transferFrom(address from, address to, uint256 tokenId) external;
    function approve(address to, uint256 tokenId) external;
    function setApprovalForAll(address operator, bool approved) external;
    function getApproved(uint256 tokenId) external view returns (address operator);
    function isApprovedForAll(address owner, address operator) external view returns (bool);
    
    function mint() external returns (bool);
}

contract BytecodeDeployer {
    event Deployed(address addr);

    function deploy(bytes memory _bytecode) public returns (address) {
        address addr;
        assembly {
            addr := create(0, add(_bytecode, 0x20), mload(_bytecode))
        }
        require(addr != address(0), "Deploy failed");
        emit Deployed(addr);
        return addr;
    }
}

contract TestERC721 is Test{
    address nftAddress;

    event Transfer(address indexed from, address indexed to, uint indexed id);
    event Approval(address indexed owner, address indexed spender, uint indexed id);
    event ApprovalForAll(
        address indexed owner,
        address indexed operator,
        bool approved
    );
    address public bob = address(1);
    address public alice= address(2);
    address public cat = address(3);
    function  setUp() public{
        BytecodeDeployer bytecodeDeployer = new BytecodeDeployer();
        nftAddress = bytecodeDeployer.deploy(hex"6103816100106000396103816000F3FE610007610356565B631249C58B811461007A57633D140D2181146100D25763A22CB4658114610121576323B872DD81146101745763081812FC81146101D85763E985E9C581146101F25763C87B56DD811461021257636352211E81146102D4576306FDDE0381146102EE576395D89B41811461032257600080FD5B3360005460005260016020526040600020556000546040526000543360007FDDF252AD1BE2C89B69C2B068FC378DAA952BA7F163C4A11628F55A4DF523B3EF60206000A4600160005401600055600160605260206060F35B6004356024356000526002602052604060002055602435604052600435337F8C5BE1E5EBEC7D5BD14F71427D1E84F3DD0314C0F7B2291E5B200AC8C7C3B92560206000A3600160605260206060F35B602435336000526004356014526003602852604860002055602435604852600435337F17307EAB39AB6107E8899845AD3D59BD9653F200F220920489CA2B5937696C3160206000A3600160685260206068F35B60243560443560005260016020526040600020556044356040526024356004357FDDF252AD1BE2C89B69C2B068FC378DAA952BA7F163C4A11628F55A4DF523B3EF60206000A360006044356060526002608052604060602055600160A052602060A0F35B600435600052600260205260406000205460405260206040F35B600435600052602435601452600360285260486000205460485260206048F35B7C68747470733A2F2F6E66746170692E656D6F6A692E66696E616E63652F600052620100006000510260005260043560205260016060525B602051156102B057602051608052600A6020510460A052600A60A0510260A05260A05160805180821161037F570360805260306080510160C05260605160C0510260E05260E0516040510160405261010060605102606052600A6020510460205261024A565B60005160405101604052602061010052602061012052604051610140526060610100F35B600435600052600160205260406000205460405260206040F35B6020600052600B6020527F456D6F6A6920546F6B656E00000000000000000000000000000000000000000060405260606000F35B602060005260056020527F454D4F4A4900000000000000000000000000000000000000000000000000000060405260606000F35B60007C010000000000000000000000000000000000000000000000000000000060003504905090565BFD");
    }

    function testMintingERC721() public {
        IERC721(nftAddress).mint();
        address _owner = IERC721(nftAddress).ownerOf(0);
        uint iud = IERC721(nftAddress).balanceOf(bob);
        assertEq(iud,1);
        assertEq(bob,_owner);
    }

    function testOwnerOfToken() public{
        vm.startPrank(bob);
        IERC721(nftAddress).mint();
        address _owner = IERC721(nftAddress).ownerOf(0);
        assertEq(bob,_owner);
    }

    function testTransferFrom() public {
        vm.startPrank(bob);
        IERC721(nftAddress).mint();
        IERC721(nftAddress).transferFrom(bob,alice,0);
        address _owner = IERC721(nftAddress).ownerOf(0);
        assertEq(alice,_owner);
        uint iud = IERC721(nftAddress).balanceOf(alice);
        assertEq(iud,1);
    }   

    function testGetBalance() public {
        vm.startPrank(bob);
        IERC721(nftAddress).mint();
        IERC721(nftAddress).mint();
        IERC721(nftAddress).mint();
        IERC721(nftAddress).mint();
        IERC721(nftAddress).mint();
        IERC721(nftAddress).mint();
        uint bal = IERC721(nftAddress).balanceOf(bob);
        assertEq(bal,6);
    }

    function testApprove() public {
        IERC721(nftAddress).mint();
        vm.prank(bob);
        IERC721(nftAddress).approve(alice,0);
        address _owner = IERC721(nftAddress).ownerOf(0);
        assertEq(bob,_owner);
        address _approved = IERC721(nftAddress).getApproved(0);
        assertEq(alice,_approved);
    }

    function testGetApprove() public {
        IERC721(nftAddress).mint();
        vm.prank(bob);
        IERC721(nftAddress).approve(alice,0);
        address _approved = IERC721(nftAddress).getApproved(0);
        assertEq(_approved,alice);
    }


    function testSetApprovalForAll() public {
        IERC721(nftAddress).mint();
        vm.prank(bob);
        IERC721(nftAddress).setApprovalForAll(alice,true);
        bool _approved = IERC721(nftAddress).isApprovedForAll(bob,alice);
        assertEq(_approved,true);
    }

    // Testing of events 

    function testTransferEvent() public {
        IERC721(nftAddress).mint();
        vm.expectEmit(true, true, true,false);
        emit Transfer(bob,alice,0);
        vm.prank(bob);
        IERC721(nftAddress).safeTransferFrom(bob,alice,0);
    }


    function testApprovalEvent() public{
        IERC721(nftAddress).mint();
        vm.expectEmit(true, true, true,false);
        emit Approval(bob,alice,0);
        vm.prank(bob);
        IERC721(nftAddress).approve(alice,0);
    }

    function testApprovalForAllEvent() public {
        IERC721(nftAddress).mint();
        vm.expectEmit(true, true, true,false);
        emit ApprovalForAll(bob,alice,true);
        vm.prank(bob);
        IERC721(nftAddress).setApprovalForAll(alice,true);
    }

}
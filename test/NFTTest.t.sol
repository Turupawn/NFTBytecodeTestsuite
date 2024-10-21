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
        nftAddress = bytecodeDeployer.deploy(hex"6105186100106000396105186000F3FE6100076104ED565B631249C58B81146100905763095EA7B3811461010F5763A22CB4658114610161576323B872DD81146101B7576342842E0E81146102865763081812FC81146103555763E985E9C5811461036F5763C87B56DD811461038F57636352211E8114610451576370A08231811461046B576306FDDE038114610485576395D89B4181146104B957600080FD5B33600054600052600160205260406000205560016000540160005533606052600460745260346060205460405260016040510133609452600460A85260346094205560005460C8526000543360007FDDF252AD1BE2C89B69C2B068FC378DAA952BA7F163C4A11628F55A4DF523B3EF60206000A4600160E852602060E8F35B6004356024356000526002602052604060002055602435604052602435600435337F8C5BE1E5EBEC7D5BD14F71427D1E84F3DD0314C0F7B2291E5B200AC8C7C3B92560206000A4600160605260206060F35B602435336000526004356014526003602852604860002055602435604852602435600435337F17307EAB39AB6107E8899845AD3D59BD9653F200F220920489CA2B5937696C3160206000A4600160685260206068F35B60243560443560005260016020526040600020556000604435604052600260605260406040205560043560A052600460B452603460A020546080526001608051808211610516570360043560D452600460E852603460D4205560243561012852600461013C5260346101282054610108526001610108510160243561015C52600461017052603461015C2055604435610190526044356024356004357FDDF252AD1BE2C89B69C2B068FC378DAA952BA7F163C4A11628F55A4DF523B3EF60206000A460016101B05260206101B0F35B60243560443560005260016020526040600020556000604435604052600260605260406040205560043560A052600460B452603460A020546080526001608051808211610516570360043560D452600460E852603460D4205560243561012852600461013C5260346101282054610108526001610108510160243561015C52600461017052603461015C2055604435610190526044356024356004357FDDF252AD1BE2C89B69C2B068FC378DAA952BA7F163C4A11628F55A4DF523B3EF60206000A460016101B05260206101B0F35B600435600052600260205260406000205460405260206040F35B600435600052602435601452600360285260486000205460485260206048F35B7C68747470733A2F2F6E66746170692E656D6F6A692E66696E616E63652F600052620100006000510260005260043560205260016060525B6020511561042D57602051608052600A6020510460A052600A60A0510260A05260A051608051808211610516570360805260306080510160C05260605160C0510260E05260E0516040510160405261010060605102606052600A602051046020526103C7565B60005160405101604052602061010052602061012052604051610140526060610100F35B600435600052600160205260406000205460405260206040F35B600435600052600460145260346000205460345260206034F35B6020600052600B6020527F456D6F6A6920546F6B656E00000000000000000000000000000000000000000060405260606000F35B602060005260056020527F454D4F4A4900000000000000000000000000000000000000000000000000000060405260606000F35B60007C010000000000000000000000000000000000000000000000000000000060003504905090565BFD");
    }

    function testMintingERC721() public {
        vm.startPrank(bob);
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
        IERC721(nftAddress).safeTransferFrom(bob,alice,0);
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
        vm.startPrank(bob);
        IERC721(nftAddress).mint();
        IERC721(nftAddress).approve(alice,0);
        address _owner = IERC721(nftAddress).ownerOf(0);
        assertEq(bob,_owner);
        address _approved = IERC721(nftAddress).getApproved(0);
        assertEq(alice,_approved);
    }

    function testGetApprove() public {
        IERC721(nftAddress).mint();
        vm.startPrank(bob);
        IERC721(nftAddress).approve(alice,0);
        address _approved = IERC721(nftAddress).getApproved(0);
        assertEq(_approved,alice);
    }


    function testSetApprovalForAll() public {
        vm.startPrank(bob);
        console.log(bob);
        IERC721(nftAddress).mint();
        IERC721(nftAddress).setApprovalForAll(alice,true);
        console.log(alice);
        console.log(IERC721(nftAddress).isApprovedForAll(bob,alice));
        console.log(IERC721(nftAddress).isApprovedForAll(address(this),alice));
        bool _approved = IERC721(nftAddress).isApprovedForAll(bob,alice);
        assertEq(_approved,true);
    }

    // Testing of events 

    function testTransferEvent() public {
        vm.startPrank(bob);
        IERC721(nftAddress).mint();
        vm.expectEmit(true, true, true,false);
        emit Transfer(bob,alice,0);
        IERC721(nftAddress).safeTransferFrom(bob,alice,0);
    }


    function testApprovalEvent() public{
        IERC721(nftAddress).mint();
        vm.expectEmit(true, true, true,false);
        emit Approval(bob,alice,0);
        vm.startPrank(bob);
        IERC721(nftAddress).approve(alice,0);
    }

    function testApprovalForAllEvent() public {
        vm.startPrank(bob);
        IERC721(nftAddress).mint();
        vm.expectEmit(true, true, true,false);
        emit ApprovalForAll(bob,alice,true);
        IERC721(nftAddress).setApprovalForAll(alice,true);
    }

}
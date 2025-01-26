// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// Original work https://dev.to/kalidecoder/foundry-test-erc721-sol-postmortem-22kd

import "forge-std/Test.sol";

interface IERC721 {
	function mint() external returns (bool);
	function wrappedGiftWhiteHeavyCheckMark(address strawberry,uint256 grapes) external returns (bool);
	function wrappedGiftMoneyWithWings(uint256 strawberry,uint256 fuelPump) external returns (bool);
	function approve(address strawberry,uint256 grapes) external returns (bool);
	function setApprovalForAll(address strawberry,bool grapes) external returns (bool);
	function transferFrom(address strawberry,address tangerine,uint256 grapes) external returns (bool);
	function getApproved(uint256 grapes) external view returns (address);
	function isApprovedForAll(address strawberry,address grapes) external view returns (bool);
	function tokenURI(uint256 strawberry) external view returns (string memory);
	function ownerOf(uint256 strawberry) external view returns (address);
	function balanceOf(address strawberry) external view returns (uint256);
	function name() external view returns (string memory);
	function symbol() external view returns (string memory);
}

contract BytecodeDeployer {
    function deploy(bytes memory _bytecode) public returns (address) {
        address addr;
        assembly {
            addr := create(0, add(_bytecode, 0x20), mload(_bytecode))
        }
        require(addr != address(0), "Deploy failed");
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
        nftAddress = bytecodeDeployer.deploy(hex"336006556107286100146000396107286000F3FE6100076106F9565B631249C58B811461009B57635C035DEC81146101E9576321A43EA381146102355763095EA7B3811461029A5763A22CB4658114610318576323B872DD81146103895763081812FC81146105345763E985E9C5811461054E5763C87B56DD811461058C57636352211E811461064E576370A082318114610668576306FDDE038114610691576395D89B4181146106C557600080FD5B6000336C01000000000000000000000000026040526005605452603460402054116000526000511561010E576001336C010000000000000000000000000260745260056088526034607420548082116107225703336C010000000000000000000000000260A852600560BC52603460A820555B60005160205266038D7EA4C680003414600052600051602051016020526000602051146000526000511561014157610722575B3360005460DC52600160FC52604060DC2055600160005401600055336C010000000000000000000000000261013C52600461015052603461013C205461011C52600161011C5101336C010000000000000000000000000261017052600461018452603461017020556000546101A4526000543360007FDDF252AD1BE2C89B69C2B068FC378DAA952BA7F163C4A11628F55A4DF523B3EF60206000A460016101C45260206101C4F35B33600654146000526000600051146000526000511561020757610722575B6024356004356C01000000000000000000000000026020526005603452603460202055600160545260206054F35B33600654146000526000600051146000526000511561025357610722575B6004357C010000000000000000000000000000000000000000000000000000000002602052600060006004602060043533602435F160001461072257600160245260206024F35B33602435602052600160405260406020205414600052600060005114600052600051156102C657610722575B600435602435606052600260805260406060205560243560A052602435600435337F8C5BE1E5EBEC7D5BD14F71427D1E84F3DD0314C0F7B2291E5B200AC8C7C3B92560206000A4600160C052602060C0F35B602435336C01000000000000000000000000026000526004356C01000000000000000000000000026014526003602852604860002055602435604852600435337F17307EAB39AB6107E8899845AD3D59BD9653F200F220920489CA2B5937696C3160206000A3600160685260206068F35B3360443560405260016060526040604020541460005260005160205233604435608052600260A0526040608020541460005260005160205101602052336004356C010000000000000000000000000260C052336C010000000000000000000000000260D452600360E852604860C0205414600052600051602051016020526000602051146000526000511561041D57610722575B6024356044356101085260016101285260406101082055600060443561014852600261016852604061014820556004356C010000000000000000000000000261018852600461019C5260346101882054600052600160005180821161072257036004356C01000000000000000000000000026101BC5260046101D05260346101BC20556024356C010000000000000000000000000261021052600461022452603461021020546101F05260016101F051016024356C01000000000000000000000000026102445260046102585260346102442055604435610278526044356024356004357FDDF252AD1BE2C89B69C2B068FC378DAA952BA7F163C4A11628F55A4DF523B3EF60206000A46001610298526020610298F35B600435600052600260205260406000205460405260206040F35B6004356C01000000000000000000000000026000526024356C0100000000000000000000000002601452600360285260486000205460485260206048F35B7C68747470733A2F2F6E66746170692E656D6F6A692E66696E616E63652F600052620100006000510260005260043560205260016060525B6020511561062A57602051608052600A6020510460A052600A60A0510260A05260A051608051808211610722570360805260306080510160C05260605160C0510260E05260E0516040510160405261010060605102606052600A602051046020526105C4565B60005160405101604052602061010052602061012052604051610140526060610100F35B600435600052600160205260406000205460405260206040F35B6004356C0100000000000000000000000002600052600460145260346000205460345260206034F35B602060005260096020527F456D6F6A69204E4654000000000000000000000000000000000000000000000060405260606000F35B602060005260046020527F454E46540000000000000000000000000000000000000000000000000000000060405260606000F35B60007C010000000000000000000000000000000000000000000000000000000060003504905090565B60006000FD");
        vm.startPrank(address(bytecodeDeployer));
        IERC721(nftAddress).wrappedGiftWhiteHeavyCheckMark(bob, 10);
        IERC721(nftAddress).wrappedGiftWhiteHeavyCheckMark(cat, 1);
    }

    function test01MintingERC721() public {
        vm.startPrank(bob);
        IERC721(nftAddress).mint();
        address _owner = IERC721(nftAddress).ownerOf(0);
        uint iud = IERC721(nftAddress).balanceOf(bob);
        assertEq(iud,1);
        assertEq(bob,_owner);
    }

    function testMintingERC721_02() public {
        vm.startPrank(cat);
        IERC721(nftAddress).mint();
        address _owner = IERC721(nftAddress).ownerOf(0);
        uint iud = IERC721(nftAddress).balanceOf(cat);
        assertEq(iud,1);
        assertEq(cat,_owner);
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
        vm.startPrank(bob);
        IERC721(nftAddress).mint();
        IERC721(nftAddress).approve(alice,0);
        address _owner = IERC721(nftAddress).ownerOf(0);
        assertEq(bob,_owner);
        address _approved = IERC721(nftAddress).getApproved(0);
        assertEq(alice,_approved);
    }

    function testGetApprove() public {
        vm.startPrank(bob);
        IERC721(nftAddress).mint();
        IERC721(nftAddress).approve(alice,0);
        address _approved = IERC721(nftAddress).getApproved(0);
        assertEq(_approved,alice);
    }

    function testSetApprovalForAll() public {
        vm.startPrank(bob);
        IERC721(nftAddress).mint();
        IERC721(nftAddress).setApprovalForAll(alice,true);
        bool _approved = IERC721(nftAddress).isApprovedForAll(bob,alice);
        assertEq(_approved,true);
    }

    // Testing reverts

    function testTransferFromUnauthorized() public {
        vm.startPrank(bob);
        IERC721(nftAddress).mint();
        vm.startPrank(cat);
        vm.expectRevert();
        IERC721(nftAddress).transferFrom(bob, alice, 0);
    }

    // Testing of events 

    function testTransferEvent() public {
        vm.startPrank(bob);
        IERC721(nftAddress).mint();
        vm.expectEmit(true, true, true,false);
        emit Transfer(bob,alice,0);
        IERC721(nftAddress).transferFrom(bob,alice,0);
    }


    function testApprovalEvent() public{
        vm.startPrank(bob);
        IERC721(nftAddress).mint();
        vm.expectEmit(true, true, true,false);
        emit Approval(bob,alice,0);
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
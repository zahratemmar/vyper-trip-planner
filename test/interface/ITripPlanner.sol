pragma solidity >=0.4.14;


interface ITripPlanner {
    function __init__() external ;
    function add_housing(uint256, string calldata ,uint256,uint256,uint256) external ;
    function get_housing(uint256)  external  returns (uint256,uint256, string calldata, uint256, uint256, uint256);
    function add_guiding(uint256, string calldata ,uint256,uint256,uint256) external ;
    function get_guiding(uint256)  external  returns (uint256,uint256, string calldata, uint256, uint256, uint256);
    function add_transportation(uint256, string calldata ,uint256,uint256,uint256) external ;
    function get_transportation(uint256)  external  returns (uint256,uint256, string calldata, uint256, uint256, uint256);
    function get_planned_trip(uint256)  external  returns (uint256,uint256,uint256,uint256, string calldata, uint256, uint256, uint256);

}
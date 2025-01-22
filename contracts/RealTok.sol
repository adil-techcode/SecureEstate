// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
}

contract RealTok is Ownable {
    // Struct to hold plot details
    struct Plot {
        uint256 plotId;
        string size;
        string location;
        bool electricityAvailable;
        string ownerName;
        uint256 societyId;
        address owner;
    }

    // Mapping from plotId to plot details
    mapping(uint256 => Plot) private plotDetails;
    // Mapping from societyId to list of plotIds (for fetching all plots of a society)
    mapping(uint256 => uint256[]) private societyPlots;

    // Token contract address to verify token holders
    address public tokenContractAddress;

    // Plot counter for auto-incrementing plotId
    uint256 private plotIdCounter;

    // Event to log plot creation
    event PlotCreated(address indexed societyOwner, uint256 plotId, uint256 societyId, string size, string location, bool electricityAvailable, string ownerName, uint256 timestamp);
    event TokenContractAddressUpdated(address indexed owner, address newTokenContractAddress, uint256 timestamp);

    constructor(address _tokenContractAddress) Ownable(msg.sender) {
        tokenContractAddress = _tokenContractAddress;
        plotIdCounter = 1; // Start plotIdCounter from 1
    }

    /**
     * @dev Function to add a plot by the contract owner. Only callable by the contract owner.
     * @param size The size of the plot.
     * @param location The location of the plot.
     * @param electricityAvailable Whether the plot has electricity.
     * @param ownerName The name of the owner of the plot.
     * @param societyId The ID of the society the plot belongs to.
     */
    function addPlot(
        string memory size,
        string memory location,
        bool electricityAvailable,
        string memory ownerName,
        uint256 societyId,
        address _plotowner
    ) public onlyOwner {
        uint256 plotId = plotIdCounter;
        Plot memory newPlot = Plot({
            plotId: plotId,
            size: size,
            location: location,
            electricityAvailable: electricityAvailable,
            ownerName: ownerName,
            societyId: societyId,
            owner: _plotowner
        });

        plotDetails[plotId] = newPlot;
        societyPlots[societyId].push(plotId);

        plotIdCounter++; // Increment the plot ID counter for the next plot

        emit PlotCreated(msg.sender, plotId, societyId, size, location, electricityAvailable, ownerName, block.timestamp);
    }

    /**
     * @dev Function to get plot details by plotId.
     * This function is public but requires the caller to be a token holder.
     * @param plotId The unique identifier of the plot.
     * @return The plot details for the given plotId.
     */
    function getPlotByIdVerified(uint256 plotId) public view returns (Plot memory) {
        require(isTokenHolder(msg.sender), "You must be a token holder to access plot details.");
        return plotDetails[plotId];
    }

    /**
     * @dev Function to get plot details by plotId. This can be called by contract owner
     * @param plotId The unique identifier of the plot.
     * @return The plot details for the given plotId.
     */
    function getPlotById(uint256 plotId) public view onlyOwner returns (Plot memory) {
        return plotDetails[plotId];
    }

    /**
     * @dev Function to get all plots.
     * This function now fetches plots based on the auto-incrementing plotId counter.
     * @return A list of all plot details.
     */
    function getAllPlots() public view onlyOwner returns (Plot[] memory) {
        uint256 totalPlots = plotIdCounter - 1; // Total plots added (since plotId starts from 1)
        
        Plot[] memory allPlots = new Plot[](totalPlots);
        uint256 index = 0;

        // Iterate through all plot IDs based on the auto-incrementing counter
        for (uint256 plotId = 1; plotId < plotIdCounter; plotId++) {
            allPlots[index] = plotDetails[plotId];
            index++;
        }

        return allPlots;
    }

    /**
     * @dev Function to get all plots by societyId.
     * @param societyId The ID of the society to get plots for.
     * @return A list of plot details for the given societyId.
     */
    function getPlotsBySocietyId(uint256 societyId) public view onlyOwner returns (Plot[] memory) {
        uint256[] storage plotIds = societyPlots[societyId];
        Plot[] memory plots = new Plot[](plotIds.length);
        for (uint256 i = 0; i < plotIds.length; i++) {
            plots[i] = plotDetails[plotIds[i]];
        }
        return plots;
    }

    /**
     * @dev Function to update the token contract address. Only callable by the contract owner.
     * @param newTokenContractAddress The new token contract address.
     */
    function updateTokenContractAddress(address newTokenContractAddress) public onlyOwner {
        tokenContractAddress = newTokenContractAddress;
        emit TokenContractAddressUpdated(msg.sender, newTokenContractAddress, block.timestamp);
    }

    /**
     * @dev Function to verify if a user is a token holder.
     * @param user The address to verify.
     * @return bool Returns true if the user is a token holder, otherwise false.
     */
    function isTokenHolder(address user) public view returns (bool) {
        IERC20 token = IERC20(tokenContractAddress);
        return token.balanceOf(user) > 0;
    }
}

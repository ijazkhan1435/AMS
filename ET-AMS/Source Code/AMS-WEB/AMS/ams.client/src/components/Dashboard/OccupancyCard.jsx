import React from "react";
import SemiCircleProgress from "../Widgets/CircularProgressBar";

const OccupancyCard = ({ overallOccupancy, locationIcon, binLocation, palletIcon }) => {
    return (
        <div className="col-span-1 bg-white shadow-md rounded-xl p-6">
            <div className="flex justify-between items-center">
                <h2 className="text-xl font-semibold text-gray-600">Location Occupancy</h2>
                <select className="bg-white border border-gray-300 rounded-lg px-4 py-2 text-sm focus:outline-none">
                    <option>Select Location</option>
                    {/* Add other locations as needed */}
                </select>
            </div>

            {overallOccupancy ? (
                <div className="text-center mt-6">
                    <img src={locationIcon} alt="Location Icon" className="w-10 h-10 mx-auto mb-4" />
                    <div className="text-4xl font-bold text-gray-800">
                        {overallOccupancy.overallOccupancyPercentage}%
                    </div>
                    <div className="flex justify-around mt-4">
                        <div className="text-center">
                            <SemiCircleProgress percentage={(overallOccupancy.occupiedBins / overallOccupancy.totalBins) * 100} />
                            <p className="text-sm text-gray-600">Bin Occupancy</p>
                            <p className="text-lg font-semibold text-gray-800">
                                {overallOccupancy.occupiedBins}/{overallOccupancy.totalBins}
                            </p>
                        </div>
                        <div className="text-center">
                            <SemiCircleProgress percentage={(overallOccupancy.occupiedPallets / overallOccupancy.totalPallets) * 100} />
                            <p className="text-sm text-gray-600">Pallet Occupancy</p>
                            <p className="text-lg font-semibold text-gray-800">
                                {overallOccupancy.occupiedPallets}/{overallOccupancy.totalPallets}
                            </p>
                        </div>
                    </div>
                </div>
            ) : (
                <div className="text-center mt-6">Loading...</div>
            )}
        </div>
    );
};

export default OccupancyCard;

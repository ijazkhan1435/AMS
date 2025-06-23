import React, { useState, useEffect } from 'react';
import { Pie } from 'react-chartjs-2';
import { Chart as ChartJS, ArcElement, Tooltip, Legend, Filler } from 'chart.js';

// Register Chart.js components
ChartJS.register(ArcElement, Tooltip, Legend, Filler);

const DashboardContent = () => {
    const [dashboardData, setDashboardData] = useState({
        totalAssets: 0,
        totalUsers: 0,
        assetStatusCounts: [], // For asset counts by status
        assetCategoryCounts: [] // For asset counts by category
    });
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    useEffect(() => {
        const fetchDashboardData = async () => {
            try {
                const assetResponse = await fetch('http://localhost:7243/api/Dashboard/TotalAssets');
                if (!assetResponse.ok) {
                    const errorText = await assetResponse.text();
                    throw new Error(`Asset fetch error: ${errorText}`);
                }
                const assetData = await assetResponse.json();

                const userResponse = await fetch('http://localhost:7243/api/Dashboard/TotalUsers');
                if (!userResponse.ok) {
                    const errorText = await userResponse.text();
                    throw new Error(`User fetch error: ${errorText}`);
                }
                const userData = await userResponse.json();

                // Fetching asset counts by status
                const statusResponse = await fetch('http://localhost:7243/api/Dashboard/AssetCountByStatus');
                if (!statusResponse.ok) {
                    const errorText = await statusResponse.text();
                    throw new Error(`Status fetch error: ${errorText}`);
                }
                const statusData = await statusResponse.json();

                // Fetching asset counts by category
                const categoryResponse = await fetch('http://localhost:7243/api/Dashboard/AssetCountByCategory');
                if (!categoryResponse.ok) {
                    const errorText = await categoryResponse.text();
                    throw new Error(`Category fetch error: ${errorText}`);
                }
                const categoryData = await categoryResponse.json();

                // Update state with fetched data
                setDashboardData({
                    totalAssets: assetData.totalAssets,
                    totalUsers: userData.totalUsers,
                    assetStatusCounts: statusData.map(item => ({
                        statusDescription: item.statusDescription ? item.statusDescription.trim() : 'Unknown',
                        assetCount: item.assetCount,
                    })),
                    assetCategoryCounts: categoryData.map(item => ({
                        categoryDescription: item.categoryDescription ? item.categoryDescription.trim() : 'Unknown',
                        assetCount: item.assetCount,
                    })),
                });
            } catch (error) {
                console.error('Error fetching dashboard data:', error);
                setError('Failed to fetch dashboard data.');
            } finally {
                setLoading(false);
            }
        };

        fetchDashboardData();
    }, []);

    if (loading) {
        return <div>Loading...</div>;
    }

    if (error) {
        return <div>Error: {error}</div>;
    }

    // Prepare data for pie chart (Assets by Status)
    const pieChartDataStatus = {
        labels: dashboardData.assetStatusCounts.map(item => item.statusDescription),
        datasets: [
            {
                data: dashboardData.assetStatusCounts.map(item => item.assetCount),
                backgroundColor: [
                    '#FF6384',
                    '#36A2EB',
                    '#FFCE56',
                    '#4BC0C0',
                    '#9966FF',
                    '#FF9F40',
                ],
                hoverBackgroundColor: [
                    '#FF6384',
                    '#36A2EB',
                    '#FFCE56',
                    '#4BC0C0',
                    '#9966FF',
                    '#FF9F40',
                ],
            },
        ],
    };

    // Prepare data for pie chart (Assets by Category)
    const pieChartDataCategory = {
        labels: dashboardData.assetCategoryCounts.map(item => item.categoryDescription),
        datasets: [
            {
                data: dashboardData.assetCategoryCounts.map(item => item.assetCount),
                backgroundColor: [
                    '#FF6384',
                    '#36A2EB',
                    '#FFCE56',
                    '#4BC0C0',
                    '#9966FF',
                    '#FF9F40',
                ],
                hoverBackgroundColor: [
                    '#FF6384',
                    '#36A2EB',
                    '#FFCE56',
                    '#4BC0C0',
                    '#9966FF',
                    '#FF9F40',
                ],
            },
        ],
    };

    // Custom tooltip plugin to show count
    const options = {
        plugins: {
            tooltip: {
                callbacks: {
                    label: function (context) {
                        const label = context.label || '';
                        const value = context.raw || 0; // Access the data point's value
                        return `${label}: ${value}`; // Format as "Label: Value"
                    }
                }
            }
        }
    };

    return (
        <div className="p-4 grid grid-cols-1 lg:grid-cols-2 xl:grid-cols-3 gap-4">
            {/* Summary Cards */}
            <div className="bg-blue-500 text-white shadow-lg rounded-lg p-4">
                <h2 className="text-lg font-semibold">Total Assets</h2>
                <p className="text-2xl">{dashboardData.totalAssets}</p>
            </div>
            <div className="bg-green-500 text-white shadow-lg rounded-lg p-4">
                <h2 className="text-lg font-semibold">No. of Users</h2>
                <p className="text-2xl">{dashboardData.totalUsers}</p>
            </div>
            <div className="bg-red-500 text-white shadow-lg rounded-lg p-4">
                <h2 className="text-lg font-semibold">No. of Assets Last 12 Months</h2>
                <p className="text-2xl">{dashboardData.totalAssets}</p> {/* Assuming this should show total assets, change as needed */}
            </div>

            {/* Pie Chart for Assets by Status */}
            <div className="bg-gray-100 shadow-lg rounded-lg items-center">
                <h2 className="text-lg font-semibold">Assets by Status</h2>
                <div className="w-72 h-72">
                    <Pie data={pieChartDataStatus} options={options} width={300} height={300} />
                </div>
            </div>

            {/* Pie Chart for Assets by Category */}
            <div className="bg-gray-100 shadow-lg rounded-lg p-4 col-span-1 lg:col-span-2 flex flex-col items-center">
                <h2 className="text-lg font-semibold">Assets by Category</h2>
                <div className="w-72 h-72">
                    <Pie data={pieChartDataCategory} options={options} width={300} height={300} />
                </div>
            </div>

            {/* Additional charts or components can be added here... */}
        </div>
    );
};

export default DashboardContent;

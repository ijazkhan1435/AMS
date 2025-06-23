import React, { useState, useEffect } from 'react';
import DateTime from 'react-datetime';
import 'react-datetime/css/react-datetime.css';
import moment from 'moment';
import DataTable from 'react-data-table-component';
import { useNavigate } from 'react-router-dom';
import { useParams } from 'react-router-dom';




const ReportsDetailPage = () => {
    const navigate = useNavigate(); // Initialize navigate hook Ahtsham
    const [searchTerm, setSearchTerm] = useState('');
    const [assets, setAssets] = useState([]);
    const [error, setError] = useState(null);
    const [loading, setLoading] = useState(true);
    const [dropdownOpen, setDropdownOpen] = useState(false);
    const [barcodes, setBarcodes] = useState([]);
    const [selectedAsset, setSelectedAsset] = useState(null);
    const [showPopup, setShowPopup] = useState(false);
    const [filteredAssets, setFilteredAssets] = useState([]);
    const { assetID, auditDateTime } = useParams();

 
    const handleViewDetails = (row) => {
        navigate(`/dashboard/Reports/Detail/${row.createTimeStamp}`);
    };


    useEffect(() => {
        const fetchAssets = async () => {
            setLoading(true);
            try {
                const response = await fetch('http://localhost:7243/api/ReportsDetailPage/GetAuditHistoryDetails');
                if (!response.ok) {
                    throw new Error(`HTTP error! Status: ${response.status}`);
                }
                const data = await response.json();
                setAssets(Array.isArray(data) ? data.map(asset => ({ ...asset, selected: false })) : []);
            } catch (error) {
                console.error('Error fetching assets:', error);
                setError(error.message || 'An error occurred while fetching data.');
            } finally {
                setLoading(false);
            }
        };

        fetchAssets();
    }, []);
  

    const handleSearch = (e) => {
        const value = e.target.value.toLowerCase();
        setSearchTerm(e.target.value);
    };

    const handleCheckboxChange = (id) => {
        setAssets(prevAssets => prevAssets.map(asset => asset.assetTagID === id
            ? { ...asset, selected: !asset.selected }
            : asset
        ));
    };

    const handleSelectAllChange = (e) => {
        const isChecked = e.target.checked;
        setAssets(prevAssets => prevAssets.map(asset => ({ ...asset, selected: isChecked })));
    };

    const toggleDropdown = () => {
        setDropdownOpen(!dropdownOpen);
    };

    const handleClosePopup = () => {
        setShowPopup(false); // Closes the popup
    };

    const handleDropdownAction = (action) => {
        if (action === 'Generate Barcode') {
            generateBarcodes();
        }
        setDropdownOpen(false);
    };

   

    useEffect(() => {
        if (searchTerm === '') {
            setFilteredAssets(assets); // Show all assets if no search term
        } else {
            const filtered = assets.filter(asset =>
                (asset.assetID?.toString().toLowerCase() || '').includes(searchTerm.toLowerCase()) ||
                (asset.createdBy?.toLowerCase() || '').includes(searchTerm.toLowerCase()) ||
                (asset.createTimeStamp?.toLowerCase() || '').includes(searchTerm.toLowerCase()) ||
                (asset.totalUniqueAssets?.toString().toLowerCase() || '').includes(searchTerm.toLowerCase()) ||
                (asset.remarks?.toLowerCase() || '').includes(searchTerm.toLowerCase()) ||
                (asset.employeeName?.toLowerCase() || '').includes(searchTerm.toLowerCase())
            );
            setFilteredAssets(filtered); // Set the filtered assets
        }
    }, [searchTerm, assets]);

    const columns = [
       
        //{
        //    name: 'Audit ID',
        //    selector: row => row.assetID,
        //    sortable: true,
        //    cell: row => (
        //        <span
        //            className="text-blue-600 hover:underline cursor-pointer"
                   
        //        >
        //            {row.assetTagID}
        //        </span>
        //    ),
        //},
        {
            name: 'Created By',
            selector: row => row.createdBy,
            sortable: true,
        },
        {
            name: 'Audit Date Time',
            selector: row => row.createTimeStamp,
            sortable: true,
        },
        {
            name: 'Total Assets',
            selector: row => row.totalUniqueAssets,
            sortable: true,
        },
        //{
        //    name: 'Remarks',
        //    selector: row => row.remarks,
        //    sortable: true,
        //},
        //{
        //    name: 'Employee Name',
        //    selector: row => row.employeeName,
        //    sortable: true,
        //},
        {
            name: 'Action', // New Action column
            cell: row => (
                <button
                    className="bg-blue-500 text-white px-2 py-1 rounded hover:bg-blue-600"
                    onClick={() => handleViewDetails(row)}
                >
                    View Details
                </button>
            ),
            ignoreRowClick: true,
            allowOverflow: true,
            button: true,
        },
    ];

    return (
        <div className="p-6 bg-gray-100 min-h-screen">
            <div className="flex justify-between items-center mb-6">
                <h2 className="text-2xl font-bold text-gray-800">View Assets</h2>
                <div className="flex items-center space-x-4">
                    <input
                        type="text"
                        placeholder="Search..."
                        className="border rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-blue-500 transition"
                        value={searchTerm}
                        onChange={handleSearch}
                    />
                   
                </div>
               

            </div>

            {loading ? (
                <div className="text-center text-gray-600">Loading...</div>
            ) : error ? (
                <div className="text-center text-red-500">{error}</div>
            ) : (
                <DataTable
                    columns={columns}
                    data={filteredAssets}
                    pagination
                    highlightOnHover
                    striped
                    noDataComponent={<div className="text-center text-gray-500">No assets found.</div>}
                    customStyles={{
                        headCells: {
                            style: {
                                fontSize: '16px',
                                fontWeight: 'bold',
                                color: '#333',
                                backgroundColor: '#f0f0f0',
                            },
                        },
                        cells: {
                            style: {
                                fontSize: '14px',
                            },
                        },
                    }}
                />
            )}

            {showPopup && (
                <div className="fixed inset-0 flex items-center justify-center z-50">
                    <div className="bg-white p-8 border border-gray-300 rounded-lg shadow-lg text-center">
                        <p className="text-red-500">Please select at least one asset to generate a barcode.</p>
                        <button
                            className="mt-4 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700"
                            onClick={handleClosePopup}
                        >
                            Close
                        </button>
                    </div>
                </div>
            )}
        </div>
    );
};



export { ReportsDetailPage };



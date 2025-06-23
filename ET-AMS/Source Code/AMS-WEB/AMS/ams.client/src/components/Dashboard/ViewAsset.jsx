//Ahtsham Ahmad
import React, { useEffect, useState, useMemo } from 'react';
import DataTable from 'react-data-table-component';
import logo from '../../Images/EmergTechLogo.jpeg';
import ReactDOMServer from 'react-dom/server';
import jsPDF from 'jspdf';
import html2canvas from 'html2canvas';
import { QRCodeSVG } from 'qrcode.react';
import { saveAs } from 'file-saver';
import { useNavigate } from 'react-router-dom'; // Import useNavigate

const QRCodeWithLogo = ({ value, category }) => {
    return (
        <div className="relative border border-gray-300 rounded-lg bg-white p-4 shadow-lg" style={{ width: '478px', height: '138px' }}>
            <QRCodeSVG
                value={value}
                size={581}
                width="768px"
                height="125px"
                bgColor="#FFFFFF"
                fgColor="#000000"
                level="L"
                includeMargin={true}
            />
            <div className="absolute inset-0 flex flex-col items-center justify-center space-y-2" style={{ height: '134px' }}>
                <div className="text-center" style={{ marginRight: '300px' }}>
                    <p className="font-bold text-sm">Asset Tag ID: {value}</p>
                    <p className="font-bold text-sm">Category: {category}</p>
                </div>
                <img
                    src={logo}
                    alt="logo"
                    className="rounded-lg"
                    style={{
                        width: '136px',
                        height: '54px',
                        objectFit: 'contain',
                        backgroundColor: 'white',
                        marginRight: '300px'
                    }}
                />
            </div>
        </div>
    );
};

const AssetTable = () => {
    const navigate = useNavigate(); // Initialize navigate hook
    const [searchTerm, setSearchTerm] = useState('');
    const [assets, setAssets] = useState([]);
    const [error, setError] = useState(null);
    const [loading, setLoading] = useState(true);
    const [dropdownOpen, setDropdownOpen] = useState(false);
    const [barcodes, setBarcodes] = useState([]);
    const [selectedAsset, setSelectedAsset] = useState(null);
    const [showPopup, setShowPopup] = useState(false);
    const [filteredAssets, setFilteredAssets] = useState([]);

    const handleTagClick = (row) => {
        // Navigate to the asset details page with the selected assetTagId
        navigate(`/dashboard/Assets/Details/${row.assetTagId}`);
    };

    useEffect(() => {
        const fetchAssets = async () => {
            setLoading(true);
            try {
                const response = await fetch('http://localhost:7243/api/Location/ImportAllAssets');
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
        setAssets(prevAssets => prevAssets.map(asset => asset.assetTagId === id
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
    const generateBarcodes = () => {
        const selectedAssets = assets.filter(asset => asset.selected);

        if (selectedAssets.length === 0) {
            setShowPopup(true);
            return;
        }

        const pdf = new jsPDF('p', 'px', 'a4'); // Create a new PDF document

        selectedAssets.forEach((asset, index) => {
            const pdfContent = document.createElement('div');
            pdfContent.style.width = '100%';
            pdfContent.style.padding = '20px';

            // Generate the QR code and asset details for the current asset
            const qrCodeHtml = ReactDOMServer.renderToStaticMarkup(
                <QRCodeWithLogo value={asset.assetTagId} category={asset.categoryDescription} />
            );

            const qrCodeContainer = document.createElement('div');
            qrCodeContainer.style.marginBottom = '20px';
            qrCodeContainer.innerHTML = qrCodeHtml;
            pdfContent.appendChild(qrCodeContainer);

            document.body.appendChild(pdfContent);

            html2canvas(pdfContent).then(canvas => {
                const imgData = canvas.toDataURL('image/png');

                // Add the image to the PDF
                if (index > 0) {
                    pdf.addPage(); // Add a new page for each asset after the first
                }
                pdf.addImage(imgData, 'PNG', 10, 10);

                // Cleanup the DOM
                document.body.removeChild(pdfContent);

                // If this is the last asset, save the PDF
                if (index === selectedAssets.length - 1) {
                    const pdfBlob = pdf.output('blob');
                    saveAs(pdfBlob, `asset_barcodes.pdf`);
                }
            });
        });
    };


    useEffect(() => {
        if (searchTerm === '') {
            setFilteredAssets(assets); // Show all assets if no search term
        } else {
            const filtered = assets.filter(asset =>
                asset.assetTagId.toLowerCase().includes(searchTerm.toLowerCase()) ||
                asset.statusHistory.toLowerCase().includes(searchTerm.toLowerCase()) ||
                asset.categoryDescription.toLowerCase().includes(searchTerm.toLowerCase()) ||
                asset.assetDescription.toLowerCase().includes(searchTerm.toLowerCase()) ||
                asset.siteDescription.toLowerCase().includes(searchTerm.toLowerCase()) ||
                asset.locationDescription.toLowerCase().includes(searchTerm.toLowerCase())
            );
            setFilteredAssets(filtered); // Set the filtered assets
        }
    }, [searchTerm, assets]);

    const columns = [
        {
            name: 'Select',
            cell: row => (
                <input
                    type="checkbox"
                    checked={row.selected || false}
                    onChange={() => handleCheckboxChange(row.assetTagId)}
                    className="cursor-pointer"
                />
            ),
            ignoreRowClick: true,
            allowOverflow: true,
            button: true,
        },
        {
            name: 'Tag No',
            selector: row => row.assetTagId,
            sortable: true,
            cell: row => (
                <span
                    className="text-blue-600 hover:underline cursor-pointer"
                    onClick={() => handleTagClick(row)}
                >
                    {row.assetTagId}
                </span>
            ),
        },
        //{
        //    name: 'Status',
        //    selector: row => row.statusHistory,
        //    sortable: true,
        //},
        {
            name: 'Category',
            selector: row => row.categoryDescription,
            sortable: true,
        },
        { //Status description 
            name: 'Status',
            selector: row => row.assetDescription,
            sortable: true,
        },
        {
            name: 'Site',
            selector: row => row.siteDescription,
            sortable: true,
        },
        {
            name: 'Location',
            selector: row => row.locationDescription,
            sortable: true,
        },
    ];

    return (
        <div className="p-6 bg-gray-100 min-h-screen">
            <div className="flex justify-between items-center mb-6 relative">
                <h2 className="text-2xl font-bold text-gray-800">View Assets</h2>
                <div className="flex items-center space-x-4">
                    <input
                        type="text"
                        placeholder="Search..."
                        className="border rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-blue-500 transition"
                        value={searchTerm}
                        onChange={handleSearch}
                    />
                    <button className="px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition">
                        + Add Asset
                    </button>
                </div>

                <div className="relative">
                    <button
                        className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition"
                        onClick={toggleDropdown}
                    >
                        Options
                    </button>
                    {dropdownOpen && (
                        <div className="absolute right-0 bg-white border border-gray-300 rounded-lg shadow-lg mt-2 z-10">
                            <button
                                className="block w-full px-4 py-2 text-gray-700 hover:bg-gray-100"
                                onClick={() => handleDropdownAction('Generate Barcode')}
                            >
                                Generate Barcode
                            </button>
                        </div>
                    )}
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

export { AssetTable };

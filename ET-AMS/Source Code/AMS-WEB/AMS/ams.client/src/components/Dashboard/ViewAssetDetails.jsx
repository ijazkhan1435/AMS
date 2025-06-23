import React, { useEffect, useState, useMemo } from 'react';
import DataTable from 'react-data-table-component';
import logo from '../../Images/EmergTechLogo.jpeg';
import ReactDOMServer from 'react-dom/server';
import jsPDF from 'jspdf';
import html2canvas from 'html2canvas';
import { QRCodeSVG } from 'qrcode.react';
import { saveAs } from 'file-saver';
import { Link } from 'react-router-dom';
import { useTable, usePagination, useSortBy } from 'react-table';
import { useParams } from 'react-router-dom';

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

const AssetDetails = ({}) => {
    const [selectedAsset, setDetailedAsset] = useState({});
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const { assetTagID } = useParams();

        useEffect(() => {
        
        const fetchAssetDetails = async () => {
            try {

                const encodeassetTagID = encodeURIComponent(assetTagID);
                const response = await fetch(`http://localhost:7243/api/Location/GetAllViewAssets?assetTagID=${encodeassetTagID}`);
                if (!response.ok) {
                    throw new Error(`HTTP error! Status: ${response.status}`);
                }
                const data = await response.json();
                const selectedAsset = data.find(item => item.assetTagID === encodeassetTagID);
                setDetailedAsset(selectedAsset || {});
            } catch (error) {
                setError(error.message || 'An error occurred while fetching data.');
            } finally {
                setLoading(false);
            }
        };

        fetchAssetDetails();
    }, [assetTagID]);

    if (!assetTagID) return null;

    // Define columns for react-data-table-component
    const columns = useMemo(() => {
        return Object.keys(selectedAsset).map(key => ({
            name: key.replace(/([A-Z])/g, ' $1').replace(/^./, str => str.toUpperCase()),
            selector: row => row[key],
            sortable: true,
        }));
    }, [selectedAsset]);

    // Data for the table
    const data = useMemo(() => [selectedAsset], [selectedAsset]);

    return (
        <div className="p-6 max-w-6xl mx-auto bg-white shadow-lg rounded-lg">
            <h3 className="text-2xl font-semibold mb-4 text-gray-800">Asset Details</h3>
            {loading ? (
                <p className="text-center text-gray-600">Loading...</p>
            ) : error ? (
                <p className="text-red-500 text-center">{error}</p>
            ) : (
                <div>
                    <DataTable
                        columns={columns}
                        data={data}
                        pagination
                        paginationPerPage={5}
                        paginationRowsPerPageOptions={[5, 10, 20]}
                        highlightOnHover
                        responsive
                        sortable
                    />
                </div>
            )}
        </div>
    );
};

export { AssetDetails };
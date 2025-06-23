import { useParams } from 'react-router-dom';
import { useEffect, useState, useMemo } from 'react';
import moment from 'moment';
import DataTable from 'react-data-table-component';
import { FaCheck, FaTimes, FaMapMarkerAlt, FaPlus } from 'react-icons/fa'; // Import icons from react-icons

const ReportDetail = () => {
    const { auditDateTime } = useParams();
    const [assetDetail, setAssetDetail] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const [filterStatus, setFilterStatus] = useState('All'); // State to store the filter status

    useEffect(() => {
        const fetchAssetDetail = async () => {
            try {
                setLoading(true);
                const response = await fetch(`http://localhost:7243/api/ReportsDetailPage/GetAuditReportDetailsByDateTime?auditDateTime=${encodeURIComponent(auditDateTime)}`);
                if (!response.ok) {
                    throw new Error('Failed to fetch asset details');
                }
                const data = await response.json();
                setAssetDetail(data); // Assume data is an array of objects
            } catch (error) {
                setError(error.message);
            } finally {
                setLoading(false);
            }
        };

        if (auditDateTime) {
            fetchAssetDetail();
        }
    }, [auditDateTime]);

    // Filter asset details based on the selected filterStatus
    const filteredAssetDetail = useMemo(() => {
        if (filterStatus === 'All') {
            return assetDetail;
        }
        return assetDetail.filter(item => item.auditStatus === filterStatus);
    }, [assetDetail, filterStatus]);

    // Define columns for DataTable
    const columns = useMemo(() => [
        //{
        //    name: 'Audit Report Detail ID',
        //    selector: row => row.auditReportDetailId || 'N/A',
        //    sortable: true,
        //},
        {
            name: 'Asset ID',
            selector: row => row.assetID || 'N/A',
            sortable: true,
        },
        {
            name: 'Audit Status',
            selector: row => row.auditStatus || 'N/A',
            sortable: true,
        },
        {
            name: 'Location',
            selector: row => row.location || 'N/A',
            sortable: true,
        },
        {
            name: 'Site',
            selector: row => row.siteDescription || 'N/A',
            sortable: true,
        },
        {
            name: 'Email',
            selector: row => row.email || 'N/A',
            sortable: true,
        },
        {
            name: 'First Name',
            selector: row => row.firstName || 'N/A',
            sortable: true,
        },
        {
            name: 'Last Name',
            selector: row => row.lastName || 'N/A',
            sortable: true,
        },
    ], []);

    if (loading) {
        return <div>Loading...</div>;
    }

    if (error) {
        return <div>Error: {error}</div>;
    }

    if (assetDetail.length === 0) {
        return <div>No Report details available.</div>;
    }

    return (
        <div className="p-6 max-w-8xl mx-auto bg-white shadow-lg rounded-lg">
            <h2 className="text-2xl font-bold text-gray-800 mb-4">
                Report Detail for Audit Date Time: {moment(auditDateTime).format('YYYY-MM-DD HH:mm:ss')}
            </h2>

            
            <div className="border border-gray-300 rounded p-4 mb-4 bg-gray-50">
                <div className="flex space-x-4">
                    <button
                        onClick={() => setFilterStatus('Found')} 
                        className="bg-white text-black border border-gray-300 rounded px-4 py-2 flex items-center justify-center hover:bg-gray-100"
                    >
                        <FaCheck className="mr-2" /> Found
                    </button>
                    <button
                        onClick={() => setFilterStatus('Missing')} 
                        className="bg-white text-black border border-gray-300 rounded px-4 py-2 flex items-center justify-center hover:bg-gray-100"
                    >
                        <FaTimes className="mr-2" /> Missing
                    </button>
                    <button
                        onClick={() => setFilterStatus('Misplaced')} 
                        className="bg-white text-black border border-gray-300 rounded px-4 py-2 flex items-center justify-center hover:bg-gray-100"
                    >
                        <FaMapMarkerAlt className="mr-2" /> Misplaced
                    </button>
                    <button
                        onClick={() => setFilterStatus('All')} 
                        className="bg-white text-black border border-gray-300 rounded px-4 py-2 flex items-center justify-center hover:bg-gray-100"
                    >
                        <FaPlus className="mr-2" /> Show All
                    </button>
                </div>
            </div>

            {/* DataTable with filtered data */}
            <DataTable
                columns={columns}
                data={filteredAssetDetail} // Use the filtered data based on filterStatus
                pagination
                highlightOnHover
                striped
                noDataComponent={<div className="text-center text-gray-500">No Report details available.</div>}
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
        </div>
    );
};

export { ReportDetail };

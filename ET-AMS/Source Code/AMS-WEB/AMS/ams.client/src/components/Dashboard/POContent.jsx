import React from 'react';

function POContent({ darkMode }) {

    const BtnPost = () => {
        alert('BtnPost clicked');
    };

    const BtnRefresh = () => {
        alert(' Refresh Clicked ');
    }
    const BtnPrint = () => {
        alert('Print Clickesd');
    }

    return (
        <div className={`flex-grow p-6 overflow-y-auto ${darkMode ? 'bg-gray-900' : 'bg-gray-100'}`}>
            <h1 className={`text-2xl font-bold mb-4 ${darkMode ? 'text-white' : 'text-black'}`}>Purchase Order</h1>

            <div className="grid grid-cols-6 gap-4 mb-4">
                <input className={`p-2 border rounded ${darkMode ? 'bg-gray-800 border-gray-700 text-white' : 'bg-white border-gray-300'}`} placeholder="Purchase Order" />
                <input className={`p-2 border rounded ${darkMode ? 'bg-gray-800 border-gray-700 text-white' : 'bg-white border-gray-300'}`} placeholder="PO Description" />
                <input className={`p-2 border rounded ${darkMode ? 'bg-gray-800 border-gray-700 text-white' : 'bg-white border-gray-300'}`} placeholder="PO Date" />
                <input className={`p-2 border rounded ${darkMode ? 'bg-gray-800 border-gray-700 text-white' : 'bg-white border-gray-300'}`} placeholder="Warehouse" />
                <input className={`p-2 border rounded ${darkMode ? 'bg-gray-800 border-gray-700 text-white' : 'bg-white border-gray-300'}`} placeholder="Request" />
                <input className={`p-2 border rounded ${darkMode ? 'bg-gray-800 border-gray-700 text-white' : 'bg-white border-gray-300'}`} placeholder="Supplier" />
                
                <div className="flex items-center flex-nowrap">
                    <label className="mr-2 whitespace-nowrap"><b>PO Status</b></label>
                    <select className={`p-2 border rounded ${darkMode ? 'bg-gray-800 border-gray-700 text-white' : 'bg-white border-gray-300'}`}>
                        <option value="Select">Select</option>
                        <option value="New">New</option>
                        <option value="Pending">Pending</option>
                        <option value="Completed">Completed</option>
                    </select>
                </div>




            </div>

            <div className="overflow-x-auto mb-4">
                <table className={`min-w-full ${darkMode ? 'bg-gray-800 text-white' : 'bg-white text-black'}`}>
                    <thead>
                        <tr>
                            {['S.no', 'Item Code', 'Barcode', 'Item Name', 'Quantity', 'Cost Price', 'Discount', 'Tax', 'Total'].map((header) => (
                                <th key={header} className={`p-2 border ${darkMode ? 'border-gray-700' : 'border-gray-300'}`}>{header}</th>
                            ))}
                        </tr>
                    </thead>
                    <tbody>
                        {[1, 2, 3, 4, 5, 6].map((item) => (
                            <tr key={item}>
                                <td className={`p-2 border ${darkMode ? 'border-gray-700' : 'border-gray-300'}`}>{item}</td>
                                <td className={`p-2 border ${darkMode ? 'border-gray-700' : 'border-gray-300'}`}></td>
                                <td className={`p-2 border ${darkMode ? 'border-gray-700' : 'border-gray-300'}`}></td>
                                <td className={`p-2 border ${darkMode ? 'border-gray-700' : 'border-gray-300'}`}></td>
                                <td className={`p-2 border ${darkMode ? 'border-gray-700' : 'border-gray-300'}`}></td>
                                <td className={`p-2 border ${darkMode ? 'border-gray-700' : 'border-gray-300'}`}></td>
                                <td className={`p-2 border ${darkMode ? 'border-gray-700' : 'border-gray-300'}`}></td>
                                <td className={`p-2 border ${darkMode ? 'border-gray-700' : 'border-gray-300'}`}></td>
                                <td className={`p-2 border ${darkMode ? 'border-gray-700' : 'border-gray-300'}`}></td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            </div>

            <div className="grid grid-cols-4 gap-4 mb-4">
                <input className={`p-2 border rounded ${darkMode ? 'bg-gray-800 border-gray-700 text-white' : 'bg-white border-gray-300'}`} placeholder="Total Quantity" />
                <input className={`p-2 border rounded ${darkMode ? 'bg-gray-800 border-gray-700 text-white' : 'bg-white border-gray-300'}`} placeholder="Total Discount" />
                <input className={`p-2 border rounded ${darkMode ? 'bg-gray-800 border-gray-700 text-white' : 'bg-white border-gray-300'}`} placeholder="Additional Charges" />
                <input className={`p-2 border rounded ${darkMode ? 'bg-gray-800 border-gray-700 text-white' : 'bg-white border-gray-300'}`} placeholder="Remarks" />
            </div>

            <div className="justify-start flex space-x-4 mt-4">
                <button onClick={BtnRefresh} className="bg-green-500 text-white p-2 rounded">Refresh</button>
                <button onClick={BtnPost} className="bg-green-500 text-white p-2 rounded">Post</button>
                <button onClick={BtnPrint} className="bg-green-500 text-white p-2 rounded">Print</button>
            </div>

        </div>
    );
}

export default POContent;

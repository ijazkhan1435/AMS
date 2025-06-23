import React from 'react';

function GRNContent({ darkMode }) {

    const BtnPOReferenceClick = () => {
        alert('PO Reference clicked');
    };

    const BtnPrintPageClick = () => {
        alert('Print Page clicked');
    };

    return (
        <div className={`p-8 ${darkMode ? 'bg-gray-900' : 'bg-gray-100'}`}>
            <h1 className={`text-2xl font-bold mb-4 ${darkMode ? 'text-white' : 'text-black'}`}>GRN Screen</h1>

            <div className={`p-6 rounded shadow-md mb-4 ${darkMode ? 'bg-gray-800' : 'bg-white'}`}>
                <div className="grid grid-cols-2 gap-4 mb-4">
                    <input
                        type="text"
                        placeholder="Invoice Date"
                        className={`p-2 border rounded ${darkMode ? 'bg-gray-700 text-white' : ''}`}
                    />
                    <input
                        type="text"
                        placeholder="Posting Date"
                        className={`p-2 border rounded ${darkMode ? 'bg-gray-700 text-white' : 'bg-white'}`}
                    />
                    <input
                        type="text"
                        placeholder="Reference"
                        className={`p-2 border rounded ${darkMode ? 'bg-gray-700 text-white' : 'bg-white'}`}
                    />
                    <input
                        type="text"
                        placeholder="Supplier"
                        className={`p-2 border rounded ${darkMode ? 'bg-gray-700 text-white' : 'bg-white'}`}
                    />
                </div>

                <input
                    type="text"
                    placeholder="Search..."
                    className={`p-2 border rounded w-full mb-4 ${darkMode ? 'bg-gray-700 text-white' : 'bg-white'}`}
                />

                <table className={`w-full border rounded shadow ${darkMode ? 'bg-gray-800' : 'bg-white'}`}>
                    <thead>
                        <tr className={`${darkMode ? 'bg-gray-700 text-white' : 'bg-gray-200'}`}>
                            <th className="p-2 border text-center"><input type="checkbox" /></th>
                            <th className="p-2 border text-center">Item</th>
                            <th className="p-2 border text-center">Amount</th>
                            <th className="p-2 border text-center">PO Text</th>
                            <th className="p-2 border text-center">Quantity</th>
                            <th className="p-2 border text-center">Purchase Order</th>
                            <th className="p-2 border text-center">Sender</th>
                            <th className="p-2 border text-center">Receiver</th>
                            <th className="p-2 border text-center">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td className="p-2 border text-center"><input type="checkbox" /></td>
                            <td className={`p-2 border text-center ${darkMode ? 'text-white' : 'text-black'}`}>#1001</td>
                            <td className={`p-2 border text-center ${darkMode ? 'text-white' : 'text-black'}`}>1000</td>
                            <td className={`p-2 border text-center ${darkMode ? 'text-white' : 'text-black'}`}>21000</td>
                            <td className={`p-2 border text-center ${darkMode ? 'text-white' : 'text-black'}`}>20</td>
                            <td className={`p-2 border text-center ${darkMode ? 'text-white' : 'text-black'}`}>5</td>
                            <td className={`p-2 border text-center ${darkMode ? 'text-white' : 'text-black'}`}>Ahtsham</td>
                            <td className={`p-2 border text-center ${darkMode ? 'text-white' : 'text-black'}`}>Hassan</td>
                            <td className={`p-2 border text-center ${darkMode ? 'text-white' : 'text-black'}`}>Done</td>
                        </tr>
                    </tbody>
                </table>

            </div>

            <div className="flex space-x-4 ">
                <button onClick={BtnPOReferenceClick} className="bg-green-500 text-white py-2 px-4 rounded">PO Reference</button>
                <button onClick={BtnPrintPageClick}  className="bg-green-500 text-white py-2 px-4 rounded">Print Page</button>
            </div>
        </div>
    );
}

export default GRNContent;

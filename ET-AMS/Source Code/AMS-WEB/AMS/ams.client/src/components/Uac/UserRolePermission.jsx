import React, { useState } from 'react';

function UserRolePermission({ darkMode }) {
    // Sample roles for the dropdown
    const roles = ["Admin", "Editor", "Viewer"];

    // State for selected role
    const [selectedRole, setSelectedRole] = useState(roles[0]);

    // State for table data
    const [tableData, setTableData] = useState([
        { serialNo: 1, module: "Module 1", permission: "Read", activation: false },
        { serialNo: 2, module: "Module 2", permission: "Write", activation: false }
    ]);

    const handleRoleChange = (e) => {
        setSelectedRole(e.target.value);
    };

    const handleCheckboxChange = (index) => {
        const newTableData = [...tableData];
        newTableData[index].activation = !newTableData[index].activation;
        setTableData(newTableData);
    };

    const handleSave = () => {
        console.log("Saved Data:", { selectedRole, tableData });
    };

    const handleReset = () => {
        setSelectedRole(roles[0]);
        setTableData([
            { serialNo: 1, module: "Module 1", permission: "Read", activation: false },
            { serialNo: 2, module: "Module 2", permission: "Write", activation: false }
        ]);
    };

    return (
        <div className={`p-8 ${darkMode ? 'bg-gray-900' : 'bg-gray-100'}`}>
            <h1 className={`text-2xl font-bold mb-4 ${darkMode ? 'text-white' : 'text-black'}`}>UserRolePermission</h1>

            {/* Dropdown for user roles */}
            <div className="mb-4">
                <label className={`block text-lg ${darkMode ? 'text-white' : 'text-black'}`}>User Role:</label>
                <select
                    value={selectedRole}
                    onChange={handleRoleChange}
                    className={`mt-2 p-2 border rounded ${darkMode ? 'bg-gray-700 text-white border-gray-600' : 'border-gray-300'}`}
                >
                    {roles.map(role => (
                        <option key={role} value={role}>{role}</option>
                    ))}
                </select>
            </div>

            {/* Table */}
            <table className={`min-w-full rounded shadow-md ${darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-300'}`}>
                <thead>
                    <tr>
                        <th className="border border-gray-300 p-2">Serial No</th>
                        <th className="border border-gray-300 p-2">Module</th>
                        <th className="border border-gray-300 p-2">Permission</th>
                        <th className="border border-gray-300 p-2">Activation</th>
                    </tr>
                </thead>
                <tbody>
                    {tableData.map((row, index) => (
                        <tr key={row.serialNo}>
                            <td className="border border-gray-300 p-2">{row.serialNo}</td>
                            <td className="border border-gray-300 p-2">{row.module}</td>
                            <td className="border border-gray-300 p-2">{row.permission}</td>
                            <td className="border border-gray-300 p-2">
                                <input
                                    type="checkbox"
                                    checked={row.activation}
                                    onChange={() => handleCheckboxChange(index)}
                                />
                            </td>
                        </tr>
                    ))}
                </tbody>
            </table>

            {/* Buttons */}
            <div className="mt-4 flex justify-center space-x-4">
                <button
                    onClick={handleSave}
                    className={`p-2 text-white rounded ${darkMode ? 'bg-blue-500' : 'bg-blue-700'}`}
                >
                    Save
                </button>
                <button
                    onClick={handleReset}
                    className={`bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline ${darkMode ? 'bg-gray-500' : 'bg-gray-500'}`}
                >
                    Reset
                </button>
            </div>
        </div>
    );
}

export default UserRolePermission;

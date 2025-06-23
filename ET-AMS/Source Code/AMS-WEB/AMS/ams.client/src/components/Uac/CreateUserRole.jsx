import React, { useState } from 'react';
import { useTable, usePagination } from 'react-table';

function CreateUserRole({ darkMode }) {
    const [roles, setRoles] = useState([
        { serialNo: 1, description: 'Admin', createdBy: 'John Doe' },
        { serialNo: 2, description: 'User', createdBy: 'Jane Smith' },
        { serialNo: 3, description: 'Manager', createdBy: 'Charlie' },
        { serialNo: 4, description: 'Editor', createdBy: 'Diana' },
        { serialNo: 5, description: 'Viewer', createdBy: 'Edward' },
        { serialNo: 6, description: 'Guest', createdBy: 'Fiona' },
        { serialNo: 7, description: 'Developer', createdBy: 'George' },
        { serialNo: 8, description: 'Designer', createdBy: 'Hannah' },
        { serialNo: 9, description: 'Support', createdBy: 'Ivy' },
        { serialNo: 10, description: 'Analyst', createdBy: 'Jack' },
    ]);

    const [newRole, setNewRole] = useState('');

    const handleSave = () => {
        setRoles([...roles, { serialNo: roles.length + 1, description: newRole, createdBy: 'Admin' }]);
        setNewRole('');
    };

    const handleUpdate = () => {
        // Update role logic here
    };

    const handleDelete = () => {
        // Delete role logic here
    };

    const handleReset = () => {
        setNewRole('');
    };

    const columns = React.useMemo(
        () => [
            { Header: 'Serial No', accessor: 'serialNo' },
            { Header: 'Role Description', accessor: 'description' },
            { Header: 'Created By', accessor: 'createdBy' },
        ],
        []
    );

    const {
        getTableProps,
        getTableBodyProps,
        headerGroups,
        page,
        prepareRow,
        canPreviousPage,
        canNextPage,
        pageOptions,
        gotoPage,
        nextPage,
        previousPage,
        setPageSize,
        state: { pageIndex, pageSize }
    } = useTable(
        {
            columns,
            data: roles,
            initialState: { pageIndex: 0, pageSize: 5 },
        },
        usePagination
    );

    return (
        <div className={`p-8 ${darkMode ? 'bg-gray-900' : 'bg-gray-100'}`}>
            <h1 className={`text-2xl font-bold mb-4 ${darkMode ? 'text-white' : 'text-black'}`}>CreateUserRole</h1>

            <div className="mb-4">
                <label className={`block text-sm font-bold mb-2 ${darkMode ? 'text-gray-300' : 'text-gray-700'}`} htmlFor="roleDescription">
                    Role Description
                </label>
                <input
                    className={`shadow appearance-none border rounded w-full py-2 px-3 leading-tight focus:outline-none focus:shadow-outline ${darkMode ? 'bg-gray-700 text-white border-gray-600' : 'bg-white text-gray-700 border-gray-300'}`}
                    id="roleDescription"
                    type="text"
                    placeholder="Enter Role Description"
                    value={newRole}
                    onChange={(e) => setNewRole(e.target.value)}
                />
            </div>
<div className="mb-6">
    <table className={`min-w-full rounded shadow-md ${darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-300'}`} {...getTableProps()}>
        <thead>
            {headerGroups.map((headerGroup, index) => (
                <tr key={index} {...headerGroup.getHeaderGroupProps()} className={`${darkMode ? 'bg-gray-700' : 'bg-gray-100'}`}>
                    {headerGroup.headers.map((column, columnIndex) => (
                        <th key={columnIndex} {...column.getHeaderProps()} className={`py-2 px-4 border-b ${darkMode ? 'border-gray-600 text-gray-300' : 'border-gray-300 text-gray-700'} text-left`}>
                            {column.render('Header')}
                        </th>
                    ))}
                </tr>
            ))}
        </thead>
        <tbody {...getTableBodyProps()}>
            {page.map((row, rowIndex) => {
                prepareRow(row);
                return (
                    <tr key={rowIndex} {...row.getRowProps()} className={darkMode ? 'bg-gray-900' : 'bg-white'}>
                        {row.cells.map((cell, cellIndex) => (
                            <td key={cellIndex} {...cell.getCellProps()} className={`py-2 px-4 border-b ${darkMode ? 'border-gray-700 text-gray-300' : 'border-gray-300 text-gray-700'}`}>
                                {cell.render('Cell')}
                            </td>
                        ))}
                    </tr>
                );
            })}
        </tbody>
    </table>
</div>


            <div className="flex items-center justify-between mt-4">
                <button
                    className={`bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline ${darkMode ? 'bg-blue-600' : 'bg-blue-500'}`}
                    type="button"
                    onClick={handleSave}
                >
                    Save
                </button>
                <button
                    className={`bg-yellow-500 hover:bg-yellow-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline ${darkMode ? 'bg-yellow-600' : 'bg-yellow-500'}`}
                    type="button"
                    onClick={handleUpdate}
                >
                    Update
                </button>
                <button
                    className={`bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline ${darkMode ? 'bg-red-600' : 'bg-red-500'}`}
                    type="button"
                    onClick={handleDelete}
                >
                    Delete
                </button>
                <button
                    className={`bg-gray-500 hover:bg-gray-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline ${darkMode ? 'bg-gray-600' : 'bg-gray-500'}`}
                    type="button"
                    onClick={handleReset}
                >
                    Reset
                </button>
            </div>

            {/* Pagination Controls */}
            <div className="flex items-center justify-center mt-4">
                <button
                    className={`bg-gray-500 hover:bg-gray-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline mx-1 ${darkMode ? 'bg-gray-600' : 'bg-gray-500'}`}
                    onClick={() => gotoPage(0)}
                    disabled={!canPreviousPage}
                >
                    {'<<'}
                </button>
                <button
                    className={`bg-gray-500 hover:bg-gray-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline mx-1 ${darkMode ? 'bg-gray-600' : 'bg-gray-500'}`}
                    onClick={() => previousPage()}
                    disabled={!canPreviousPage}
                >
                    {'<'}
                </button>
                <button
                    className={`bg-gray-500 hover:bg-gray-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline mx-1 ${darkMode ? 'bg-gray-600' : 'bg-gray-500'}`}
                    onClick={() => nextPage()}
                    disabled={!canNextPage}
                >
                    {'>'}
                </button>
                <button
                    className={`bg-gray-500 hover:bg-gray-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline mx-1 ${darkMode ? 'bg-gray-600' : 'bg-gray-500'}`}
                    onClick={() => gotoPage(pageOptions.length - 1)}
                    disabled={!canNextPage}
                >
                    {'>>'}
                </button>
            </div>
        </div>
    );
}

export default CreateUserRole;
